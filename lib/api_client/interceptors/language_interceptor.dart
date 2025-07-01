import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supa_architecture/blocs/blocs.dart';

/// An interceptor that adds the language to the request headers.
///
/// This interceptor is used to provide the language to the request headers,
/// helping the backend identify the language of the request.
class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if the authentication bloc is registered.
    if (GetIt.instance.isRegistered<AuthenticationBloc>()) {
      // Get the authentication bloc.
      final authenticationBloc = GetIt.instance.get<AuthenticationBloc>();

      // Check if the user is authenticated.
      if (authenticationBloc.state.isAuthenticated) {
        // Get the language from the user.
        final language = (authenticationBloc.state
                as UserAuthenticatedWithSelectedTenantState)
            .user
            .language
            .value
            .code
            .value;
        if (language.isNotEmpty) {
          options.headers['X-Language'] = language;
        }
      }
    }
    handler.next(options);
  }
}
