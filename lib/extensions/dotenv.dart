import 'package:flutter_dotenv/flutter_dotenv.dart';

extension SupaDotEnv on DotEnv {
  String get baseApiUrl => env['BASE_API_URL']!;

  String get sentryDsn => env['SENTRY_DSN']!;
}
