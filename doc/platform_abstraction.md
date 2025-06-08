# Platform Abstraction

The platform abstraction layer provides a unified interface for accessing platform-specific functionality across different platforms (web, Android, iOS, desktop). It enables consistent access to storage systems and device features while maintaining separation between business logic and platform-specific implementations.

## Purpose and Scope

The platform abstraction layer serves several critical functions:

- **Unified Interface**: Provides consistent APIs across all supported platforms
- **Platform Independence**: Allows business logic to remain platform-agnostic
- **Feature Abstraction**: Abstracts platform-specific features behind common interfaces
- **Extensibility**: Enables easy addition of new platforms or features

## Architecture Overview

The platform abstraction follows the **Plugin Platform Interface pattern**, which is the standard approach for Flutter plugins that need to support multiple platforms.

### Key Components

1. **Platform Interface**: Abstract base class defining common functionality
2. **Platform Implementations**: Concrete implementations for each platform
3. **Platform Detection**: Automatic selection of appropriate implementation
4. **Feature Flags**: Configuration for optional platform features

## Core Class Structure

### `SupaArchitecturePlatform` (Abstract Interface)

The base abstract class that defines the contract for all platform implementations:

```dart
abstract class SupaArchitecturePlatform extends PlatformInterface {
  // Core initialization
  Future<void> initialize({
    required bool enableFirebase,
    required bool enableSentry,
  });
  
  // Storage abstractions
  PersistentStorage get persistentStorage;
  CookieManager get cookieManager;
  SecureStorage get secureStorage;
  
  // Device information
  DeviceInfo get deviceInfo;
  
  // Platform capabilities
  bool get supportsFirebase;
  bool get supportsSentry;
  bool get supportsBiometrics;
  
  // Base URL management
  String? get baseUrl;
  Future<void> setBaseUrl(String url);
}
```

### `MethodChannelSupaArchitecture` (Native Platforms)

Implementation for native platforms (Android, iOS, macOS, Windows, Linux):

```dart
class MethodChannelSupaArchitecture extends SupaArchitecturePlatform {
  final MethodChannel _methodChannel;
  
  @override
  Future<void> initialize({
    required bool enableFirebase,
    required bool enableSentry,
  }) async {
    // Initialize Hive for native platforms
    await Hive.initFlutter();
    
    // Set up native storage implementations
    _persistentStorage = HivePersistentStorage();
    _cookieManager = HiveCookieManager();
    _secureStorage = FlutterSecureStorage();
    
    // Configure platform features
    await _configureFirebase(enableFirebase);
    await _configureSentry(enableSentry);
  }
  
  @override
  PersistentStorage get persistentStorage => _persistentStorage;
  
  @override
  CookieManager get cookieManager => _cookieManager;
  
  @override
  bool get supportsBiometrics => true; // Available on mobile platforms
}
```

### `SupaArchitectureWeb` (Web Platform)

Implementation specifically for web platforms:

```dart
class SupaArchitectureWeb extends SupaArchitecturePlatform {
  @override
  Future<void> initialize({
    required bool enableFirebase,
    required bool enableSentry,
  }) async {
    // Initialize web-specific storage
    _persistentStorage = WebPersistentStorage();
    _cookieManager = WebCookieManager();
    _secureStorage = WebSecureStorage();
    
    // Configure web-specific features
    await _configureWebFirebase(enableFirebase);
    await _configureWebSentry(enableSentry);
  }
  
  @override
  PersistentStorage get persistentStorage => _persistentStorage;
  
  @override
  CookieManager get cookieManager => _cookieManager;
  
  @override
  bool get supportsBiometrics => false; // Not available on web
}
```

## Core Abstractions

### 1. Storage Abstraction

The platform layer provides three types of storage abstraction:

#### Persistent Storage
- **Purpose**: Long-term data storage that persists across app restarts
- **Native Implementation**: Hive database
- **Web Implementation**: Browser localStorage with fallback to sessionStorage

```dart
abstract class PersistentStorage {
  Future<void> initialize();
  Future<void> store(String key, dynamic value);
  Future<T?> retrieve<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
```

#### Cookie Management
- **Purpose**: HTTP cookie storage and management
- **Native Implementation**: Hive-based cookie persistence
- **Web Implementation**: Browser cookie API

```dart
abstract class CookieManager {
  Future<void> saveCookies(List<Cookie> cookies);
  Future<List<Cookie>> loadCookies(String domain);
  Future<void> clearCookies();
}
```

#### Secure Storage
- **Purpose**: Encrypted storage for sensitive information
- **Native Implementation**: Platform keychain/keystore
- **Web Implementation**: Encrypted localStorage with fallback

```dart
abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
```

### 2. Device Information

Platform-specific device information abstraction:

```dart
class DeviceInfo {
  final String platform;
  final String version;
  final String deviceId;
  final String appVersion;
  final bool isPhysicalDevice;
  
  // Platform-specific fields
  final String? androidId;        // Android only
  final String? iosDeviceId;      // iOS only
  final String? webUserAgent;     // Web only
}
```

### 3. Feature Detection

The platform abstraction provides feature detection capabilities:

```dart
// Check platform capabilities before using features
if (SupaArchitecture.platform.supportsBiometrics) {
  await authenticateWithBiometrics();
}

if (SupaArchitecture.platform.supportsFirebase) {
  await initializeFirebaseFeatures();
}
```

## Platform-Specific Implementations

### Mobile Platforms (Android/iOS)

**Features:**
- Full biometric authentication support
- Native secure storage (Keychain/Keystore)
- Background processing capabilities
- Push notification support
- File system access

**Storage Implementations:**
- **Hive**: For persistent data storage
- **Flutter Secure Storage**: For sensitive data
- **Native cookies**: Through platform channels

### Web Platform

**Features:**
- Browser-based storage APIs
- Limited secure storage (encrypted localStorage)
- Web-specific authentication flows
- Progressive Web App capabilities

**Storage Implementations:**
- **localStorage/sessionStorage**: For persistent data
- **Encrypted storage**: For sensitive data with AES encryption
- **Browser cookies**: Native cookie support

**Limitations:**
- No biometric authentication
- Limited background processing
- Restricted file system access
- Security limitations of web environment

### Desktop Platforms (macOS/Windows/Linux)

**Features:**
- Desktop-appropriate file handling
- Platform-specific secure storage
- Native authentication integration
- Desktop notification support

**Storage Implementations:**
- **Hive**: Cross-platform data storage
- **Platform keychain**: Native secure storage
- **File-based cookies**: Persistent cookie storage

## Initialization Patterns

### Automatic Platform Detection

The framework automatically detects the current platform and selects the appropriate implementation:

```dart
// Automatic platform selection
SupaArchitecturePlatform platform;

if (kIsWeb) {
  platform = SupaArchitectureWeb();
} else {
  platform = MethodChannelSupaArchitecture();
}

// Set as default instance
SupaArchitecturePlatform.instance = platform;
```

### Configuration-Based Initialization

Different platforms may require different initialization parameters:

```dart
await SupaArchitecture.initialize(
  enableFirebase: kIsWeb ? false : true,  // Disable on web if needed
  enableSentry: true,
  customBaseUrl: Environment.apiBaseUrl,
);
```

## Design Principles

### 1. Interface Segregation
- Each abstraction focuses on a specific concern
- Minimal interface definitions to reduce coupling
- Optional features clearly marked

### 2. Platform Transparency
- Business logic remains unaware of platform differences
- Consistent behavior across platforms where possible
- Graceful degradation for missing features

### 3. Extensibility
- Easy to add new platform implementations
- Plugin architecture for optional features
- Configuration-driven behavior

### 4. Performance Optimization
- Platform-specific optimizations where beneficial
- Lazy initialization of expensive resources
- Efficient storage implementations for each platform

## Error Handling

### Platform-Specific Errors
```dart
try {
  await platform.secureStorage.write('key', 'value');
} on PlatformException catch (e) {
  // Handle platform-specific errors
  if (e.code == 'UserCancel') {
    // User cancelled biometric authentication
  }
} on UnsupportedError catch (e) {
  // Feature not supported on this platform
}
```

### Graceful Degradation
```dart
// Provide fallbacks for unsupported features
if (platform.supportsBiometrics) {
  await authenticateWithBiometrics();
} else {
  await authenticateWithPassword();
}
```

## Best Practices

1. **Feature Detection**: Always check platform capabilities before using features
2. **Error Handling**: Implement proper error handling for platform-specific failures
3. **Testing**: Test on all target platforms to ensure consistent behavior
4. **Performance**: Use platform-appropriate storage and processing strategies
5. **Security**: Understand security limitations of each platform

---

*Documentation generated from [DeepWiki](https://deepwiki.com/supavn/supa_architecture)*