# JSON Module Tests

This directory contains comprehensive tests for the JSON module of the Supa Architecture library.

## Overview

The JSON module provides a robust framework for handling JSON serialization and deserialization in Flutter applications. It includes:

- **JsonField**: Base class for all JSON field types
- **JsonModel**: Abstract base class for JSON models
- **JsonSerializable**: Mixin for JSON serialization/deserialization
- **Field Types**: Specialized classes for different data types (String, Integer, Double, Boolean, Date, etc.)
- **Complex Types**: Support for nested objects, lists, and complex data structures

## Test Files

### 1. `json_test_models.dart`
Contains comprehensive test model classes that demonstrate various use cases:

- **TestBasicModel**: Tests basic field types (String, Integer, Double, Boolean, Number)
- **TestDateModel**: Tests date field handling and formatting
- **TestAddressModel**: Simple nested object model
- **TestPersonModel**: Model with nested object relationships
- **TestListItemModel**: Model for list items
- **TestOrderModel**: Model with list of objects
- **TestCompanyModel**: Complex nested structure with multiple relationships
- **TestValidationModel**: Tests error handling and validation
- **TestEdgeCaseModel**: Tests edge cases and special characters
- **TestIdFieldModel**: Tests ID field handling (exclusion when value is 0)
- **TestOperatorModel**: Tests field access operators
- **TestListOperatorModel**: Tests list-specific operators
- **TestObjectOperatorModel**: Tests object-specific operators

### 2. `json_module_test.dart`
Main test suite covering all aspects of the JSON module:

- **JsonField Base Tests**: Basic field functionality, error handling, equality
- **Field Type Tests**: Individual tests for each field type (String, Integer, Double, Boolean, Date, Number)
- **JsonObject Tests**: Nested object handling and serialization
- **JsonList Tests**: List handling, bounds checking, and operators
- **JsonModel Tests**: Model serialization/deserialization, nested structures, error handling
- **Edge Cases**: Special character handling, null values, invalid data types
- **Performance Tests**: Large data handling and deep nesting performance

### 3. `json_serializable_test.dart`
Tests for the JsonSerializable mixin:

- **Basic Serialization**: Simple object serialization/deserialization
- **Complex Data Types**: Lists, maps, and DateTime handling
- **Nested Objects**: Complex nested structures and relationships
- **Edge Cases**: Error handling, null inputs, missing fields
- **Performance**: Large data sets and deep nesting

## Running the Tests

### Run All JSON Tests
```bash
flutter test test/json/
```

### Run Specific Test Files
```bash
# Main module tests
flutter test test/json/json_module_test.dart

# Serializable mixin tests
flutter test test/json/json_serializable_test.dart
```

### Run Specific Test Groups
```bash
# Run only field type tests
flutter test test/json/json_module_test.dart --plain-name "JsonString Tests"

# Run only model tests
flutter test test/json/json_module_test.dart --plain-name "JsonModel Tests"
```

## Test Coverage

The tests cover:

### Field Types
- ✅ JsonString: String handling, null values, empty strings
- ✅ JsonInteger: Integer parsing, string conversion, bounds
- ✅ JsonDouble: Double precision, string parsing, type conversion
- ✅ JsonBoolean: Boolean values, null handling
- ✅ JsonNumber: Generic numeric types
- ✅ JsonDate: DateTime handling, formatting, timezone extensions
- ✅ JsonObject: Nested object relationships
- ✅ JsonList: List handling, bounds checking, operators

### Core Functionality
- ✅ Serialization (toJson)
- ✅ Deserialization (fromJson)
- ✅ Error handling and validation
- ✅ Warning and information messages
- ✅ Field-level error management
- ✅ Model-level error management

### Advanced Features
- ✅ Nested object relationships
- ✅ List of objects
- ✅ Complex nested structures
- ✅ ID field exclusion (when value is 0)
- ✅ Field access operators
- ✅ Performance optimization
- ✅ Edge case handling

### Error Handling
- ✅ Invalid data type conversion
- ✅ Missing fields
- ✅ Extra fields
- ✅ Null value handling
- ✅ Empty collections
- ✅ Special characters

## Test Models Usage Examples

### Basic Model
```dart
final model = TestBasicModel.create();
model.name.value = 'John Doe';
model.age.value = 30;
model.height.value = 175.5;
model.isActive.value = true;

final json = model.toJson();
final newModel = TestBasicModel.create()..fromJson(json);
```

### Nested Object
```dart
final person = TestPersonModel.create();
person.firstName.value = 'John';
person.lastName.value = 'Doe';

final address = TestAddressModel.create();
address.street.value = '123 Main St';
address.city.value = 'New York';

person.address.value = address;

final json = person.toJson();
```

### List of Objects
```dart
final order = TestOrderModel.create();
order.orderId.value = 'ORD-001';

final items = [
  TestListItemModel.create()
    ..itemName.value = 'Product A'
    ..quantity.value = 2
    ..price.value = 29.99,
];

order.items.value = items;
```

## Dependencies

The tests use:
- **Flutter Test**: Core testing framework
- **GetIt**: Dependency injection for test model creation
- **DateTime Extensions**: Custom extensions for date formatting

## Notes

- All test models are registered with GetIt for dependency injection
- Tests include setup and teardown for proper isolation
- Performance tests ensure operations complete within reasonable time limits
- Edge case tests cover real-world scenarios and error conditions
- The test suite validates both the public API and internal behavior

## Contributing

When adding new features to the JSON module:
1. Add corresponding test cases to the appropriate test file
2. Ensure all existing tests continue to pass
3. Add performance tests for new functionality
4. Include edge case testing for error conditions
5. Update this README with new test coverage information
