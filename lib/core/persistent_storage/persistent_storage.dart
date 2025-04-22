import 'package:supa_architecture/models/models.dart';

abstract class PersistentStorage {
  /// Initializes the storage backend.
  Future<void> initialize();

  /// Save a key-value pair
  void setValue(String key, String value);

  /// Retrieve a value by key
  String? getValue(String key);

  /// Remove a value by key
  void removeValue(String key);

  /// Clear all stored key-value pairs
  void clear();

  /// The base API URL
  String get baseApiUrl;

  set baseApiUrl(String baseApiUrl);

  CurrentTenant? get tenant;

  set tenant(CurrentTenant? tenant);

  void removeTenant();

  AppUser? get appUser;

  set appUser(AppUser? appUser);

  void removeAppUser();
}
