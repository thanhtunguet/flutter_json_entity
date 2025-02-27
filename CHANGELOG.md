# Changelog

## v1.5.2

### Fixed
- Empty state default image
- Notification duplication


## v1.5.1

### Added

- imageUrl for empty state

## v1.5.0

### Added

- AppUserInfo class

## v1.4.4

### Fixed

- GoBackButton

## v1.4.3

### Added

- Entities

## v1.4.2

### Added

- EntityDetailNavigator

## v1.4.1

### Added 

- Entity generation documentation

## v1.4.0

### Added

- NotificationHandler
- createdAt property for UserNotification model

## v1.3.1

### Added

- `showPadding` for section title

## v1.3.0

### Added 

- Common widgets, shared across projects

## v1.2.0

- Add optimization
- Add tenant subsystem mappings

### Fixed

- Timezone: Ignore "+" sign in timezone header

### Added

- TextStatusBadge widget
- EnumStatusBadge widget
- DateTime extensions

## 1.0.0

### Breaking changes

- PersistentStorage
- CookieManager
- SecureStorage
- SupaArchitecturePlatform

## 0.0.3+preview.8

### Added

- `Attachment`: add `setFile` and `setLink` methods

## 0.0.3+preview.7

### Added

- `ApiClient`: add `filename` parameter to `uploadFiles` method

## 0.0.3+preview.6

### Added

- `ApiClient`: add `uploadFilesFromImagePicker` and `uploadFilesFromFilePicker` methods
- Check is web for where using cookie manager

## 0.0.3+preview.5

### Fixed

- `ApiClient`: fixed `uploadFilesFromImagePicker` and `uploadFilesFromFilePicker` methods for web

## 0.0.3+preview.4

### Added

- `ApiClient`: add `uploadFilesFromImagePicker` and `uploadFilesFromFilePicker` methods

## 0.0.3+preview.3

### Added

- `ApiClient`: add `uploadFileFromImagePicker` and `uploadFileFromFilePicker` methods

## 0.0.3+preview.2

### Added

- `AuthenticationRepository`: add `getProfileInfo` method

### Deprecated

- `AuthenticationRepository`: `getProfile` method

## 0.0.3+preview.1

### Added

- `AuthenticationBloc`: add switch email and notification

## 0.0.2:

### Added

- `AuthenticationBloc`: add Microsoft login scope
- Optimize authentication flow

## 0.0.2+preview.15

### Added

- `AuthenticationBloc`: add Google login scope

## 0.0.2+preview.14

### Added

- `DeviceInfoInterceptor`: add device UUID to request headers

## 0.0.2+preview.13

### Added

- Compatibility table in README
- toJson for PushNotificationState and PushNotificationPayload

## 0.0.2+preview.12

### Added

- `JsonField`: equality operator

## 0.0.2+preview.11

### Added

- Add options to use Firebase or not

## 0.0.2+preview.7

### Added

- `LoginForm`: a form for user login
- `CarbonButtons`: a widget for handling buttons with safe area inset
### Fixed

- `PushNotificationBloc`: a bloc for handling push notifications
- Remove `showLocalNotifications` from `PushNotificationBloc`

## 0.0.2+preview.6

### Added

- `UserNotificationFilter`: unread field

## 0.0.2+preview.5

### Fixed

- `read` -> `unread`

## 0.0.2+preview.4

### Added

- Handle PushNotificationPayload

## 0.0.2+preview.3

### Added

- showLocalNotification: show local notification when receive a push notification

## 0.0.2+preview.2

### Added

- BLoC: PushNotification
- BLoC: ErrorHandling

## 0.0.1+preview.12

### Added

- Model: Attachment

## 0.0.1+preview.5

### Added

- Package example

### Fixed

- Reformat the code

## 0.0.1+preview.4

### Fixed

- Google disconnect

## 0.0.1+preview.3

### Added

- Finish documentation
- Fix: response body file

## 0.0.1+preview.2

### Added

- Documentation for files

## 0.0.1+preview.1

### Added

- All functions
- Documentation preview