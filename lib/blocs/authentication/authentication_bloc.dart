import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supa_architecture/config/get_it.dart';
import 'package:supa_architecture/repositories/portal_authentication_repository.dart';
import 'package:supa_architecture/repositories/portal_profile_repository.dart';
import 'package:supa_architecture/repositories/utils_notification_repository.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'authentication_error.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

/// BLoC for managing authentication state and events.
///
/// This class handles various authentication mechanisms such as
/// password login, Google login, Apple login, Microsoft login, and biometric login.
/// It also manages tenant selection and profile updates.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// The [app] is an instance of [SupaApplication].
  ///
  /// This singleton instance is used to access shared resources and methods.
  SupaApplication get app => SupaApplication.instance;

  /// The [authRepo] is an instance of [PortalAuthenticationRepository].
  ///
  /// This repository is used for handling authentication-related operations.
  /// It provides methods for authenticating with password, Google, Apple,
  /// Microsoft, and biometric login.
  PortalAuthenticationRepository get authRepo =>
      PortalAuthenticationRepository();

  /// The [notiRepo] is an instance of [UtilsNotificationRepository].
  ///
  /// This repository is used for handling notification-related operations.
  /// It provides methods for retrieving notifications and marking them as read.
  UtilsNotificationRepository get notiRepo => UtilsNotificationRepository();

  /// The [profileRepo] is an instance of [PortalProfileRepository].
  ///
  /// This repository is used for handling profile-related operations.
  /// It provides methods for updating user profile information.
  PortalProfileRepository get profileRepo => PortalProfileRepository();

  /// Constructs an instance of [AuthenticationBloc].
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationInitialEvent>(_onInitial);
    on<AuthenticationWithPasswordEvent>(_onPassword);
    on<AuthenticationWithGoogleEvent>(_onGoogleLogin);
    on<AuthenticationWithAppleEvent>(_onAppleLogin);
    on<AuthenticationWithMicrosoftEvent>(_onMicrosoftLogin);
    on<AuthenticationWithBiometricEvent>(_onBiometricLogin);
    on<AuthenticationLogoutEvent>(_onLogout);
    on<AuthenticationErrorEvent>(_onError);
    on<AuthenticationTenantsLoadedEvent>(_onTenantsLoaded);
    on<AuthenticationTenantSelectedEvent>(_onTenantSelected);
    on<AuthenticationFinalEvent>(_onFinal);
    on<AuthenticationTenantChangedEvent>(_onTenantChanged);
  }

  /// Handles switching email notification preference.
  Future<void> handleSwitchEmail(bool value) async {
    final user = (state as AuthenticationSuccess).appUser;
    final tenant = (state as AuthenticationSuccess).tenant;
    user.receivingSystemEmail.value = value;
    add(AuthenticationFinalEvent(appUser: user, tenant: tenant));
    try {
      final appUser = await profileRepo.switchEmail(user);
      add(AuthenticationFinalEvent(appUser: appUser, tenant: tenant));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Handles switching system notification preference.
  Future<void> handleSwitchNotification(bool value) async {
    final user = (state as AuthenticationSuccess).appUser;
    final tenant = (state as AuthenticationSuccess).tenant;
    user.receivingSystemNotification.value = value;
    add(AuthenticationFinalEvent(appUser: user, tenant: tenant));
    try {
      final appUser = await profileRepo.switchNotification(user);
      add(AuthenticationFinalEvent(appUser: appUser, tenant: tenant));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Handles changing the tenant.
  Future<void> handleChangeTenant(Tenant tenant) async {
    await authRepo.createToken(tenant);
    authRepo.changeSavedTenant(tenant);
    add(
      AuthenticationFinalEvent(
        appUser: (state as AuthenticationSuccess).appUser,
        tenant: tenant,
      ),
    );
  }

  /// Initializes the authentication state.
  void handleInitialize() {
    add(AuthenticationInitialEvent());
  }

  /// Handles password login.
  void handleLogin(String username, String password) {
    add(AuthenticationWithPasswordEvent(
        username: username, password: password));
  }

  /// Handles Apple login.
  void handleLoginWithApple() {
    add(AuthenticationWithAppleEvent());
  }

  /// Handles biometric login.
  void handleLoginWithBiometric() {
    add(AuthenticationWithBiometricEvent());
  }

  /// Handles Google login.
  void handleLoginWithGoogle() {
    add(AuthenticationWithGoogleEvent());
  }

  /// Handles Microsoft login.
  void handleLoginWithMicrosoft() {
    add(AuthenticationWithMicrosoftEvent());
  }

  /// Handles logout.
  void handleLogout() {
    add(AuthenticationLogoutEvent());
  }

  /// Handles tenant selection.
  void handleSelectTenant(Tenant tenant) {
    add(AuthenticationTenantSelectedEvent(tenant: tenant));
  }

  /// Handles login with multiple tenants.
  void handleLoginWithTenants(List<Tenant> tenants) {
    add(AuthenticationTenantsLoadedEvent(tenants: tenants));
  }

  /// Handles Apple login event.
  Future<void> _onAppleLogin(AuthenticationWithAppleEvent event,
      Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);
      final tenants = await authRepo.loginWithApple(credential.identityToken!);
      handleLoginWithTenants(tenants);
    } catch (error) {
      getIt.get<ErrorHandlingBloc>().captureException(error);
      add(AuthenticationErrorEvent(error));
    }
  }

  /// Handles biometric login event.
  Future<void> _onBiometricLogin(AuthenticationWithBiometricEvent event,
      Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      final tenants = await authRepo.loginWithBiometric();
      handleLoginWithTenants(tenants);
    } catch (error) {
      getIt.get<ErrorHandlingBloc>().captureException(error);
      add(AuthenticationErrorEvent(error));
    }
  }

  /// Handles error event.
  Future<void> _onError(
    AuthenticationErrorEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationError(event.error));
  }

  /// Handles final authentication event.
  Future<void> _onFinal(
      AuthenticationFinalEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationSuccess(event.tenant, event.appUser));
  }

  /// Handles Google login event.
  Future<void> _onGoogleLogin(AuthenticationWithGoogleEvent event,
      Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[
          'email',
        ],
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
      } else {
        emit(AuthenticationInitial());
      }
    } catch (error) {
      getIt.get<ErrorHandlingBloc>().captureException(error);
      add(AuthenticationErrorEvent(error));
    }
  }

  /// Handles initial authentication event.
  Future<void> _onInitial(AuthenticationInitialEvent event,
      Emitter<AuthenticationState> emit) async {
    final authentication = authRepo.loadAuthentication();

    if (authentication != null) {
      add(AuthenticationFinalEvent(
        appUser: authentication.appUser,
        tenant: authentication.tenant,
      ));
    }
  }

  /// Handles logout event.
  Future<void> _onLogout(AuthenticationLogoutEvent event,
      Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationInitial());
      await authRepo.logout();
    } catch (error) {
      if (error is Exception) {
        add(AuthenticationErrorEvent(error));
      }
    }
  }

  /// Handles Microsoft login event.
  Future<void> _onMicrosoftLogin(AuthenticationWithMicrosoftEvent event,
      Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());
      await app.azureAuth.login();
      final String? accessToken = await app.azureAuth.getAccessToken();
      if (accessToken != null) {
        final tenants = await authRepo.loginWithMicrosoft(accessToken);
        handleLoginWithTenants(tenants);
      }
    } catch (error) {
      add(AuthenticationErrorEvent(error as Exception));
    }
  }

  /// Handles password login event.
  Future<void> _onPassword(AuthenticationWithPasswordEvent event,
      Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationLoading());

      final username = event.username;
      final password = event.password;

      String captcha;

      if (app.useCaptcha) {
        final client = await Recaptcha.fetchClient(app.captchaConfig.siteKey);
        captcha = await client.execute(RecaptchaAction.LOGIN());
      } else {
        captcha = '';
      }

      await authRepo.login(username, password, captcha).then((tenants) {
        return handleLoginWithTenants(tenants);
      }).catchError((error) {
        add(AuthenticationErrorEvent(error));
      });
    } catch (error) {
      add(AuthenticationErrorEvent(error));
    }
  }

  /// Handles tenant changed event.
  Future<void> _onTenantChanged(AuthenticationTenantChangedEvent event,
      Emitter<AuthenticationState> emit) async {
    final tenant = event.tenant;
    authRepo.changeSavedTenant(tenant);
    add(AuthenticationFinalEvent(
      appUser: (state as AuthenticationSuccess).appUser,
      tenant: tenant,
    ));
  }

  /// Handles tenant selected event.
  Future<void> _onTenantSelected(AuthenticationTenantSelectedEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final tenant = event.tenant;
    await authRepo.createToken(tenant);
    final appUser = await authRepo.getProfile();
    add(AuthenticationFinalEvent(
      appUser: appUser,
      tenant: tenant,
    ));
    await authRepo.saveAuthentication(appUser, tenant);
  }

  /// Handles tenants loaded event.
  Future<void> _onTenantsLoaded(AuthenticationTenantsLoadedEvent event,
      Emitter<AuthenticationState> emit) async {
    final tenants = event.tenants;
    if (tenants.length > 1) {
      emit(AuthenticationTenants(tenants));
      return;
    }
    handleSelectTenant(tenants.first);
  }
}
