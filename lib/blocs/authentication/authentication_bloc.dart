import "package:bloc/bloc.dart";
import "package:flutter/foundation.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:recaptcha_enterprise_flutter/recaptcha.dart";
import "package:recaptcha_enterprise_flutter/recaptcha_action.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";
import "package:supa_architecture/repositories/portal_authentication_repository.dart";
import "package:supa_architecture/supa_architecture.dart";

part "authentication_action.dart";
part "authentication_event.dart";
part "authentication_state.dart";

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  PortalAuthenticationRepository get authRepo =>
      PortalAuthenticationRepository();

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
    on<InitializeWithSavedAuthenticationEvent>(
        _onInitializeWithSavedAuthenticationEvent);
  }

  Future<void> _onAuthenticationInitializeEvent(
    AuthenticationInitializeEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInitialState());
  }

  Future<void> _onInitializeWithSavedAuthenticationEvent(
    InitializeWithSavedAuthenticationEvent event,
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
    final authentication = authRepo.loadAuthentication();
    if (authentication != null) {
      add(InitializeWithSavedAuthenticationEvent(
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

  handleLoginWithTenants(List<Tenant> tenants) async {
    if (tenants.isNotEmpty) {
      if (tenants.length == 1) {
        add(LoginWithSelectedTenantEvent(
          tenant: tenants.first,
        ));
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

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>["email", "profile", "openid"],
        signInOption: SignInOption.standard,
      );

      final bool isSignedIn = await googleSignIn.isSignedIn();
      if (isSignedIn) {
        await googleSignIn.disconnect();
      }

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleKey =
          await account?.authentication;
      if (googleKey?.idToken != null || googleKey?.accessToken != null) {
        final List<Tenant> tenants = await authRepo
            .loginWithGoogle(googleKey!.idToken ?? googleKey.accessToken!);

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

  Future<void> _onLoginWithMicrosoftEvent(
    LoginWithMicrosoftEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      add(const AuthenticationProcessingEvent(
          AuthenticationAction.loginWithMicrosoft));
      await SupaApplication.instance.azureAuth.login();
      final String? accessToken =
          await SupaApplication.instance.azureAuth.getAccessToken();
      if (accessToken != null) {
        final tenants = await authRepo.loginWithMicrosoft(accessToken);
        handleLoginWithTenants(tenants);
        return;
      }
      add(const AuthenticationErrorEvent(
        title: "Đăng nhập Microsoft lỗi",
        message: "Đã xảy ra lỗi khi đăng nhập với Microsoft",
        error: null,
      ));
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

      final username = event.email;
      final password = event.password;

      String captcha;

      if (SupaApplication.instance.useCaptcha) {
        final client = await Recaptcha.fetchClient(
            SupaApplication.instance.captchaConfig.siteKey);
        captcha = await client.execute(RecaptchaAction.LOGIN());
      } else {
        captcha = "";
      }

      final tenants = await authRepo.login(username, password, captcha);
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

  Future<void> _onUserLogoutEvent(
    UserLogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await authRepo.logout();
    emit(AuthenticationInitialState());
  }

  Future<void> _onLoginWithSelectedTenantEvent(
    LoginWithSelectedTenantEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await authRepo.createToken(event.tenant);
    final user = await authRepo.getProfile();
    emit(UserAuthenticatedWithSelectedTenantState(
      user: user,
      tenant: event.tenant,
    ));
    await authRepo.saveAuthentication(user, event.tenant).catchError((error) {
      debugPrint('Saving authentication failed');
    });
  }

  Future<void> _onLoginWithMultipleTenantsEvent(
    LoginWithMultipleTenantsEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(UserAuthenticatedWithMultipleTenantsState(
      tenants: event.tenants,
    ));
  }
}
