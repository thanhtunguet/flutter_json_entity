# supa_architecture library

## Overview
Empowering Your Flutter Projects with Clean Architecture and Pre-Built Functionalities

## Table of Contents
- [supa\_architecture library](#supa_architecture-library)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Compatibility](#compatibility)
    - [Key:](#key)
    - [Notes:](#notes)
  - [Usage](#usage)
    - [ApiClient](#apiclient)
    - [Blocs](#blocs)
      - [Authentication Bloc](#authentication-bloc)
      - [Tenant Bloc](#tenant-bloc)
    - [Constants](#constants)
    - [Data Models](#data-models)
    - [Exceptions](#exceptions)
    - [Extensions](#extensions)
    - [Filters](#filters)
      - [`DataFilter`](#datafilter)
      - [`FilterField`](#filterfield)
      - [`AbstractIdFilter<T>`](#abstractidfiltert)
      - [`AbstractNumberFilter<T>`](#abstractnumberfiltert)
      - [`DateFilter`](#datefilter)
      - [`DoubleFilter`, `IntFilter`, `NumberFilter`](#doublefilter-intfilter-numberfilter)
      - [`GuidFilter`](#guidfilter)
      - [`StringFilter`](#stringfilter)
    - [JSON Handling](#json-handling)
      - [`JsonField<T>`](#jsonfieldt)
      - [`JsonBoolean`](#jsonboolean)
      - [`JsonDate`](#jsondate)
      - [`JsonList<T>`](#jsonlistt)
      - [`JsonModel`](#jsonmodel)
      - [`JsonNumber`](#jsonnumber)
      - [`JsonObject<T>`](#jsonobjectt)
      - [`JsonSerializable`](#jsonserializable)
      - [`JsonString`](#jsonstring)
    - [Repositories](#repositories)
    - [Services](#services)
    - [Widgets](#widgets)
    - [SupaApplication](#supaapplication)
  - [Example](#example)
  - [Contributing](#contributing)
  - [License](#license)

## Installation
Instructions for adding the library to a Flutter project, including how to update `pubspec.yaml`.

```yaml
dependencies:
  supa_application: ^1.0.0
```

## Compatibility

The `supa_architecture` package is designed to support multiple platforms. However, some features depend on underlying platform-specific implementations, which may limit functionality on certain platforms. Below is a summary of feature compatibility:

| **Feature**                                                                                          | **Android**  | **iOS** | **Web**    | **Windows** | **macOS**         | **Linux** |
|------------------------------------------------------------------------------------------------------|--------------|---------|------------|-------------|-------------------|-----------|
| **Cookie Management** (`cookie_jar`, `dio_cookie_manager`)                                           | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Dio HTTP Client** (`dio`)                                                                          | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Secure Storage** (`flutter_secure_storage`)                                                        | ✅            | ✅       | ✅          | ❌           | ✅                 | ✅         |
| **Local Database** (`hive`, `hive_flutter`)                                                          | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Path Management** (`path`, `path_provider`)                                                        | ✅            | ✅       | ❌          | ✅           | ✅                 | ✅         |
| **State Management** (`bloc`, `flutter_bloc`, `rxdart`)                                              | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Routing** (`go_router`)                                                                            | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **OAuth** (`aad_oauth`, `google_sign_in`, `sign_in_with_apple`)                                      | ✅ (limited)* | ✅       | ✅ (Google) | ❌           | ✅ (Apple, Google) | ❌         |
| **Environment Variables** (`flutter_dotenv`)                                                         | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Firebase** (`firebase_core`, `firebase_crashlytics`, `firebase_performance`, `firebase_messaging`) | ✅            | ✅       | ✅          | ❌           | ✅                 | ❌         |
| **Sentry Integration** (`sentry_flutter`)                                                            | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Permissions** (`permission_handler`)                                                               | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Package Information** (`package_info_plus`)                                                        | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Reactive Forms** (`reactive_forms`)                                                                | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Biometric Authentication** (`local_auth`)                                                          | ✅            | ✅       | ❌          | ❌           | ✅                 | ❌         |
| **Device Information** (`device_info_plus`)                                                          | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |
| **Internationalization** (`intl`)                                                                    | ✅            | ✅       | ✅          | ✅           | ✅                 | ✅         |

### Key:
- ✅ = Supported
- ❌ = Not Supported
- * = Limited Support

### Notes:
- **OAuth**: While `aad_oauth` and `sign_in_with_apple` provide strong support for mobile and macOS, web and desktop support are limited or unavailable.
- **Secure Storage**: `flutter_secure_storage` lacks support for Windows, but alternatives like `shared_preferences` can be used on unsupported platforms.
- **Biometric Authentication**: `local_auth` is supported on mobile and macOS, but not on web, Windows, or Linux.

For cross-platform development, ensure to handle platform-specific limitations using conditional imports or platform checks. For unsupported features on specific platforms, consider alternative implementations.

## Usage
### ApiClient
Describe how to use the `ApiClient` class, including:
- How to initialize it
- Examples of making HTTP requests
- Methods for converting responses into specific types

### Blocs
#### Authentication Bloc
Explain how the Authentication Bloc manages user authentication, including:
- How to initialize and use the bloc
- Key methods and events

#### Tenant Bloc
Detail the Tenant Bloc for handling multi-tenancy, including:
- Initialization and usage
- Key methods and events

### Constants
List and describe the constants available, such as date-time formats.

### Data Models
Provide an overview of the built-in data model classes, including:
- Key classes and their purposes
- Example usage

### Exceptions
Describe custom exceptions defined in the library and their usage.

### Extensions
List the Dart/Flutter class extensions provided and their benefits.

### Filters

#### `DataFilter`

The `DataFilter` class provides a structure for filtering and querying data. It supports pagination, sorting, and basic filtering operations. It is designed to be used with a list of `FilterField` objects, which specify the filtering criteria for individual fields.

**Properties:**

- `int skip` – The number of entities to skip in a request.
- `int take` – The number of entities to take in a request.
- `String? orderBy` – The field name to order by.
- `String? orderType` – The order orientation (`"ASC"` or `"DESC"`).
- `String? search` – The search field.
- `String? viewCode` – The document view code.

**Methods:**

- `Map<String, dynamic> toJSON()` – Converts the filter to a JSON representation.
- `void fromJSON(dynamic json)` – Populates the filter from a JSON object.
- `String toString()` – Returns a JSON string representation of the filter.
- `int nextPage()` – Calculates the index of the next page for pagination.

---

#### `FilterField`

The `FilterField` class is the base class for specific filter types. It includes common filter operations as constants and implements JSON serialization and deserialization.

**Constants:**

- `String less` – Less than operation.
- `String lessEqual` – Less than or equal to operation.
- `String greater` – Greater than operation.
- `String greaterEqual` – Greater than or equal to operation.
- `String equal` – Equal to operation.
- `String notEqual` – Not equal to operation.
- `String contain` – Contains operation.
- `String notContain` – Does not contain operation.
- `String startWith` – Starts with operation.
- `String notStartWith` – Does not start with operation.
- `String endWith` – Ends with operation.
- `String notEndWith` – Does not end with operation.
- `String inList` – In list operation.
- `String notInList` – Not in list operation.
- `String search` – Search operation.
- `String viewCode` – View code operation.

**Properties:**

- `final String name` – The name of the filter field.

**Methods:**

- `String toString()` – Returns a JSON string representation of the filter field.

---

#### `AbstractIdFilter<T>`

The `AbstractIdFilter` class provides filtering operations for ID fields of type `T`. It allows filtering by a specific ID, excluding an ID, or working with lists of IDs.

**Properties:**

- `List<T>? inList` – List of IDs to match.
- `List<T>? notInList` – List of IDs to exclude.
- `T? equal` – Specific ID to match.
- `T? notEqual` – ID to exclude.

**Methods:**

- `Map<String, dynamic> toJSON()` – Converts the filter to a JSON representation.
- `void fromJSON(dynamic json)` – Populates the filter from a JSON object.

---

#### `AbstractNumberFilter<T>`

The `AbstractNumberFilter` class provides filtering operations for number fields of type `T`. It supports operations like greater than, less than, equal to, and not equal to.

**Properties:**

- `T? greaterEqual` – Value to match greater than or equal to.
- `T? lessEqual` – Value to match less than or equal to.
- `T? greater` – Value to match greater than.
- `T? less` – Value to match less than.
- `T? equal` – Value to match.
- `T? notEqual` – Value to exclude.

**Methods:**

- `Map<String, dynamic> toJSON()` – Converts the filter to a JSON representation.
- `void fromJSON(dynamic json)` – Populates the filter from a JSON object.

---

#### `DateFilter`

The `DateFilter` class extends `AbstractNumberFilter` to support filtering of `DateTime` fields. It uses date-time values for operations and converts them to and from ISO 8601 string format.

**Methods:**

- `Map<String, dynamic> toJSON()` – Converts the filter to a JSON representation with date-time values in ISO 8601 format.
- `void fromJSON(dynamic json)` – Populates the filter from a JSON object with date-time values.

---

#### `DoubleFilter`, `IntFilter`, `NumberFilter`

These classes extend `AbstractNumberFilter` for specific number types:

- **`DoubleFilter`** – For `double` values.
- **`IntFilter`** – For `int` values.
- **`NumberFilter`** – For `num` values.

They inherit filtering operations from `AbstractNumberFilter` but are specialized for their respective types.

---

#### `GuidFilter`

The `GuidFilter` class extends `AbstractIdFilter` for `String` type IDs, often used for GUIDs.

**Methods:**

- `Map<String, dynamic> toJSON()` – Converts the filter to a JSON representation.
- `void fromJSON(dynamic json)` – Populates the filter from a JSON object.

---

#### `StringFilter`

The `StringFilter` class provides filtering operations for `String` fields. It includes operations for equality, containment, and string matching.

**Properties:**

- `String? equal` – Value to match.
- `String? notEqual` – Value to exclude.
- `String? startWith` – Value that the field should start with.
- `String? notStartWith` – Value that the field should not start with.
- `String? endWith` – Value that the field should end with.
- `String? notEndWith` – Value that the field should not end with.
- `String? contain` – Value that should be contained in the field.
- `String? notContain` – Value that should not be contained in the field.

**Methods:**

- `Map<String, dynamic> toJSON()` – Converts the filter to a JSON representation.
- `void fromJSON(dynamic json)` – Populates the filter from a JSON object.

### JSON Handling

The `json.dart` file provides a robust mechanism for handling JSON serialization and deserialization using a set of classes and interfaces. This approach ensures type safety and easy conversion between JSON data and Dart objects.

#### `JsonField<T>`

An abstract class representing a field in a JSON object.

- **Properties:**
  - `fieldName`: The name of the field in the JSON object.
  - `error`: An optional error message for the field.
  - `warning`: An optional warning message for the field.
  - `information`: An optional information message for the field.
  - `rawValue`: The raw value of the field.

- **Methods:**
  - `value`: Retrieves the value of the field. Subclasses must override this to provide specific behavior.
  - `toJSON()`: Converts the field to its JSON representation.

#### `JsonBoolean`

A concrete class for handling boolean values.

- **Constructor:**
  - `JsonBoolean(String fieldName)`: Creates an instance with the specified field name.

- **Methods:**
  - `value`: Gets the boolean value, defaulting to `false` if `rawValue` is `null`.
  - `toJSON()`: Converts the boolean value to JSON.

#### `JsonDate`

A concrete class for handling `DateTime` values.

- **Constructor:**
  - `JsonDate(String fieldName)`: Creates an instance with the specified field name.

- **Methods:**
  - `value`: Gets the `DateTime` value, defaulting to the current date if `rawValue` is `null`.
  - `format({String dateFormat})`: Formats the date according to the specified format.
  - `toJSON()`: Converts the `DateTime` value to its ISO 8601 string representation.

#### `JsonList<T>`

A generic class for handling lists of `JsonModel` objects.

- **Constructor:**
  - `JsonList(String fieldName, InstanceConstructor<T> type)`: Creates an instance with the specified field name and type constructor.

- **Methods:**
  - `value`: Gets the list of objects, defaulting to an empty list if `rawValue` is `null`.
  - `toJSON()`: Converts the list to its JSON representation.
  - `operator [](int index)`: Retrieves an item at the specified index.
  - `operator []=(int index, value)`: Sets an item at the specified index.

#### `JsonModel`

An abstract class for models that can be serialized/deserialized to/from JSON.

- **Properties:**
  - `fields`: A list of `JsonField` instances representing the fields of the model.
  - `generalErrors`, `generalWarnings`, `generalInformations`: Lists of general error, warning, and information messages.
  - `errors`, `warnings`, `informations`: Maps of field names to error, warning, and information messages.

- **Methods:**
  - `fromJSON(dynamic json)`: Populates the model from a JSON object.
  - `toJSON()`: Converts the model to a JSON object.
  - `toString()`: Returns a JSON string representation of the model.
  - `operator [](String name)`: Retrieves the value of a field by name.
  - `operator []=(String name, value)`: Sets the value of a field by name.

#### `JsonNumber`

A concrete class for handling numeric values.

- **Constructor:**
  - `JsonNumber(String fieldName)`: Creates an instance with the specified field name.

- **Methods:**
  - `value`: Gets the numeric value, defaulting to `0` if `rawValue` is `null`.
  - `toJSON()`: Converts the numeric value to JSON.

#### `JsonObject<T>`

A generic class for handling complex objects that extend `JsonModel`.

- **Constructor:**
  - `JsonObject(String fieldName, InstanceConstructor<T> type)`: Creates an instance with the specified field name and type constructor.

- **Methods:**
  - `value`: Gets the object, defaulting to a new instance if `rawValue` is `null`.
  - `toJSON()`: Converts the object to its JSON representation.
  - `operator [](String name)`: Retrieves the value of a field by name.
  - `operator []=(String name, value)`: Sets the value of a field by name.

#### `JsonSerializable`

A mixin for classes that need to support JSON serialization and deserialization.

- **Methods:**
  - `fromJSON(dynamic json)`: Populates the class from a JSON object.
  - `toJSON()`: Converts the class to a JSON object.

#### `JsonString`

A concrete class for handling string values.

- **Constructor:**
  - `JsonString(String fieldName)`: Creates an instance with the specified field name.

- **Methods:**
  - `toJSON()`: Converts the string value to JSON.
  - `value`: Retrieves the string value, defaulting to a specific null string message if `rawValue` is `null`.

### Repositories
Provide an overview of repository classes, including:
- Authentication
- Multi-tenancy
- Cookies
- Persistent data
- Secure storage

### Services
Describe the services provided by the library, including:
- Logic handling
- Cookie management
- Security

### Widgets
Explain the reusable widgets provided, including:
- Key widgets
- Examples of usage

### SupaApplication
Detail the main class, `SupaApplication`, including:
- Its purpose
- How it integrates with other parts of the library

## Example

See package example here:

[example/example.md](example/example.md)

[Push Notification Bloc Documentation](docs/bloc_push_notification.md)

[Using ChatGPT to generate entity][docs/chatgpt_entity_generation.md]

## Contributing
Instructions for contributing to the library, including guidelines for submitting issues and pull requests.

## License
Specify the license under which the library is distributed.
