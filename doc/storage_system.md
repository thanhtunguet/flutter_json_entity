# Storage System

The Supa Architecture framework provides a comprehensive storage system with multiple storage solutions for different data persistence needs. The storage system is designed with platform abstraction to provide consistent APIs across web and native platforms.

## Purpose and Scope

The storage system serves several critical functions:

- **Data Persistence**: Long-term storage of application data
- **Security**: Encrypted storage for sensitive information
- **Platform Independence**: Consistent storage APIs across all platforms
- **Performance**: Optimized storage implementations for each platform
- **Flexibility**: Multiple storage types for different use cases

## Storage Architecture

The framework implements a layered storage architecture with clear abstractions:

```
Application Layer
       ↓
Storage Interfaces (Abstract)
       ↓
Platform-Specific Implementations
       ↓
Native Storage APIs
```

## Core Storage Components

### 1. Persistent Storage

**Purpose**: Long-term data storage that persists across app restarts

```dart
abstract class PersistentStorage {
  Future<void> initialize();
  Future<void> store(String key, dynamic value);
  Future<T?> retrieve<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<List<String>> getAllKeys();
  Future<bool> containsKey(String key);
}
```

**Platform Implementations:**
- **Native**: `HivePersistentStorage` using Hive database
- **Web**: `WebPersistentStorage` using browser localStorage with sessionStorage fallback

#### Usage Example

```dart
final storage = GetIt.instance<PersistentStorage>();

// Store data
await storage.store('user_preferences', {
  'theme': 'dark',
  'language': 'en',
  'notifications': true,
});

// Retrieve data
final preferences = await storage.retrieve<Map<String, dynamic>>('user_preferences');

// Check if key exists
final hasPreferences = await storage.containsKey('user_preferences');

// Remove specific key
await storage.remove('user_preferences');
```

### 2. Secure Storage

**Purpose**: Encrypted storage for sensitive information like tokens and credentials

```dart
abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
  Future<Map<String, String>> readAll();
  Future<bool> containsKey(String key);
}
```

**Platform Implementations:**
- **Native**: Platform keychain/keystore (iOS Keychain, Android Keystore)
- **Web**: Encrypted localStorage with AES encryption

#### Usage Example

```dart
final secureStorage = GetIt.instance<SecureStorage>();

// Store sensitive data
await secureStorage.write('auth_token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
await secureStorage.write('refresh_token', 'refresh_token_value');

// Retrieve sensitive data
final authToken = await secureStorage.read('auth_token');
final refreshToken = await secureStorage.read('refresh_token');

// Check if token exists
final hasToken = await secureStorage.containsKey('auth_token');

// Delete all secure data
await secureStorage.deleteAll();
```

### 3. Cookie Management

**Purpose**: HTTP cookie storage and management for API communication

```dart
abstract class CookieManager {
  Future<void> saveCookies(List<Cookie> cookies);
  Future<List<Cookie>> loadCookies(String domain);
  Future<void> clearCookies();
  Future<void> clearCookiesForDomain(String domain);
  Future<List<Cookie>> getCookiesForUrl(String url);
}
```

**Platform Implementations:**
- **Native**: `HiveCookieManager` using Hive-based persistence
- **Web**: `WebCookieManager` using browser cookie API

#### Usage Example

```dart
final cookieManager = GetIt.instance<CookieManager>();

// Save cookies from HTTP response
final cookies = [
  Cookie('session_id', 'abc123')..domain = 'api.example.com',
  Cookie('csrf_token', 'xyz789')..domain = 'api.example.com',
];
await cookieManager.saveCookies(cookies);

// Load cookies for domain
final domainCookies = await cookieManager.loadCookies('api.example.com');

// Get cookies for specific URL
final urlCookies = await cookieManager.getCookiesForUrl('https://api.example.com/users');

// Clear all cookies
await cookieManager.clearCookies();
```

## Platform-Specific Implementations

### Native Platform Storage

#### Hive Persistent Storage

```dart
class HivePersistentStorage implements PersistentStorage {
  late Box _box;
  
  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('persistent_storage');
  }
  
  @override
  Future<void> store(String key, dynamic value) async {
    await _box.put(key, value);
  }
  
  @override
  Future<T?> retrieve<T>(String key) async {
    return _box.get(key) as T?;
  }
  
  @override
  Future<void> remove(String key) async {
    await _box.delete(key);
  }
  
  @override
  Future<void> clear() async {
    await _box.clear();
  }
}
```

#### Native Secure Storage

Uses `flutter_secure_storage` package:

```dart
class NativeSecureStorage implements SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  @override
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  @override
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }
}
```

### Web Platform Storage

#### Web Persistent Storage

```dart
class WebPersistentStorage implements PersistentStorage {
  static const String _prefix = 'supa_storage_';
  
  @override
  Future<void> store(String key, dynamic value) async {
    final jsonValue = jsonEncode(value);
    try {
      window.localStorage['$_prefix$key'] = jsonValue;
    } catch (e) {
      // Fallback to sessionStorage if localStorage is full
      window.sessionStorage['$_prefix$key'] = jsonValue;
    }
  }
  
  @override
  Future<T?> retrieve<T>(String key) async {
    final value = window.localStorage['$_prefix$key'] ?? 
                  window.sessionStorage['$_prefix$key'];
    if (value != null) {
      return jsonDecode(value) as T?;
    }
    return null;
  }
}
```

#### Web Secure Storage

```dart
class WebSecureStorage implements SecureStorage {
  static const String _prefix = 'supa_secure_';
  final _encryption = AESEncryption();
  
  @override
  Future<void> write(String key, String value) async {
    final encryptedValue = await _encryption.encrypt(value);
    window.localStorage['$_prefix$key'] = encryptedValue;
  }
  
  @override
  Future<String?> read(String key) async {
    final encryptedValue = window.localStorage['$_prefix$key'];
    if (encryptedValue != null) {
      return await _encryption.decrypt(encryptedValue);
    }
    return null;
  }
}
```

## Storage Configuration

### Initialization

Storage systems are initialized during application startup:

```dart
Future<void> initializeStorage() async {
  if (kIsWeb) {
    // Web platform
    final persistentStorage = WebPersistentStorage();
    final cookieManager = WebCookieManager();
    final secureStorage = WebSecureStorage();
    
    await persistentStorage.initialize();
    
    GetIt.instance.registerSingleton<PersistentStorage>(persistentStorage);
    GetIt.instance.registerSingleton<CookieManager>(cookieManager);
    GetIt.instance.registerSingleton<SecureStorage>(secureStorage);
  } else {
    // Native platforms
    final persistentStorage = HivePersistentStorage();
    final cookieManager = HiveCookieManager();
    final secureStorage = NativeSecureStorage();
    
    await persistentStorage.initialize();
    await cookieManager.initialize();
    
    GetIt.instance.registerSingleton<PersistentStorage>(persistentStorage);
    GetIt.instance.registerSingleton<CookieManager>(cookieManager);
    GetIt.instance.registerSingleton<SecureStorage>(secureStorage);
  }
}
```

### Environment-Specific Configuration

```dart
class StorageConfig {
  static const String persistentStorageBox = 'app_storage';
  static const String cookieStorageBox = 'cookie_storage';
  
  // Web-specific configuration
  static const String webStoragePrefix = 'supa_app_';
  static const int webStorageQuotaLimit = 10 * 1024 * 1024; // 10MB
  
  // Native-specific configuration
  static const String hiveStoragePath = 'storage';
  static const bool enableEncryption = true;
}
```

## Storage Dependencies

The storage system relies on the following packages:

| Package | Version | Purpose |
|---------|---------|---------|
| `hive` | ^2.2.3 | Lightweight, fast NoSQL database for native platforms |
| `hive_flutter` | ^1.1.0 | Flutter integration for Hive database |
| `flutter_secure_storage` | ^9.0.0 | Encrypted storage for sensitive information |
| `path_provider` | ^2.1.1 | Access to commonly used file system locations |

## Data Types and Serialization

### Supported Data Types

The storage system supports various data types through automatic serialization:

```dart
// Primitive types
await storage.store('string_value', 'Hello World');
await storage.store('int_value', 42);
await storage.store('double_value', 3.14);
await storage.store('bool_value', true);

// Collections
await storage.store('list_value', [1, 2, 3, 4, 5]);
await storage.store('map_value', {'key': 'value', 'count': 10});

// Custom objects (must be JSON serializable)
await storage.store('user_model', userModel.toJson());
```

### JSON Model Integration

Storage integrates seamlessly with the framework's JSON model system:

```dart
class UserPreferences extends JsonModel {
  static const JsonField<String> themeField = JsonField('theme');
  static const JsonField<String> languageField = JsonField('language');
  static const JsonField<bool> notificationsField = JsonField('notifications');
  
  String get theme => getValue(themeField);
  String get language => getValue(languageField);
  bool get notifications => getValue(notificationsField);
  
  // Storage methods
  Future<void> save() async {
    final storage = GetIt.instance<PersistentStorage>();
    await storage.store('user_preferences', toJson());
  }
  
  static Future<UserPreferences?> load() async {
    final storage = GetIt.instance<PersistentStorage>();
    final data = await storage.retrieve<Map<String, dynamic>>('user_preferences');
    if (data != null) {
      return UserPreferences()..fromJson(data);
    }
    return null;
  }
}
```

## Performance Considerations

### 1. Lazy Loading

```dart
class CachedDataManager {
  final PersistentStorage _storage;
  final Map<String, dynamic> _cache = {};
  
  Future<T?> get<T>(String key) async {
    // Check memory cache first
    if (_cache.containsKey(key)) {
      return _cache[key] as T?;
    }
    
    // Load from storage and cache
    final value = await _storage.retrieve<T>(key);
    if (value != null) {
      _cache[key] = value;
    }
    return value;
  }
}
```

### 2. Batch Operations

```dart
class BatchStorageOperations {
  final PersistentStorage _storage;
  final List<StorageOperation> _operations = [];
  
  void addStore(String key, dynamic value) {
    _operations.add(StoreOperation(key, value));
  }
  
  void addRemove(String key) {
    _operations.add(RemoveOperation(key));
  }
  
  Future<void> commit() async {
    for (final operation in _operations) {
      await operation.execute(_storage);
    }
    _operations.clear();
  }
}
```

## Error Handling

### Storage Exceptions

```dart
abstract class StorageException implements Exception {
  final String message;
  const StorageException(this.message);
}

class StorageNotInitializedException extends StorageException {
  const StorageNotInitializedException() 
    : super('Storage not initialized. Call initialize() first.');
}

class StorageQuotaExceededException extends StorageException {
  const StorageQuotaExceededException() 
    : super('Storage quota exceeded.');
}

class EncryptionException extends StorageException {
  const EncryptionException(String message) : super(message);
}
```

### Error Recovery

```dart
class RobustStorageWrapper implements PersistentStorage {
  final PersistentStorage _storage;
  final int maxRetries;
  
  @override
  Future<void> store(String key, dynamic value) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        await _storage.store(key, value);
        return;
      } on StorageException catch (e) {
        attempts++;
        if (attempts >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 100 * attempts));
      }
    }
  }
}
```

## Best Practices

### 1. Key Naming Conventions

```dart
class StorageKeys {
  // User-related data
  static const String userProfile = 'user.profile';
  static const String userPreferences = 'user.preferences';
  static const String userSettings = 'user.settings';
  
  // Authentication data
  static const String authToken = 'auth.token';
  static const String refreshToken = 'auth.refresh_token';
  static const String tenantId = 'auth.tenant_id';
  
  // Application state
  static const String appVersion = 'app.version';
  static const String lastSync = 'app.last_sync';
  static const String cacheTimestamp = 'cache.timestamp';
}
```

### 2. Data Lifecycle Management

```dart
class DataLifecycleManager {
  final PersistentStorage _storage;
  
  Future<void> cleanupExpiredData() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final keys = await _storage.getAllKeys();
    
    for (final key in keys) {
      if (key.startsWith('cache.')) {
        final data = await _storage.retrieve<Map<String, dynamic>>(key);
        final expiry = data?['expiry'] as int?;
        if (expiry != null && expiry < timestamp) {
          await _storage.remove(key);
        }
      }
    }
  }
}
```

### 3. Secure Data Handling

```dart
class SecureDataManager {
  final SecureStorage _secureStorage;
  final PersistentStorage _storage;
  
  Future<void> storeUserData(UserModel user) async {
    // Store sensitive data in secure storage
    await _secureStorage.write('user_id', user.id);
    await _secureStorage.write('email', user.email);
    
    // Store non-sensitive data in regular storage
    await _storage.store('user_profile', {
      'name': user.name,
      'avatar_url': user.avatarUrl,
      'preferences': user.preferences.toJson(),
    });
  }
}
```

---

*Documentation generated from [DeepWiki](https://deepwiki.com/supavn/supa_architecture)*