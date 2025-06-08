# Dependencies

The Supa Architecture framework relies on several key dependency categories to provide comprehensive functionality across authentication, state management, storage, networking, and monitoring.

## Dependency Categories

### 1. State Management

| Package | Version | Purpose |
|---------|---------|---------|
| `bloc` | ^8.1.2 | Core BLoC library for reactive state management |
| `flutter_bloc` | ^8.1.3 | Flutter integration for BLoC pattern |
| `equatable` | ^2.0.5 | Value equality for objects, essential for BLoC states |
| `get_it` | ^7.6.4 | Service locator for dependency injection |
| `injectable` | ^2.3.2 | Code generation for dependency injection |

### 2. Authentication

| Package | Version | Purpose |
|---------|---------|---------|
| `aad_oauth` | ^0.4.0 | Microsoft Azure Active Directory authentication |
| `google_sign_in` | ^6.1.5 | Google authentication integration |
| `sign_in_with_apple` | ^5.0.0 | Apple Sign-In implementation |
| `local_auth` | ^2.1.6 | Biometric authentication (fingerprint, Face ID) |
| `flutter_secure_storage` | ^9.0.0 | Secure storage for tokens and sensitive data |

### 3. Data Storage

| Package | Version | Purpose |
|---------|---------|---------|
| `hive` | ^2.2.3 | Lightweight, fast NoSQL database |
| `hive_flutter` | ^1.1.0 | Flutter integration for Hive database |
| `flutter_secure_storage` | ^9.0.0 | Encrypted storage for sensitive information |
| `path_provider` | ^2.1.1 | Access to commonly used file system locations |

### 4. Networking

| Package | Version | Purpose |
|---------|---------|---------|
| `dio` | ^5.3.2 | HTTP client with interceptors and advanced features |
| `dio_cookie_manager` | ^3.1.1 | Cookie management for Dio HTTP client |
| `cookie_jar` | ^4.0.8 | Cookie persistence and management |

### 5. Routing & Navigation

| Package | Version | Purpose |
|---------|---------|---------|
| `go_router` | ^12.1.1 | Declarative routing with deep linking support |

### 6. UI & Forms

| Package | Version | Purpose |
|---------|---------|---------|
| `reactive_forms` | ^16.1.1 | Reactive form handling with validation |
| `infinite_scroll_pagination` | ^4.0.0 | Infinite scrolling and pagination |
| `file_picker` | ^6.1.1 | File selection from device storage |
| `image_picker` | ^1.0.4 | Image selection from camera or gallery |
| `cached_network_image` | ^3.3.0 | Image caching and loading |

### 7. Monitoring & Analytics

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | ^2.17.0 | Firebase SDK core functionality |
| `firebase_crashlytics` | ^3.4.1 | Crash reporting and analytics |
| `firebase_messaging` | ^14.6.9 | Push notification handling |
| `sentry_flutter` | ^7.9.0 | Error tracking and performance monitoring |

### 8. Device & Platform

| Package | Version | Purpose |
|---------|---------|---------|
| `device_info_plus` | ^9.1.0 | Device information and capabilities |
| `package_info_plus` | ^4.2.0 | Application package information |
| `url_launcher` | ^6.2.1 | Launch URLs in external applications |

### 9. Utilities

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_dotenv` | ^5.1.0 | Environment variable management |
| `intl` | ^0.18.1 | Internationalization and localization |
| `timezone` | ^0.9.2 | Timezone handling and conversion |
| `money2` | ^5.1.1 | Currency and money handling |
| `open_file` | ^3.3.2 | File opening with system applications |

### 10. Development

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Testing framework |
| `integration_test` | SDK | Integration testing |
| `mockito` | ^5.4.2 | Mock object generation for testing |
| `build_runner` | ^2.4.7 | Code generation build system |
| `injectable_generator` | ^2.4.1 | Code generation for dependency injection |

## Version Strategy

The framework follows a versioning strategy using caret (^) version constraints, which:

- **Allows automatic updates** to minor and patch versions
- **Maintains major version compatibility** to prevent breaking changes
- **Ensures stability** while receiving bug fixes and minor improvements

Example: `^8.1.2` allows versions from 8.1.2 up to (but not including) 9.0.0

## Platform-Specific Dependencies

### Web Platform
- Uses web-specific implementations of storage and cookie management
- Leverages browser APIs through `dart:html` and `dart:js`
- No additional native dependencies required

### Mobile Platforms (Android/iOS)
- Includes platform-specific implementations for secure storage
- Utilizes native authentication SDKs
- Requires platform permissions for biometric authentication

### Desktop Platforms (macOS/Windows/Linux)
- Adapted implementations for desktop environments
- Platform-specific secure storage implementations
- Desktop-appropriate file handling

## Dependency Management Best Practices

1. **Regular Updates**: Keep dependencies updated to benefit from security patches and improvements
2. **Version Pinning**: Use specific version ranges to avoid unexpected breaking changes
3. **Platform Testing**: Test on all target platforms when updating dependencies
4. **Security Auditing**: Regularly audit dependencies for security vulnerabilities
5. **Bundle Size**: Monitor dependency impact on application bundle size

## Optional Dependencies

Some dependencies are conditionally imported based on platform or feature flags:

- **Firebase dependencies**: Only included when Firebase features are enabled
- **Sentry**: Only included when error tracking is enabled
- **Biometric authentication**: Only available on platforms that support it

## Peer Dependencies

Applications using Supa Architecture should ensure compatibility with:

- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Platform-specific requirements** as defined by individual dependencies

---

*Documentation generated from [DeepWiki](https://deepwiki.com/supavn/supa_architecture)*