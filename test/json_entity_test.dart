import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:json_entity/json_entity.dart';

// Test models used for exercising the library API
class Address extends JsonModel {
  final street = JsonString('street');
  final city = JsonString('city');
  final zipCode = JsonString('zipCode');

  @override
  List<JsonField> get fields => [street, city, zipCode];
}

class Tag extends JsonModel {
  final id = JsonInteger('id');
  final name = JsonString('name');

  @override
  List<JsonField> get fields => [id, name];
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
        id,
        name,
        email,
        isActive,
        balance,
        createdAt,
        address,
        tags,
      ];
}

void main() {
  setUp(() async {
    final getIt = GetIt.instance;
    await getIt.reset();
    getIt.registerFactory<User>(() => User());
    getIt.registerFactory<Address>(() => Address());
    getIt.registerFactory<Tag>(() => Tag());
  });

  group('basic serialization/deserialization', () {
    test('fromJson maps values and toJson omits nulls and id=0', () {
      final user = GetIt.instance.get<User>();

      user.fromJson({
        'id': 0, // will be omitted on toJson (special id rule)
        'name': 'Alice',
        // 'email' intentionally omitted to verify omission when null
        'isActive': true,
        'balance': '19.99', // string -> double
        'createdAt': '2024-08-07T12:34:56Z',
        'errors': {
          'name': null,
          'email': 'Email required',
        },
        'warnings': {
          'name': 'Nickname looks short',
        },
        'informations': {
          'balance': 'Intro balance',
        },
      });

      // Access via fields and index operator
      expect(user.name.value, 'Alice');
      expect(user['name'], 'Alice');

      // Default behavior for missing string (rawValue is null, value is "")
      expect(user.email.rawValue, isNull);
      expect(user.email.value, '');

      // Type coercions
      expect(user.balance.value, 19.99);
      expect(user.isActive.value, isTrue);

      // Date parsing and serialization (compare by moment instead of exact string)
      final expectedMoment = DateTime.parse('2024-08-07T12:34:56Z');
      expect(user.createdAt.value.isAtSameMomentAs(expectedMoment), isTrue);

      final map = user.toJson();

      // id=0 omitted, email omitted (rawValue null)
      expect(map.containsKey('id'), isFalse);
      expect(map.containsKey('email'), isFalse);

      // Present keys
      expect(map['name'], 'Alice');
      expect(map['isActive'], true);
      expect(map['balance'], 19.99);

      // createdAt serialized as ISO UTC; verify same moment
      final serializedCreatedAt = map['createdAt'] as String;
      expect(
          DateTime.parse(serializedCreatedAt).isAtSameMomentAs(expectedMoment),
          isTrue);

      // toString returns JSON string encoding of toJson()
      final decoded = jsonDecode(user.toString());
      expect(decoded, map);

      // Validation metadata propagated to fields
      expect(user.email.hasError, isTrue);
      expect(user.email.error, 'Email required');
      expect(user.name.hasWarning, isTrue);
      expect(user.balance.hasInformation, isTrue);
    });
  });

  group('nested objects', () {
    test('JsonObject and JsonList deserialize and serialize correctly', () {
      final user = GetIt.instance.get<User>();

      user.fromJson({
        'id': 123,
        'name': 'Bob',
        'email': 'bob@example.com',
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

      // Object access
      final Address address = user.address.value;
      expect(address.city.value, 'Springfield');
      expect(user.address['street'], '1 Main St');

      // Update nested fields via operator[]=
      user.address['city'] = 'Shelbyville';
      expect(address.city.value, 'Shelbyville');

      // List access
      final Tag first = user.tags[0] as Tag;
      expect(first.name.value, 'pro');
      expect((user.tags[1] as Tag).id.value, 2);

      // Serialization of nested structures
      final json = user.toJson();
      expect(json['id'], 123);
      expect(json['address'], isA<Map<String, dynamic>>());
      expect(json['tags'], isA<List>());

      final addr = json['address'] as Map<String, dynamic>;
      expect(addr['city'], 'Shelbyville');

      final tags = (json['tags'] as List).cast<Map<String, dynamic>>();
      expect(tags.length, 2);
      expect(tags[0]['name'], 'pro');
      expect(tags[1]['id'], 2);
    });
  });
}
