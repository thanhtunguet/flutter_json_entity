# Project Structure

The `supa_architecture` framework is structured as a Flutter plugin with a clear separation of concerns. The codebase follows a modular approach with specialized directories for each major subsystem.

## Overall Package Organization

```
supa_architecture/
├── lib/                          # Main library code
├── example/                      # Example application
├── test/                         # Unit tests
├── android/                      # Android platform implementation
├── ios/                          # iOS platform implementation
├── web/                          # Web platform implementation
├── macos/                        # macOS platform implementation
├── windows/                      # Windows platform implementation
├── linux/                        # Linux platform implementation
└── doc/                          # Documentation
```

## Main Library Structure

The `lib/` directory contains the core framework code organized by functionality:

```
lib/
├── api_client/                   # HTTP client and interceptors
├── blocs/                        # Business Logic Components
├── constants/                    # Application constants
├── core/                         # Core functionality
├── exceptions/                   # Custom exceptions
├── extensions/                   # Dart extensions
├── filters/                      # Data filtering
├── forms/                        # Form handling
├── json/                         # JSON serialization system
├── models/                       # Data models
├── providers/                    # Custom providers
├── repositories/                 # Data access layer
├── services/                     # Business services
├── utils/                        # Utility functions
├── widgets/                      # UI components
├── supa_architecture.dart        # Main export file
└── supa_architecture_platform_interface.dart  # Platform interface
```

## Directory Structure and Purpose

| Directory | Purpose |
|-----------|---------|
| `api_client/` | Houses the `ApiClient` implementation and related interceptors for HTTP communication |
| `blocs/` | Contains all Business Logic Components (BLoCs) that manage application state |
| `constants/` | Defines application-wide constants and configuration values |
| `core/` | Provides core functionality including storage implementations |
| `exceptions/` | Contains custom exception classes and error handling mechanisms |
| `extensions/` | Defines Dart extensions to enhance functionality of existing classes |
| `filters/` | Implements data filtering capabilities for API queries |
| `forms/` | Offers form-handling utilities and validation logic |
| `json/` | Houses the JSON serialization/deserialization system |
| `models/` | Contains data model classes representing business entities |
| `providers/` | Custom Flutter providers for specific functionality |
| `repositories/` | Implements the repository pattern for data access abstraction |
| `services/` | Contains business services and utility services |
| `utils/` | Utility functions and helper classes |
| `widgets/` | UI components organized by atomic design principles |

## Core Subsystem Details

### API Client (`api_client/`)

```
api_client/
├── api_client.dart               # Main HTTP client
├── dio_exception.dart            # Custom exception handling
├── http_response.dart            # Response wrapper
└── interceptors/                 # Request/response interceptors
    ├── device_info_interceptor.dart
    ├── general_error_log_interceptor.dart
    ├── persistent_url_interceptor.dart
    ├── refresh_interceptor.dart
    └── timezone_interceptor.dart
```

### BLoCs (`blocs/`)

```
blocs/
├── authentication/               # Authentication state management
├── error_handling/              # Global error handling
├── push_notification/           # Notification management
├── tenant/                      # Multi-tenant support
└── blocs.dart                   # Barrel export
```

### Core (`core/`)

```
core/
├── cookie_manager/              # Cookie management abstraction
│   ├── cookie_manager.dart
│   ├── hive_cookie_manager.dart
│   └── web_cookie_manager.dart
├── persistent_storage/          # Persistent storage abstraction
│   ├── persistent_storage.dart
│   ├── hive_persistent_storage.dart
│   └── web_persistent_storage.dart
├── secure_storage/              # Secure storage abstraction
│   └── secure_storage.dart
├── app_token.dart               # Token management
├── device_info.dart             # Device information
├── secure_authentication_info.dart  # Secure auth data
└── tenant_authentication.dart   # Tenant-specific auth
```

### JSON System (`json/`)

```
json/
├── json_model.dart              # Base model class
├── json_field.dart              # Field definitions
├── json_serializable.dart       # Serialization logic
├── json_boolean.dart            # Boolean field type
├── json_date.dart               # Date field type
├── json_double.dart             # Double field type
├── json_integer.dart            # Integer field type
├── json_list.dart               # List field type
├── json_number.dart             # Number field type
├── json_object.dart             # Object field type
└── json_string.dart             # String field type
```

### Models (`models/`)

The models directory contains business entity representations:

```
models/
├── admin_type.dart              # Administrator types
├── app_user.dart                # Application user model
├── attachment.dart              # File attachment model
├── current_tenant.dart          # Current tenant information
├── enum_model.dart              # Enumeration base class
├── file.dart                    # File model
├── global_user.dart             # Global user model
├── image.dart                   # Image model
├── language.dart                # Language model
├── sub_system.dart              # Subsystem model
├── tenant.dart                  # Tenant model
├── timezone.dart                # Timezone model
├── user_notification.dart       # User notification model
└── models.dart                  # Barrel export
```

### Widgets (`widgets/`)

UI components organized by atomic design principles:

```
widgets/
├── atoms/                       # Basic UI elements
│   ├── app_image.dart
│   ├── carbon_button.dart
│   ├── field_label.dart
│   ├── loading_indicator.dart
│   └── text_status_badge.dart
├── molecules/                   # Component combinations
│   ├── enum_status_badge.dart
│   └── social_sign_in_button.dart
├── organisms/                   # Complex components
│   ├── confirmation_dialog.dart
│   ├── empty_component.dart
│   ├── forbidden_component.dart
│   └── searchable_appbar_title.dart
├── pages/                       # Full page components
│   └── page_forbidden.dart
├── templates/                   # Layout templates
│   ├── bottom_sheet_container.dart
│   └── infinite_list_state.dart
└── widgets.dart                 # Barrel export
```

## Platform-Specific Implementations

Each platform has its own directory with platform-specific code:

### Android (`android/`)
- Kotlin implementation for Android-specific features
- Gradle build configuration
- Android manifest and resources

### iOS (`ios/`)
- Swift implementation for iOS-specific features
- CocoaPods podspec configuration
- iOS plist and resources

### Web (`web/`)
- Web-specific implementations using browser APIs
- No native code required

### Desktop (`macos/`, `windows/`, `linux/`)
- Platform-specific implementations for desktop operating systems
- CMake build configuration for Windows and Linux
- CocoaPods configuration for macOS

## Component Relationships

The framework components are designed to work together:

1. **UI Layer** (widgets) communicates with **Business Logic Layer** (blocs)
2. **BLoCs** use **Repositories** for data access
3. **Repositories** utilize **API Client** and **Core** services
4. **Models** define data structures used throughout all layers
5. **Platform Interface** provides abstraction for platform-specific functionality

## Extension Points

The framework provides several extension points for customization:

- Custom **BLoCs** for application-specific business logic
- Custom **Models** extending the JSON model system
- Custom **Widgets** following the atomic design pattern
- Custom **Repositories** implementing the repository interface
- Custom **Interceptors** for API client customization

---

*Documentation generated from [DeepWiki](https://deepwiki.com/supavn/supa_architecture)*