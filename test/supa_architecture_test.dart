import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' hide test;
import 'package:supa_architecture/config/get_it.dart';
import 'package:supa_architecture/supa_architecture.dart' hide AppUser;

import 'models/app_user.dart';

@InjectableInit()
Future<void> configureDeps() async {
  getIt.registerFactory<AppUser>(AppUser.new);
  // Asynchronous setup before each test
  await SupaApplication.initialize();
}

void main() {
  setUpAll(configureDeps);

  group('JSON', () {
    final appUser = AppUser();
    appUser.fromJSON({
      'id': 1,
      'code': 'ThangLD',
      'name': 'Le Duc Thang',
      'birthday': '1991-05-10',
      'supervisor': {
        'id': 2,
        'code': 'VuDT',
        'name': 'Dang Tuan Vu',
        'birthday': '1990-03-14',
      },
      'students': [
        {
          'id': 3,
          'code': 'TungPT',
          'name': 'Pham Thanh Tung',
          'birthday': '1997-11-01',
        },
        {
          'id': 4,
          'code': 'TienTV',
          'name': 'Tran Van Tien',
          'birthday': '1997-09-09',
        }
      ]
    });

    test('json deserialization', () {
      expect(appUser.id.value, 1);
      expect(appUser.code.value, 'ThangLD');
      expect(appUser.name.value, 'Le Duc Thang');
      expect(appUser.birthday.value, DateTime.parse('1991-05-10'));
      expect(appUser.supervisor.value.id.value, 2);
      expect(appUser.supervisor.value.code.value, 'VuDT');
      expect(appUser.supervisor.value.name.value, 'Dang Tuan Vu');
      expect(appUser.supervisor.value.birthday.value,
          DateTime.parse('1990-03-14'));
      expect(appUser.students.value.length, 2);
      expect(appUser.students.value[0].id.value, 3);
      expect(appUser.students.value[0].code.value, 'TungPT');
      expect(appUser.students.value[0].name.value, 'Pham Thanh Tung');
      expect(appUser.students.value[0].birthday.value,
          DateTime.parse('1997-11-01'));
      expect(appUser.students.value[1].id.value, 4);
      expect(appUser.students.value[1].code.value, 'TienTV');
      expect(appUser.students.value[1].name.value, 'Tran Van Tien');
      expect(appUser.students.value[1].birthday.value,
          DateTime.parse('1997-09-09'));
    });

    test('json serialization', () {
      final String stringized = appUser.toString();
      final AppUser newAppUser = AppUser();
      newAppUser.fromJSON(jsonDecode(stringized));
      final String newAppUserStringized = newAppUser.toString();
      expect(stringized, newAppUserStringized);
    });

    test('operator overriding', () {
      expect(appUser['supervisor'], appUser.supervisor.value);
      expect(appUser['students'], appUser.students.value);

      appUser['supervisor'] = appUser.supervisor.value;
      appUser['students'] = appUser.students.value;
      expect(appUser['supervisor'], appUser.supervisor.value);
      expect(appUser['students'], appUser.students.value);

      appUser['supervisor'] = appUser.supervisor.value;
      appUser['students'] = appUser.students.value;
      expect(appUser['supervisor'], appUser.supervisor.value);
      expect(appUser['students'], appUser.students.value);
    });
  });
}
