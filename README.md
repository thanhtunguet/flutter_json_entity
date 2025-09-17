# json_entity

A lightweight, Laravel-inspired JSON mapping library for Dart/Flutter that avoids code generation. Define rich models using field objects (`JsonString`, `JsonInteger`, `JsonDouble`, `JsonBoolean`, `JsonDate`, `JsonNumber`, `JsonObject`, `JsonList`) and serialize/deserialize without `.g.dart` files.

This approach is inspired by Laravel Eloquent's implicit attribute mapping and whitelisting/blacklisting philosophy. It keeps models explicit and composable, while eliminating build-step overhead and IDE slowdowns.

- **No code generation**: zero builders, no watch tasks, no generated files.
- **Explicit fields**: models declare fields as objects with type-aware behavior.
- **Nested models & lists**: compose with `JsonObject<T>` and `JsonList<T>`.
- **Validation metadata**: per-field `error`, `warning`, `information` plus model-level collections.
- **Selective output**: only non-null values are serialized; special handling for `id`-suffixed fields.

For background and motivation, read the article: [Overcome Flutter JSON drawbacks](https://thanhtunguet.info/posts/overcome-flutter-json-drawbacks/).

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  json_entity: ^1.0.0
```

This package depends on `get_it` and `intl`.

---

## Core concepts

- **JsonModel**: base class for your models. Implements `fromJson` and `toJson` over a list of declared `fields`.
- **JsonField<T>**: base class for fields. Concrete types provide parsing, defaults, and JSON conversion.
- **GetIt**: used to construct nested models when deserializing `JsonObject<T>` and `JsonList<T>`.

### Field types

- `JsonString`, `JsonInteger`, `JsonDouble`, `JsonBoolean`, `JsonNumber`
- `JsonDate` (string parsing, ISO output in UTC)
- `JsonObject<T extends JsonModel>` (nested model)
- `JsonList<T extends JsonModel>` (list of nested models)

All fields expose:
- `rawValue` (nullable backing store)
- `value` getter (type-safe, with sensible defaults like empty string or 0)
- `error` / `warning` / `information` (metadata for validation/UX)

---

## Quick start

1) Register your model types with `GetIt` so nested objects/lists can be constructed during `fromJson`:

```dart
final getIt = GetIt.instance;
getIt.registerFactory<User>(() => User());
getIt.registerFactory<Address>(() => Address());
```

2) Define models by extending `JsonModel` and declaring `fields`:

```dart
class Address extends JsonModel {
  final street = JsonString('street');
  final city = JsonString('city');
  final zipCode = JsonString('zipCode');

  @override
  List<JsonField> get fields => [street, city, zipCode];
}

class User extends JsonModel {
  final id = JsonInteger('id');
  final name = JsonString('name');
  final email = JsonString('email');
  final isActive = JsonBoolean('isActive');
  final balance = JsonDouble('balance');
  final createdAt = JsonDate('createdAt');

  final address = JsonObject<Address>('address');
  final tags = JsonList<Tag>('tags');

  @override
  List<JsonField> get fields => [
    id, name, email, isActive, balance, createdAt,
    address, tags,
  ];
}

class Tag extends JsonModel {
  final id = JsonInteger('id');
  final name = JsonString('name');

  @override
  List<JsonField> get fields => [id, name];
}
```

3) Deserialize from JSON:

```dart
final user = getIt<User>();
user.fromJson({
  'id': 0,
  'name': 'Alice',
  'email': 'alice@example.com',
  'isActive': true,
  'balance': '19.99',
  'createdAt': '2024-08-07T12:34:56Z',
  'address': {
    'street': '1 Main St',
    'city': 'Springfield',
    'zipCode': '12345',
  },
  'tags': [
    {'id': 1, 'name': 'pro'},
    {'id': 2, 'name': 'beta'},
  ],
});

// Access values
afinal String name = user['name'];
final String city = user.address['city'];
final Tag firstTag = user.tags[0];
```

4) Serialize to JSON:

```dart
final map = user.toJson();
final json = user.toString(); // jsonEncode(toJson())
```

Serialization rules:
- Only fields with non-null `rawValue` are emitted.
- Fields whose name ends with `id` (case-insensitive) except `statusId` are omitted if their `value` is `0`.
- Fields use their specific `toJson` implementations (e.g., `JsonDate` outputs UTC ISO 8601).

---

## Working with values vs rawValue

- Use `value` to read/write in a type-safe way. Implementations accept helpful inputs:
  - `JsonInteger` parses numeric strings.
  - `JsonDouble` accepts `int`, `double`, numeric `String`.
  - `JsonDate` accepts ISO string and outputs UTC ISO string.
- Use `rawValue` if you need to check presence (`null`) vs defaulted value.

Examples:

```dart
user.balance.value = '42.5'; // stored as double
user.createdAt.value = '2024-08-07T12:34:56Z';

if (user.email.isNull) {
  user.email.error = 'Email is required';
}
```

---

## Validation metadata and messages

At the model level:
- `generalErrors`, `generalWarnings`, `generalInformations` (Lists)
- `errors`, `warnings`, `informations` (fieldName -> message)

`fromJson` maps these structures into matching field properties so your UI can bind per-field messages:

```dart
user.fromJson({
  'errors': {
    'email': 'Email already taken',
  },
  'warnings': {
    'name': 'Nickname looks too short',
  }
});

if (user.email.hasError) {
  print(user.email.error);
}
```

---

## Nested objects and lists

`JsonObject<T>` and `JsonList<T>` construct nested model instances using `GetIt`. Register factories for all `T` types you nest.

```dart
getIt.registerFactory<Order>(() => Order());
getIt.registerFactory<OrderItem>(() => OrderItem());

class Order extends JsonModel {
  final id = JsonInteger('id');
  final items = JsonList<OrderItem>('items');
  @override
  List<JsonField> get fields => [id, items];
}

class OrderItem extends JsonModel {
  final sku = JsonString('sku');
  final qty = JsonInteger('qty');
  @override
  List<JsonField> get fields => [sku, qty];
}
```

---

## Date handling

`JsonDate`:
- `value` returns `DateTime` (defaults to `DateTime.now()` if `rawValue` is null).
- Accepts ISO strings on assignment and parses with `DateTime.tryParse`.
- `toJson()` emits `toUtc().toIso8601String()`.
- `format()` uses `intl` `DateFormat` (default `dd/MM/yyyy`).

Utility extension `DateTimeOffsetExtensions` provides:
- `getTimezoneOffsetString()` as `±hh:mm` or empty for UTC.
- `toIso8601StringWithOffset()` appends offset string to `toIso8601String()`.

---

## Access helpers

- Index into models by field name: `model['name']`, `model['id'] = 123`.
- Index into objects/lists: `jsonObject['city']`, `jsonList[0]`.

Out-of-range or missing-field access throws an exception to surface errors early.

---

## Why this approach (vs code generation)?

- **No build step**: instant feedback, simpler CI, fewer moving parts.
- **Lean repo**: no `.g.dart` file explosion; easier navigation and diffs.
- **IDE performance**: fewer files to index; faster search and refactors.
- **Explicit mapping**: fields are first-class citizens where you attach validation and transformation logic.
- **Composable**: nested models and lists are defined declaratively without annotations.

If you prefer annotation-based codegen, packages like `json_serializable` are great. This library targets teams that value runtime composition and development ergonomics akin to Laravel Eloquent.

---

## Tips

- Always register nested model types in `GetIt` before calling `fromJson`.
- Use `rawValue` null checks to control serialization output.
- For IDs, setting `0` effectively omits the key (except `statusId`).
- `JsonList` defaults to an empty list and maps elements via `GetIt`.

---

## License

MIT © Thanh Tung
