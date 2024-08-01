import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/repositories/portal_authentication_repository.dart';
import 'package:supa_architecture/repositories/portal_profile_repository.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  static final authRepo = PortalAuthenticationRepository();

  static final profileRepo = PortalProfileRepository();

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

  Future<void> handleSwitchEmail(bool value) async {
    final user = (state as AuthenticationSuccess).appUser;
    final tenant = (state as AuthenticationSuccess).tenant;
    user.receivingSystemEmail.value = value;
    add(AuthenticationFinalEvent(
      appUser: user,
      tenant: tenant,
    ));
    try {
      final appUser = await profileRepo.switchEmail(user);
      add(AuthenticationFinalEvent(
        appUser: appUser,
        tenant: tenant,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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

  Future<void> handleChangeTenant(Tenant tenant) async {
    await authRepo.createToken(tenant);
    await authRepo.changeSavedTenant(tenant);
    add(AuthenticationFinalEvent(
      appUser: (state as AuthenticationSuccess).appUser,
      tenant: tenant,
    ));
  }

  handleInitialize() {
    add(AuthenticationInitialEvent());
  }

  handleLogin(
    String username,
    String password,
  ) {
    add(AuthenticationWithPasswordEvent(
      username: username,
      password: password,
    ));
  }

  handleLoginWithApple() {
    add(AuthenticationWithAppleEvent());
  }

  handleLoginWithBiometric() {
    add(AuthenticationWithBiometricEvent());
  }

  handleLoginWithGoogle() {
    add(AuthenticationWithGoogleEvent());
  }

  handleLoginWithMicrosoft() {
    add(AuthenticationWithMicrosoftEvent());
  }

  handleLogout() {
    add(AuthenticationLogoutEvent());
  }

  handleSelectTenant(Tenant tenant) {
    add(AuthenticationTenantSelectedEvent(tenant: tenant));
  }

  handleLoginWithTenants(List<Tenant> tenants) {
    add(AuthenticationTenantsLoadedEvent(tenants: tenants));
  }

  _onAppleLogin(
    AuthenticationWithAppleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final tenants = await PortalAuthenticationRepository()
          .loginWithApple(credential.identityToken!);
      handleLoginWithTenants(tenants);
    } catch (error) {
      add(AuthenticationErrorEvent(error));
    }
  }

  _onBiometricLogin(
    AuthenticationWithBiometricEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      final tenants = await authRepo.loginWithBiometric();
      handleLoginWithTenants(tenants);
    } catch (error) {
      add(AuthenticationErrorEvent(error));
    }
  }

  _onError(
    AuthenticationErrorEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationError(event.error));
  }

  _onFinal(
    AuthenticationFinalEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationSuccess(
      event.tenant,
      event.appUser,
    ));
  }

  _onGoogleLogin(
    AuthenticationWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());

      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[
          'email',
        ],
      );
      await googleSignIn.disconnect();
      final credentials = await googleSignIn.signIn();
      final googleKey = await credentials?.authentication;
      if (googleKey != null) {
        final tenants = await authRepo.loginWithGoogle(googleKey.idToken!);
        handleLoginWithTenants(tenants);
      } else {
        emit(AuthenticationInitial());
      }
    } catch (error) {
      add(AuthenticationErrorEvent(error));
    }
  }

  Future<void> _onInitial(
    AuthenticationInitialEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final authentication = authRepo.loadAuthentication();
    if (authentication != null) {
      add(AuthenticationFinalEvent(
        appUser: authentication.appUser,
        tenant: authentication.tenant,
      ));
    }
  }

  _onLogout(
    AuthenticationLogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationInitial());
      await authRepo.logout();
    } catch (error) {
      if (error is Exception) {
        add(AuthenticationErrorEvent(error));
      }
    }
  }

  _onMicrosoftLogin(
    AuthenticationWithMicrosoftEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      await SupaApplication.azureAuth.login();

      final String? accessToken =
          await SupaApplication.azureAuth.getAccessToken();
      if (accessToken != null) {
        final tenants = await authRepo.loginWithMicrosoft(accessToken);
        handleLoginWithTenants(tenants);
      }
    } catch (error) {
      add(AuthenticationErrorEvent(error as Exception));
    }
  }

  _onPassword(
    AuthenticationWithPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      final username = event.username;
      final password = event.password;
      final useCaptcha = SupaApplication.instance.useCaptcha;
      final captcha = useCaptcha
          ? await RecaptchaEnterprise.execute(RecaptchaAction.LOGIN())
          : '';
      await authRepo.login(username, password, captcha).then((tenants) {
        return handleLoginWithTenants(tenants);
      }).catchError((error) {
        add(AuthenticationErrorEvent(error));
      });
    } catch (error) {
      add(AuthenticationErrorEvent(error));
    }
  }

  _onTenantChanged(
    AuthenticationTenantChangedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final tenant = event.tenant;

    await authRepo.changeSavedTenant(tenant);

    add(AuthenticationFinalEvent(
      appUser: (state as AuthenticationSuccess).appUser,
      tenant: tenant,
    ));
  }

  _onTenantSelected(
    AuthenticationTenantSelectedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final tenant = event.tenant;
    await authRepo.createToken(tenant);
    final appUser = await authRepo.getProfile();
    authRepo.saveAuthentication(appUser, tenant);
    add(
      AuthenticationFinalEvent(
        appUser: appUser,
        tenant: tenant,
      ),
    );
  }

  _onTenantsLoaded(
    AuthenticationTenantsLoadedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final tenants = event.tenants;
    if (tenants.length > 1) {
      emit(AuthenticationTenants(tenants));
      return;
    }
    handleSelectTenant(tenants.first);
  }
}
