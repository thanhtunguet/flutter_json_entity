import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supa_architecture/core/cookie_manager/basic_cookie_manager.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';

void main() {
  group('BasicCookieManager', () {
    late CookieManager cookieManager;
    late Uri testUri;

    setUp(() {
      cookieManager = BasicCookieManager();
      testUri = Uri.parse('https://example.com');
    });

    test('should save and load cookies correctly', () {
      final cookies = [
        Cookie('sessionId', 'abc123'),
        Cookie('userId', 'user456'),
      ];

      // Save cookies
      cookieManager.saveCookies(testUri, cookies);

      // Load cookies
      final loadedCookies = cookieManager.loadCookies(testUri);

      expect(loadedCookies.length, equals(2));
      expect(loadedCookies[0].name, equals('sessionId'));
      expect(loadedCookies[0].value, equals('abc123'));
      expect(loadedCookies[1].name, equals('userId'));
      expect(loadedCookies[1].value, equals('user456'));
    });

    test('should get single cookie correctly', () {
      final cookies = [
        Cookie('sessionId', 'abc123'),
        Cookie('userId', 'user456'),
      ];

      cookieManager.saveCookies(testUri, cookies);

      final sessionCookie = cookieManager.getSingleCookie(testUri, 'sessionId');
      expect(sessionCookie.name, equals('sessionId'));
      expect(sessionCookie.value, equals('abc123'));
    });

    test('should throw exception when cookie not found', () {
      expect(
        () => cookieManager.getSingleCookie(testUri, 'nonexistent'),
        throwsException,
      );
    });

    test('should delete cookies correctly', () {
      final cookies = [
        Cookie('sessionId', 'abc123'),
        Cookie('userId', 'user456'),
      ];

      cookieManager.saveCookies(testUri, cookies);
      expect(cookieManager.loadCookies(testUri).length, equals(2));

      cookieManager.deleteCookies(testUri);
      expect(cookieManager.loadCookies(testUri).length, equals(0));
    });

    test('should delete all cookies correctly', () {
      final uri1 = Uri.parse('https://example1.com');
      final uri2 = Uri.parse('https://example2.com');

      cookieManager.saveCookies(uri1, [Cookie('cookie1', 'value1')]);
      cookieManager.saveCookies(uri2, [Cookie('cookie2', 'value2')]);

      expect(cookieManager.loadCookies(uri1).length, equals(1));
      expect(cookieManager.loadCookies(uri2).length, equals(1));

      cookieManager.deleteAllCookies();

      expect(cookieManager.loadCookies(uri1).length, equals(0));
      expect(cookieManager.loadCookies(uri2).length, equals(0));
    });

    test('should provide interceptor', () {
      final interceptor = cookieManager.interceptor;
      expect(interceptor, isNotNull);
    });
  });
}
