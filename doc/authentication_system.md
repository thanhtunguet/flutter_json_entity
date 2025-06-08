# Authentication System

The authentication system is a core component of Supa Architecture, providing a comprehensive solution for handling user authentication across multiple providers and tenants. It supports various authentication methods, token management, and multi-tenant capabilities.

## Purpose and Scope

The authentication system serves several critical functions:

- **Multi-Provider Authentication**: Support for various authentication providers
- **Multi-Tenant Support**: Handle multiple organizations or tenants
- **Token Management**: Automatic token lifecycle management
- **Persistent Sessions**: Remember user authentication state
- **Security**: Secure storage and handling of authentication data
- **Biometric Support**: Integration with device biometric authentication

## Authentication Architecture

The authentication system follows a structured approach with clear separation of concerns:

```
UI Layer (Login Screens)
       ↓
AuthenticationBloc (State Management)
       ↓
PortalAuthenticationRepository (Business Logic)
       ↓
Authentication Providers (External Services)
       ↓
Secure Storage (Token Persistence)
```

### Core Components

1. **AuthenticationBloc**: Manages authentication state and processes events
2. **Authentication Repository**: Handles authentication business logic
3. **Authentication Providers**: Interface with external authentication services
4. **Secure Storage**: Manages token storage and retrieval
5. **Tenant Management**: Handles multi-tenant functionality

## Authentication States

The authentication system uses a comprehensive state model:

```dart
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticating extends AuthenticationState {
  final String? message;
  
  const Authenticating({this.message});
  
  @override
  List<Object?> get props => [message];
}

class Authenticated extends AuthenticationState {
  final AppUser user;
  final String token;
  final CurrentTenant? tenant;
  
  const Authenticated({
    required this.user,
    required this.token,
    this.tenant,
  });
  
  @override
  List<Object?> get props => [user, token, tenant];
}

class TenantSelection extends AuthenticationState {
  final AppUser user;
  final List<Tenant> availableTenants;
  
  const TenantSelection({
    required this.user,
    required this.availableTenants,
  });
  
  @override
  List<Object> get props => [user, availableTenants];
}

class AuthenticationError extends AuthenticationState {
  final String message;
  final String? errorCode;
  
  const AuthenticationError({
    required this.message,
    this.errorCode,
  });
  
  @override
  List<Object?> get props => [message, errorCode];
}
```

## Authentication Events

The system processes various authentication events:

```dart
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;
  
  const LoginRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}

class SocialLoginRequested extends AuthenticationEvent {
  final AuthProvider provider;
  
  const SocialLoginRequested({required this.provider});
  
  @override
  List<Object> get props => [provider];
}

class BiometricLoginRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class TenantSelected extends AuthenticationEvent {
  final String tenantId;
  
  const TenantSelected({required this.tenantId});
  
  @override
  List<Object> get props => [tenantId];
}

class LogoutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class TokenRefreshRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationStatusChecked extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
```

## Authentication Providers

The framework supports multiple authentication providers:

### 1. Google Sign-In

```dart
class GoogleAuthProvider implements AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  @override
  Future<AuthResult> authenticate() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return AuthResult.cancelled();
      }
      
      final GoogleSignInAuthentication auth = await account.authentication;
      
      return AuthResult.success(
        token: auth.accessToken!,
        refreshToken: auth.idToken,
        userInfo: {
          'email': account.email,
          'name': account.displayName,
          'avatar': account.photoUrl,
        },
      );
    } catch (error) {
      return AuthResult.error('Google Sign-In failed: ${error.toString()}');
    }
  }
  
  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
```

### 2. Apple Sign-In

```dart
class AppleAuthProvider implements AuthProvider {
  @override
  Future<AuthResult> authenticate() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      return AuthResult.success(
        token: credential.identityToken!,
        refreshToken: credential.authorizationCode,
        userInfo: {
          'email': credential.email,
          'name': _buildFullName(credential.givenName, credential.familyName),
          'userId': credential.userIdentifier,
        },
      );
    } catch (error) {
      return AuthResult.error('Apple Sign-In failed: ${error.toString()}');
    }
  }
  
  String? _buildFullName(String? givenName, String? familyName) {
    if (givenName == null && familyName == null) return null;
    return '${givenName ?? ''} ${familyName ?? ''}'.trim();
  }
}
```

### 3. Microsoft Azure AD

```dart
class MicrosoftAuthProvider implements AuthProvider {
  final AadOAuth _aadOAuth = AadOAuth(Config(
    tenant: Environment.azureTenant,
    clientId: Environment.azureClientId,
    scope: 'openid profile email',
    redirectUri: Environment.azureRedirectUri,
  ));
  
  @override
  Future<AuthResult> authenticate() async {
    try {
      final result = await _aadOAuth.login();
      
      if (result.isSuccess) {
        return AuthResult.success(
          token: result.accessToken!,
          refreshToken: result.refreshToken,
          userInfo: {
            'email': result.userInfo?.email,
            'name': result.userInfo?.displayName,
            'userId': result.userInfo?.id,
          },
        );
      } else {
        return AuthResult.error('Microsoft login failed');
      }
    } catch (error) {
      return AuthResult.error('Microsoft Auth failed: ${error.toString()}');
    }
  }
}
```

### 4. Email/Password Authentication

```dart
class EmailPasswordAuthProvider implements AuthProvider {
  final ApiClient _apiClient;
  
  EmailPasswordAuthProvider({required ApiClient apiClient}) 
    : _apiClient = apiClient;
  
  Future<AuthResult> authenticate({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.isSuccess) {
        return AuthResult.success(
          token: response.data['access_token'],
          refreshToken: response.data['refresh_token'],
          userInfo: response.data['user'],
        );
      } else {
        return AuthResult.error(response.error?.message ?? 'Login failed');
      }
    } catch (error) {
      return AuthResult.error('Authentication failed: ${error.toString()}');
    }
  }
  
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiClient.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name,
      });
      
      if (response.isSuccess) {
        return AuthResult.success(
          token: response.data['access_token'],
          refreshToken: response.data['refresh_token'],
          userInfo: response.data['user'],
        );
      } else {
        return AuthResult.error(response.error?.message ?? 'Registration failed');
      }
    } catch (error) {
      return AuthResult.error('Registration failed: ${error.toString()}');
    }
  }
}
```

### 5. Biometric Authentication

```dart
class BiometricAuthProvider {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final SecureStorage _secureStorage;
  
  BiometricAuthProvider({required SecureStorage secureStorage})
    : _secureStorage = secureStorage;
  
  Future<bool> isBiometricAvailable() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }
  
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _localAuth.getAvailableBiometrics();
  }
  
  Future<AuthResult> authenticateWithBiometrics() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      
      if (isAuthenticated) {
        // Retrieve stored credentials
        final token = await _secureStorage.read('biometric_token');
        if (token != null) {
          return AuthResult.success(token: token);
        } else {
          return AuthResult.error('No stored credentials found');
        }
      } else {
        return AuthResult.cancelled();
      }
    } catch (error) {
      return AuthResult.error('Biometric authentication failed: ${error.toString()}');
    }
  }
  
  Future<void> storeBiometricCredentials(String token) async {
    await _secureStorage.write('biometric_token', token);
  }
  
  Future<void> clearBiometricCredentials() async {
    await _secureStorage.delete('biometric_token');
  }
}
```

## AuthenticationBloc Implementation

```dart
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final PortalAuthenticationRepository _authRepository;
  final SecureStorage _secureStorage;
  final BiometricAuthProvider _biometricAuth;
  
  AuthenticationBloc({
    required PortalAuthenticationRepository authRepository,
    required SecureStorage secureStorage,
    required BiometricAuthProvider biometricAuth,
  }) : _authRepository = authRepository,
       _secureStorage = secureStorage,
       _biometricAuth = biometricAuth,
       super(AuthenticationInitial()) {
    on<AuthenticationStatusChecked>(_onStatusChecked);
    on<LoginRequested>(_onLoginRequested);
    on<SocialLoginRequested>(_onSocialLoginRequested);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<TenantSelected>(_onTenantSelected);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }
  
  Future<void> _onStatusChecked(
    AuthenticationStatusChecked event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final token = await _secureStorage.read('auth_token');
      if (token != null) {
        final user = await _authRepository.getCurrentUser(token);
        if (user != null) {
          emit(Authenticated(user: user, token: token));
          return;
        }
      }
      emit(Unauthenticated());
    } catch (error) {
      emit(Unauthenticated());
    }
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(Authenticating(message: 'Signing in...'));
    
    try {
      final result = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      
      if (result.isSuccess) {
        await _secureStorage.write('auth_token', result.token!);
        await _secureStorage.write('refresh_token', result.refreshToken!);
        
        if (result.requiresTenantSelection) {
          emit(TenantSelection(
            user: result.user!,
            availableTenants: result.availableTenants!,
          ));
        } else {
          emit(Authenticated(
            user: result.user!,
            token: result.token!,
            tenant: result.tenant,
          ));
        }
      } else {
        emit(AuthenticationError(
          message: result.errorMessage!,
          errorCode: result.errorCode,
        ));
      }
    } catch (error) {
      emit(AuthenticationError(
        message: 'Login failed: ${error.toString()}',
      ));
    }
  }
  
  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (!await _biometricAuth.isBiometricAvailable()) {
      emit(AuthenticationError(
        message: 'Biometric authentication not available',
        errorCode: 'BIOMETRIC_NOT_AVAILABLE',
      ));
      return;
    }
    
    emit(Authenticating(message: 'Authenticating with biometrics...'));
    
    try {
      final result = await _biometricAuth.authenticateWithBiometrics();
      
      if (result.isSuccess) {
        final user = await _authRepository.getCurrentUser(result.token!);
        if (user != null) {
          emit(Authenticated(user: user, token: result.token!));
        } else {
          emit(AuthenticationError(message: 'Failed to get user information'));
        }
      } else if (result.isCancelled) {
        emit(Unauthenticated());
      } else {
        emit(AuthenticationError(
          message: result.errorMessage!,
          errorCode: 'BIOMETRIC_FAILED',
        ));
      }
    } catch (error) {
      emit(AuthenticationError(
        message: 'Biometric authentication failed: ${error.toString()}',
      ));
    }
  }
}
```

## Multi-Tenant Support

### Tenant Management

```dart
class TenantManager {
  final SecureStorage _secureStorage;
  final ApiClient _apiClient;
  
  TenantManager({
    required SecureStorage secureStorage,
    required ApiClient apiClient,
  }) : _secureStorage = secureStorage,
       _apiClient = apiClient;
  
  Future<List<Tenant>> getAvailableTenants(String userId) async {
    final response = await _apiClient.get('/users/$userId/tenants');
    if (response.isSuccess) {
      return (response.data as List)
          .map((json) => Tenant.fromJson(json))
          .toList();
    }
    throw Exception('Failed to fetch tenants');
  }
  
  Future<void> selectTenant(String tenantId) async {
    await _secureStorage.write('selected_tenant_id', tenantId);
    
    // Update API client headers
    _apiClient.setTenantHeader(tenantId);
  }
  
  Future<String?> getCurrentTenantId() async {
    return await _secureStorage.read('selected_tenant_id');
  }
  
  Future<void> clearTenantSelection() async {
    await _secureStorage.delete('selected_tenant_id');
  }
}
```

### Tenant-Aware API Client

```dart
class TenantAwareApiClient extends ApiClient {
  String? _currentTenantId;
  
  void setTenantHeader(String tenantId) {
    _currentTenantId = tenantId;
    _dio.options.headers['X-Tenant-ID'] = tenantId;
  }
  
  @override
  Future<HttpResponse<T>> request<T>({
    required String method,
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    // Ensure tenant header is set for all requests
    if (_currentTenantId != null) {
      _dio.options.headers['X-Tenant-ID'] = _currentTenantId;
    }
    
    return super.request<T>(
      method: method,
      path: path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
```

## Token Management

### Token Refresh

```dart
class TokenManager {
  final SecureStorage _secureStorage;
  final ApiClient _apiClient;
  Timer? _refreshTimer;
  
  TokenManager({
    required SecureStorage secureStorage,
    required ApiClient apiClient,
  }) : _secureStorage = secureStorage,
       _apiClient = apiClient;
  
  Future<void> startTokenRefresh() async {
    final token = await _secureStorage.read('auth_token');
    if (token != null) {
      final expiryTime = _getTokenExpiry(token);
      final refreshTime = expiryTime.subtract(Duration(minutes: 5));
      final now = DateTime.now();
      
      if (refreshTime.isAfter(now)) {
        final duration = refreshTime.difference(now);
        _refreshTimer = Timer(duration, _refreshToken);
      } else {
        // Token expires soon, refresh immediately
        await _refreshToken();
      }
    }
  }
  
  Future<void> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read('refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }
      
      final response = await _apiClient.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      
      if (response.isSuccess) {
        final newToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        
        await _secureStorage.write('auth_token', newToken);
        await _secureStorage.write('refresh_token', newRefreshToken);
        
        // Update API client with new token
        _apiClient.setAuthToken(newToken);
        
        // Schedule next refresh
        await startTokenRefresh();
      } else {
        // Refresh failed, logout user
        await logout();
      }
    } catch (error) {
      // Handle refresh error
      await logout();
    }
  }
  
  DateTime _getTokenExpiry(String token) {
    // Decode JWT token to get expiry time
    final parts = token.split('.');
    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    final exp = payload['exp'] as int;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }
  
  Future<void> logout() async {
    _refreshTimer?.cancel();
    await _secureStorage.deleteAll();
    // Notify authentication bloc
  }
}
```

## Authentication Forms

### Login Form

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formGroup = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(6)],
    ),
  });
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      builder: (context, state) {
        final isLoading = state is Authenticating;
        
        return ReactiveForm(
          formGroup: _formGroup,
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'password',
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _onLoginPressed,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text('Sign In'),
              ),
              SizedBox(height: 16),
              _buildSocialLoginButtons(),
              if (await _biometricAuth.isBiometricAvailable()) ...[
                SizedBox(height: 16),
                _buildBiometricLoginButton(),
              ],
            ],
          ),
        );
      },
    );
  }
  
  void _onLoginPressed() {
    if (_formGroup.valid) {
      final email = _formGroup.control('email').value as String;
      final password = _formGroup.control('password').value as String;
      
      context.read<AuthenticationBloc>().add(
        LoginRequested(email: email, password: password),
      );
    }
  }
  
  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SocialSignInButton(
          provider: AuthProvider.google,
          onPressed: () {
            context.read<AuthenticationBloc>().add(
              SocialLoginRequested(provider: AuthProvider.google),
            );
          },
        ),
        SizedBox(height: 8),
        SocialSignInButton(
          provider: AuthProvider.apple,
          onPressed: () {
            context.read<AuthenticationBloc>().add(
              SocialLoginRequested(provider: AuthProvider.apple),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildBiometricLoginButton() {
    return BiometricLoginButton(
      onPressed: () {
        context.read<AuthenticationBloc>().add(BiometricLoginRequested());
      },
    );
  }
}
```

## Security Best Practices

### 1. Token Storage

```dart
class SecureTokenStorage {
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  
  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final secureStorage = GetIt.instance<SecureStorage>();
    
    await Future.wait([
      secureStorage.write(tokenKey, accessToken),
      secureStorage.write(refreshTokenKey, refreshToken),
    ]);
  }
  
  static Future<AuthTokens?> getTokens() async {
    final secureStorage = GetIt.instance<SecureStorage>();
    
    final results = await Future.wait([
      secureStorage.read(tokenKey),
      secureStorage.read(refreshTokenKey),
    ]);
    
    final accessToken = results[0];
    final refreshToken = results[1];
    
    if (accessToken != null && refreshToken != null) {
      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
    
    return null;
  }
}
```

### 2. Authentication State Persistence

```dart
class AuthenticationStatePersistence {
  static const String lastAuthStateKey = 'last_auth_state';
  
  static Future<void> saveAuthenticationState(AuthenticationState state) async {
    final storage = GetIt.instance<PersistentStorage>();
    
    if (state is Authenticated) {
      await storage.store(lastAuthStateKey, {
        'type': 'authenticated',
        'user_id': state.user.id,
        'tenant_id': state.tenant?.id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } else if (state is Unauthenticated) {
      await storage.remove(lastAuthStateKey);
    }
  }
  
  static Future<Map<String, dynamic>?> getLastAuthenticationState() async {
    final storage = GetIt.instance<PersistentStorage>();
    return await storage.retrieve<Map<String, dynamic>>(lastAuthStateKey);
  }
}
```

---

*Documentation generated from [DeepWiki](https://deepwiki.com/supavn/supa_architecture)*