import "package:aad_oauth/model/config.dart";
import "package:bloc/bloc.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";
import "package:supa_architecture/extensions/dotenv.dart";
import "package:supa_architecture/models/models.dart";
import "package:supa_architecture/repositories/portal_authentication_repository.dart";
import "package:supa_architecture/repositories/portal_profile_repository.dart";
import "package:aad_oauth/aad_oauth.dart";

part "authentication_action.dart";
part "authentication_event.dart";
part "authentication_state.dart";

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final authRepo = PortalAuthenticationRepository();

  final profileRepo = PortalProfileRepository();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>["email"],
    signInOption: SignInOption.standard,
  );

  late final AadOAuth oauth;

  AadOAuth configureAzureAD(
      GlobalKey<NavigatorState> navigatorKey, String redirectUri) {
    Config config = Config(
      tenant: dotenv.azureTenantId!,
      clientId: dotenv.azureClientId!,
      scope: "openid profile offline_access",
      // redirectUri is Optional as a default is calculated based on app type/web location
      redirectUri: redirectUri,
      navigatorKey: navigatorKey,
      webUseRedirect:
          true, // default is false - on web only, forces a redirect flow instead of popup auth
      //Optional parameter: Centered CircularProgressIndicator while rendering web page in WebView
      loader: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    oauth = AadOAuth(config);

    return oauth;
  }

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationInitializeEvent>(_onAuthenticationInitializeEvent);
    on<AuthenticationProcessingEvent>(_onAuthenticationProcessingEvent);
    on<LoginWithGoogleEvent>(_onLoginWithGoogleEvent);
    on<LoginWithAppleEvent>(_onLoginWithAppleEvent);
    on<LoginWithMicrosoftEvent>(_onLoginWithMicrosoftEvent);
    on<LoginWithPasswordEvent>(_onLoginWithPasswordEvent);
    on<LoginWithSavedLoginEvent>(_onLoginWithSavedLogin);
    on<UserLogoutEvent>(_onUserLogoutEvent);
    on<LoginWithSelectedTenantEvent>(_onLoginWithSelectedTenantEvent);
    on<LoginWithMultipleTenantsEvent>(_onLoginWithMultipleTenantsEvent);
    on<AuthenticationErrorEvent>(_onAuthenticationErrorEvent);
    on<UsingSavedAuthenticationEvent>(_onUsingSavedAuthentication);
    on<UpdateAppUserProfileEvent>(_onUpdateAppUserProfileEvent);
    on<AppUserSwitchEmailEvent>(_onAppUserSwitchEmailEvent);
    on<AppUserSwitchNotificationEvent>(_onAppUserSwitchNotificationEvent);
  }

  Future<void> _onUpdateAppUserProfileEvent(
    UpdateAppUserProfileEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state is UserAuthenticatedWithSelectedTenantState) {
      final tenant = (state as UserAuthenticatedWithSelectedTenantState).tenant;
      final user = event.user;
      emit(UserAuthenticatedWithSelectedTenantState(
        user: user,
        tenant: tenant,
      ));
      await _saveAuthentication(user, tenant);
    }
  }

  Future<void> _saveAuthentication(AppUser user, Tenant tenant) async {
    try {
      await authRepo.saveAuthentication(user, tenant);
    } catch (error) {
      debugPrint('Saving authentication failed: $error');
    }
  }

  Future<void> _onAuthenticationInitializeEvent(
    AuthenticationInitializeEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInitialState());
  }

  Future<void> _onUsingSavedAuthentication(
    UsingSavedAuthenticationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(UserAuthenticatedWithSelectedTenantState(
      tenant: event.tenant,
      user: event.user,
    ));
  }

  Future<void> _onAuthenticationErrorEvent(
    AuthenticationErrorEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationErrorState(
      title: event.title,
      message: event.message,
      error: event.error,
    ));
  }

  Future<void> handleInitialize() async {
    add(const AuthenticationProcessingEvent(AuthenticationAction.initialize));
    final authentication = await authRepo.loadAuthentication();

    if (authentication != null) {
      add(UsingSavedAuthenticationEvent(
        tenant: authentication.tenant,
        user: authentication.appUser,
      ));
      return;
    }

    add(AuthenticationInitializeEvent());
  }

  void _onAuthenticationProcessingEvent(
    AuthenticationProcessingEvent event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(AuthenticationProcessingState(event.action));
  }

  Future<void> handleLoginWithTenants(List<Tenant> tenants) async {
    if (tenants.isNotEmpty) {
      if (tenants.length == 1) {
        add(LoginWithSelectedTenantEvent(tenant: tenants.first));
        return;
      }

      add(LoginWithMultipleTenantsEvent(tenants));
      return;
    }

    add(const AuthenticationErrorEvent(
      title: 'Không tìm thấy ứng dụng',
      message: 'Không tìm thấy ứng dụng được phép truy cập',
      error: null,
    ));
  }

  Future<void> _onLoginWithGoogleEvent(
    LoginWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      add(const AuthenticationProcessingEvent(
          AuthenticationAction.loginWithGoogle));

      final bool isSignedIn = await googleSignIn.isSignedIn();
      if (isSignedIn) {
        await googleSignIn.disconnect();
      }

      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        emit(AuthenticationInitialState());
        return;
      }

      final googleKey = await account.authentication;
      if (googleKey.idToken != null || googleKey.accessToken != null) {
        final List<Tenant> tenants = await authRepo
            .loginWithGoogle(googleKey.idToken ?? googleKey.accessToken!);

        handleLoginWithTenants(tenants);
      }
    } catch (error) {
      add(AuthenticationErrorEvent(
        title: "Đăng nhập Google lỗi",
        message: "Đã xảy ra lỗi khi đăng nhập với Google",
        error: error,
      ));
    }
  }

  Future<void> _onLoginWithAppleEvent(
    LoginWithAppleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      add(const AuthenticationProcessingEvent(
          AuthenticationAction.loginWithApple));

      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      final tenants = await authRepo.loginWithApple(credential.identityToken!);
      handleLoginWithTenants(tenants);
    } catch (error) {
      add(AuthenticationErrorEvent(
        title: "Đăng nhập Apple lỗi",
        message: "Đã xảy ra lỗi khi đăng nhập với Apple",
        error: error,
      ));
    }
  }

  _tryLogoutMicrosoft() async {
    try {
      await oauth.logout();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _onLoginWithMicrosoftEvent(
    LoginWithMicrosoftEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      add(const AuthenticationProcessingEvent(
        AuthenticationAction.loginWithMicrosoft,
      ));

      await _tryLogoutMicrosoft();

      final result = await oauth.login();

      result.fold(
        (failure) {
          add(AuthenticationErrorEvent(
            title: "Đăng nhập Microsoft lỗi",
            message: "Đã xảy ra lỗi khi đăng nhập với Microsoft",
            error: failure,
          ));
        },
        (token) {
          debugPrint('MICROSOFT TOKEN: $token');
        },
      );

      final idToken = await oauth.getAccessToken();

      if (idToken == null) {
        emit(const AuthenticationErrorState(
          title: 'Không thể đăng nhập',
          message: 'Không thể lấy thông tin đăng nhập từ Microsoft',
          error: null,
        ));
        return;
      }

      final List<Tenant> tenants = await authRepo.loginWithMicrosoft(idToken);
      handleLoginWithTenants(tenants);
    } catch (error) {
      add(AuthenticationErrorEvent(
        title: "Đăng nhập Microsoft lỗi",
        message: "Đã xảy ra lỗi khi đăng nhập với Microsoft",
        error: error,
      ));
    }
  }

  Future<void> _onLoginWithPasswordEvent(
    LoginWithPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      add(const AuthenticationProcessingEvent(
          AuthenticationAction.loginWithPassword));

      final tenants = await authRepo.login(event.email, event.password);
      handleLoginWithTenants(tenants);
    } catch (error) {
      add(AuthenticationErrorEvent(
        title: "Đăng nhập lỗi",
        message: "Đã xảy ra lỗi khi đăng nhập",
        error: error,
      ));
    }
  }

  Future<void> _onLoginWithSavedLogin(
    LoginWithSavedLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      add(const AuthenticationProcessingEvent(
          AuthenticationAction.loginWithBiometrics));

      final tenants = await authRepo.loginWithBiometric();
      handleLoginWithTenants(tenants);
    } catch (error) {
      add(AuthenticationErrorEvent(
        title: "Đăng nhập lỗi",
        message: "Đã xảy ra lỗi khi đăng nhập",
        error: error,
      ));
    }
  }

  _logoutThirdParty() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await oauth.logout();
  }

  Future<void> _onUserLogoutEvent(
    UserLogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInitialState());
    try {
      await authRepo.logout();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _onLoginWithSelectedTenantEvent(
    LoginWithSelectedTenantEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await authRepo.createToken(event.tenant);
    final user = await authRepo.getProfileInfo();
    emit(UserAuthenticatedWithSelectedTenantState(
      user: user,
      tenant: event.tenant,
    ));
    await _saveAuthentication(user, event.tenant);
  }

  Future<void> _onLoginWithMultipleTenantsEvent(
    LoginWithMultipleTenantsEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(UserAuthenticatedWithMultipleTenantsState(
      tenants: event.tenants,
    ));
  }

  Future<void> _onAppUserSwitchEmailEvent(
    AppUserSwitchEmailEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state is UserAuthenticatedWithSelectedTenantState) {
      final tenant = (state as UserAuthenticatedWithSelectedTenantState).tenant;
      final user = (state as UserAuthenticatedWithSelectedTenantState).user;

      await profileRepo.switchEmail(user).then((updatedUser) {
        emit(UserAuthenticatedWithSelectedTenantState(
          user: user
            ..receivingSystemEmail.value =
                updatedUser.receivingSystemEmail.value,
          tenant: tenant,
        ));
      }).catchError((error) {
        add(AuthenticationErrorEvent(
          title: "Cập nhật không thành công",
          message:
              "Cập nhật trạng thái nhận thông báo qua email không thành công",
          error: error,
        ));
      });
    }
  }

  Future<void> _onAppUserSwitchNotificationEvent(
    AppUserSwitchNotificationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state is UserAuthenticatedWithSelectedTenantState) {
      final tenant = (state as UserAuthenticatedWithSelectedTenantState).tenant;
      final user = (state as UserAuthenticatedWithSelectedTenantState).user;

      await profileRepo.switchNotification(user).then((updatedUser) {
        emit(UserAuthenticatedWithSelectedTenantState(
          user: user
            ..receivingSystemNotification.value =
                updatedUser.receivingSystemNotification.value,
          tenant: tenant,
        ));
      }).catchError((error) {
        add(AuthenticationErrorEvent(
          title: "Cập nhật không thành công",
          message:
              "Cập nhật trạng thái nhận thông báo qua ứng dụng không thành công",
          error: error,
        ));
      });
    }
  }
}
