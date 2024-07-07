import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/repositories/portal_authentication_repository.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  static final authRepo = PortalAuthenticationRepository();

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
    add(AuthenticationTenantSelectedEvent(tenant: tenants.first));
  }

  _onError(
    AuthenticationErrorEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationError(event.error));
  }

  initialize() {
    add(AuthenticationInitialEvent());
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

  _handleLoginWithTenants(List<Tenant> tenants) {
    add(AuthenticationTenantsLoadedEvent(tenants: tenants));
  }

  login(
    String username,
    String password,
  ) {
    add(AuthenticationWithPasswordEvent(
      username: username,
      password: password,
    ));
  }

  _onPassword(
    AuthenticationWithPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final username = event.username;
    final password = event.password;
    await authRepo.login(username, password).then((tenants) {
      return _handleLoginWithTenants(tenants);
    });
  }

  loginWithGoogle() {
    add(AuthenticationWithGoogleEvent());
  }

  _onGoogleLogin(
    AuthenticationWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
      ],
    );
    final credentials = await googleSignIn.signIn();
    final googleKey = await credentials?.authentication;
    final tenants = await authRepo.loginWithGoogle(googleKey!.idToken!);
    _handleLoginWithTenants(tenants);
  }

  loginWithApple() {
    add(AuthenticationWithAppleEvent());
  }

  _onAppleLogin(
    AuthenticationWithAppleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final tenants = await PortalAuthenticationRepository()
        .loginWithApple(credential.identityToken!);
    _handleLoginWithTenants(tenants);
  }

  loginWithMicrosoft() {
    add(AuthenticationWithMicrosoftEvent());
  }

  _onMicrosoftLogin(
    AuthenticationWithMicrosoftEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  loginWithBiometric() {
    add(AuthenticationWithBiometricEvent());
  }

  _onBiometricLogin(
    AuthenticationWithBiometricEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  logout() {
    add(AuthenticationLogoutEvent());
  }

  _onLogout(
    AuthenticationLogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInitial());
  }
}
