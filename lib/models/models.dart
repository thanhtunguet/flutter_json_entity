import 'package:get_it/get_it.dart';
import 'package:supa_architecture/models/app_user.dart';
import 'package:supa_architecture/models/enum_model.dart';
import 'package:supa_architecture/models/file.dart';
import 'package:supa_architecture/models/forgot_password_dto.dart';
import 'package:supa_architecture/models/image.dart';
import 'package:supa_architecture/models/tenant.dart';
import 'package:supa_architecture/models/user_notification.dart';

export 'app_user.dart';
export 'app_user_filter.dart';
export 'attachment.dart';
export 'enum_model.dart';
export 'file.dart';
export 'file_filter.dart';
export 'forgot_password_dto.dart';
export 'image.dart';
export 'tenant.dart';
export 'tenant_filter.dart';
export 'user_notification.dart';
export 'user_notification_filter.dart';

void registerModels() {
  GetIt.instance.registerFactory<AppUser>(() => AppUser());
  GetIt.instance.registerFactory<EnumModel>(() => EnumModel());
  GetIt.instance.registerFactory<File>(() => File());
  GetIt.instance.registerFactory<ForgotPasswordDto>(() => ForgotPasswordDto());
  GetIt.instance.registerFactory<Image>(() => Image());
  GetIt.instance.registerFactory<Tenant>(() => Tenant());
  GetIt.instance.registerFactory<UserNotification>(() => UserNotification());
}
