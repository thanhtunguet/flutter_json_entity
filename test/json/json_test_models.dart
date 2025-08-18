import 'package:get_it/get_it.dart';
import 'package:supa_architecture/json/json.dart';

/// Test model for testing basic JSON field types
class TestBasicModel extends JsonModel {
  final JsonString name = JsonString('name');
  final JsonInteger age = JsonInteger('age');
  final JsonDouble height = JsonDouble('height');
  final JsonBoolean isActive = JsonBoolean('isActive');
  final JsonNumber score = JsonNumber('score');

  @override
  List<JsonField> get fields => [name, age, height, isActive, score];

  /// Factory constructor for dependency injection
  static TestBasicModel create() => TestBasicModel();
}

/// Test model for testing date fields
class TestDateModel extends JsonModel {
  final JsonString title = JsonString('title');
  final JsonDate createdAt = JsonDate('createdAt');
  final JsonDate updatedAt = JsonDate('updatedAt');

  @override
  List<JsonField> get fields => [title, createdAt, updatedAt];

  static TestDateModel create() => TestDateModel();
}

/// Test model for testing nested objects
class TestAddressModel extends JsonModel {
  final JsonString street = JsonString('street');
  final JsonString city = JsonString('city');
  final JsonString country = JsonString('country');
  final JsonInteger zipCode = JsonInteger('zipCode');

  @override
  List<JsonField> get fields => [street, city, country, zipCode];

  static TestAddressModel create() => TestAddressModel();
}

/// Test model for testing nested objects
class TestPersonModel extends JsonModel {
  final JsonString firstName = JsonString('firstName');
  final JsonString lastName = JsonString('lastName');
  final JsonInteger age = JsonInteger('age');
  final JsonObject<TestAddressModel> address =
      JsonObject<TestAddressModel>('address');

  @override
  List<JsonField> get fields => [firstName, lastName, age, address];

  static TestPersonModel create() => TestPersonModel();
}

/// Test model for testing lists
class TestListItemModel extends JsonModel {
  final JsonString itemName = JsonString('itemName');
  final JsonInteger quantity = JsonInteger('quantity');
  final JsonDouble price = JsonDouble('price');

  @override
  List<JsonField> get fields => [itemName, quantity, price];

  static TestListItemModel create() => TestListItemModel();
}

/// Test model for testing lists of objects
class TestOrderModel extends JsonModel {
  final JsonString orderId = JsonString('orderId');
  final JsonDate orderDate = JsonDate('orderDate');
  final JsonList<TestListItemModel> items =
      JsonList<TestListItemModel>('items');
  final JsonDouble totalAmount = JsonDouble('totalAmount');

  @override
  List<JsonField> get fields => [orderId, orderDate, items, totalAmount];

  static TestOrderModel create() => TestOrderModel();
}

/// Test model for testing complex nested structures
class TestCompanyModel extends JsonModel {
  final JsonString companyName = JsonString('companyName');
  final JsonInteger employeeCount = JsonInteger('employeeCount');
  final JsonBoolean isPublic = JsonBoolean('isPublic');
  final JsonDate foundedDate = JsonDate('foundedDate');
  final JsonObject<TestAddressModel> headquarters =
      JsonObject<TestAddressModel>('headquarters');
  final JsonList<TestPersonModel> employees =
      JsonList<TestPersonModel>('employees');
  final JsonList<TestOrderModel> orders = JsonList<TestOrderModel>('orders');

  @override
  List<JsonField> get fields => [
        companyName,
        employeeCount,
        isPublic,
        foundedDate,
        headquarters,
        employees,
        orders,
      ];

  static TestCompanyModel create() => TestCompanyModel();
}

/// Test model for testing error handling and validation
class TestValidationModel extends JsonModel {
  final JsonString requiredField = JsonString('requiredField');
  final JsonInteger numericField = JsonInteger('numericField');
  final JsonDouble decimalField = JsonDouble('decimalField');
  final JsonBoolean flagField = JsonBoolean('flagField');

  @override
  List<JsonField> get fields =>
      [requiredField, numericField, decimalField, flagField];

  static TestValidationModel create() => TestValidationModel();
}

/// Test model for testing edge cases
class TestEdgeCaseModel extends JsonModel {
  final JsonString emptyString = JsonString('emptyString');
  final JsonInteger zeroValue = JsonInteger('zeroValue');
  final JsonDouble nullValue = JsonDouble('nullValue');
  final JsonBoolean falseValue = JsonBoolean('falseValue');
  final JsonString specialChars = JsonString('specialChars');

  @override
  List<JsonField> get fields =>
      [emptyString, zeroValue, nullValue, falseValue, specialChars];

  static TestEdgeCaseModel create() => TestEdgeCaseModel();
}

/// Test model for testing ID field handling (should be excluded when value is 0)
class TestIdFieldModel extends JsonModel {
  final JsonInteger userId = JsonInteger('userId');
  final JsonInteger statusId = JsonInteger('statusId');
  final JsonInteger categoryId = JsonInteger('categoryId');
  final JsonString name = JsonString('name');

  @override
  List<JsonField> get fields => [userId, statusId, categoryId, name];

  static TestIdFieldModel create() => TestIdFieldModel();
}

/// Test model for testing JSON field operators
class TestOperatorModel extends JsonModel {
  final JsonString field1 = JsonString('field1');
  final JsonString field2 = JsonString('field2');
  final JsonInteger field3 = JsonInteger('field3');

  @override
  List<JsonField> get fields => [field1, field2, field3];

  static TestOperatorModel create() => TestOperatorModel();
}

/// Test model for testing list operators
class TestListOperatorModel extends JsonModel {
  final JsonList<TestListItemModel> items =
      JsonList<TestListItemModel>('items');

  @override
  List<JsonField> get fields => [items];

  static TestListOperatorModel create() => TestListOperatorModel();
}

/// Test model for testing object operators
class TestObjectOperatorModel extends JsonModel {
  final JsonObject<TestAddressModel> address =
      JsonObject<TestAddressModel>('address');

  @override
  List<JsonField> get fields => [address];

  static TestObjectOperatorModel create() => TestObjectOperatorModel();
}

/// Setup function to register test models with GetIt
void setupTestModels() {
  final getIt = GetIt.instance;

  // Register all test models
  getIt.registerFactory<TestBasicModel>(() => TestBasicModel.create());
  getIt.registerFactory<TestDateModel>(() => TestDateModel.create());
  getIt.registerFactory<TestAddressModel>(() => TestAddressModel.create());
  getIt.registerFactory<TestPersonModel>(() => TestPersonModel.create());
  getIt.registerFactory<TestListItemModel>(() => TestListItemModel.create());
  getIt.registerFactory<TestOrderModel>(() => TestOrderModel.create());
  getIt.registerFactory<TestCompanyModel>(() => TestCompanyModel.create());
  getIt
      .registerFactory<TestValidationModel>(() => TestValidationModel.create());
  getIt.registerFactory<TestEdgeCaseModel>(() => TestEdgeCaseModel.create());
  getIt.registerFactory<TestIdFieldModel>(() => TestIdFieldModel.create());
  getIt.registerFactory<TestOperatorModel>(() => TestOperatorModel.create());
  getIt.registerFactory<TestListOperatorModel>(
      () => TestListOperatorModel.create());
  getIt.registerFactory<TestObjectOperatorModel>(
      () => TestObjectOperatorModel.create());
}

/// Cleanup function to remove test models from GetIt
void cleanupTestModels() {
  final getIt = GetIt.instance;

  // Unregister all test models
  getIt.unregister<TestBasicModel>();
  getIt.unregister<TestDateModel>();
  getIt.unregister<TestAddressModel>();
  getIt.unregister<TestPersonModel>();
  getIt.unregister<TestListItemModel>();
  getIt.unregister<TestOrderModel>();
  getIt.unregister<TestCompanyModel>();
  getIt.unregister<TestValidationModel>();
  getIt.unregister<TestEdgeCaseModel>();
  getIt.unregister<TestIdFieldModel>();
  getIt.unregister<TestOperatorModel>();
  getIt.unregister<TestListOperatorModel>();
  getIt.unregister<TestObjectOperatorModel>();
}
