# Error Handling

The Supa Architecture framework provides a comprehensive error handling system designed to capture, categorize, and report errors across the entire application stack. The system ensures robust error management while maintaining application stability and providing meaningful feedback to users.

## Purpose and Scope

The error handling system serves several critical functions:

- **Structured Error Management**: Consistent error representation across the application
- **Global Error Tracking**: Centralized error capture and reporting
- **User Experience**: Graceful error handling with meaningful user feedback
- **Development Support**: Detailed error information for debugging and monitoring
- **Integration**: Seamless integration with external error reporting services

## Error Handling Architecture

The framework implements a layered error handling approach:

```
Application Layer (UI)
       ↓
Business Logic Layer (BLoCs)
       ↓
Repository Layer
       ↓
Data Access Layer (API/Storage)
       ↓
External Services
```

Each layer handles errors appropriate to its scope while allowing critical errors to bubble up to higher layers.

## Core Error Components

### 1. SupaException Hierarchy

The framework defines a structured exception hierarchy for consistent error handling:

```dart
abstract class SupaException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  
  const SupaException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });
  
  @override
  String toString() => 'SupaException: $message';
}
```

### 2. Specific Exception Types

#### Network Exceptions

```dart
class NetworkException extends SupaException {
  final int? statusCode;
  final String? endpoint;
  
  const NetworkException({
    required String message,
    this.statusCode,
    this.endpoint,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

class TimeoutException extends NetworkException {
  const TimeoutException({
    String message = 'Request timed out',
    String? endpoint,
  }) : super(message: message, endpoint: endpoint, code: 'TIMEOUT');
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    String message = 'No internet connection',
  }) : super(message: message, code: 'NO_INTERNET');
}
```

#### Authentication Exceptions

```dart
class AuthenticationException extends SupaException {
  const AuthenticationException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

class TokenExpiredException extends AuthenticationException {
  const TokenExpiredException({
    String message = 'Authentication token has expired',
  }) : super(message: message, code: 'TOKEN_EXPIRED');
}

class UnauthorizedException extends AuthenticationException {
  const UnauthorizedException({
    String message = 'Unauthorized access',
  }) : super(message: message, code: 'UNAUTHORIZED');
}
```

#### Validation Exceptions

```dart
class ValidationException extends SupaException {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationException({
    required String message,
    required this.fieldErrors,
    String? code,
  }) : super(message: message, code: code);
}

class BusinessRuleException extends SupaException {
  const BusinessRuleException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}
```

#### Storage Exceptions

```dart
class StorageException extends SupaException {
  const StorageException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    code: code,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

class StorageQuotaExceededException extends StorageException {
  const StorageQuotaExceededException({
    String message = 'Storage quota exceeded',
  }) : super(message: message, code: 'QUOTA_EXCEEDED');
}
```

## Global Error Handling

### ErrorHandlingBloc

The framework includes a dedicated BLoC for global error management:

```dart
class ErrorHandlingBloc extends Bloc<ErrorHandlingEvent, ErrorHandlingState> {
  final ErrorReportingService _errorReportingService;
  final Logger _logger;
  
  ErrorHandlingBloc({
    required ErrorReportingService errorReportingService,
    required Logger logger,
  }) : _errorReportingService = errorReportingService,
       _logger = logger,
       super(ErrorHandlingInitial()) {
    on<ReportError>(_onReportError);
    on<ClearError>(_onClearError);
    on<HandleGlobalError>(_onHandleGlobalError);
  }
  
  Future<void> _onReportError(
    ReportError event,
    Emitter<ErrorHandlingState> emit,
  ) async {
    emit(ErrorHandlingInProgress());
    
    try {
      // Log error locally
      _logger.error(
        event.error.message,
        error: event.error.originalError,
        stackTrace: event.error.stackTrace,
      );
      
      // Report to external services
      await _errorReportingService.reportError(
        event.error,
        context: event.context,
        userId: event.userId,
      );
      
      emit(ErrorHandlingSuccess());
    } catch (reportingError) {
      emit(ErrorHandlingFailure(
        message: 'Failed to report error: ${reportingError.toString()}',
      ));
    }
  }
}
```

### Error Events

```dart
abstract class ErrorHandlingEvent extends Equatable {
  const ErrorHandlingEvent();
}

class ReportError extends ErrorHandlingEvent {
  final SupaException error;
  final Map<String, dynamic>? context;
  final String? userId;
  
  const ReportError({
    required this.error,
    this.context,
    this.userId,
  });
  
  @override
  List<Object?> get props => [error, context, userId];
}

class ClearError extends ErrorHandlingEvent {
  @override
  List<Object> get props => [];
}

class HandleGlobalError extends ErrorHandlingEvent {
  final dynamic error;
  final StackTrace? stackTrace;
  
  const HandleGlobalError({
    required this.error,
    this.stackTrace,
  });
  
  @override
  List<Object?> get props => [error, stackTrace];
}
```

### Error States

```dart
abstract class ErrorHandlingState extends Equatable {
  const ErrorHandlingState();
}

class ErrorHandlingInitial extends ErrorHandlingState {
  @override
  List<Object> get props => [];
}

class ErrorHandlingInProgress extends ErrorHandlingState {
  @override
  List<Object> get props => [];
}

class ErrorHandlingSuccess extends ErrorHandlingState {
  @override
  List<Object> get props => [];
}

class ErrorHandlingFailure extends ErrorHandlingState {
  final String message;
  
  const ErrorHandlingFailure({required this.message});
  
  @override
  List<Object> get props => [message];
}
```

## Error Reporting Integration

### Sentry Integration

```dart
class SentryErrorReportingService implements ErrorReportingService {
  @override
  Future<void> initialize({required String dsn}) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.environment = Environment.current;
        options.tracesSampleRate = 0.1;
        options.beforeSend = _filterSensitiveData;
      },
    );
  }
  
  @override
  Future<void> reportError(
    SupaException error, {
    Map<String, dynamic>? context,
    String? userId,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: error.stackTrace,
      withScope: (scope) {
        if (userId != null) {
          scope.setUser(SentryUser(id: userId));
        }
        
        if (context != null) {
          scope.setContexts('additional_context', context);
        }
        
        scope.setTag('error_code', error.code ?? 'unknown');
        scope.setLevel(SentryLevel.error);
      },
    );
  }
  
  SentryEvent? _filterSensitiveData(SentryEvent event, {Hint? hint}) {
    // Remove sensitive information from error reports
    final filteredEvent = event.copyWith();
    // ... filtering logic
    return filteredEvent;
  }
}
```

### Firebase Crashlytics Integration

```dart
class FirebaseCrashlyticsService implements ErrorReportingService {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    
    // Enable crashlytics collection
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  
  @override
  Future<void> reportError(
    SupaException error, {
    Map<String, dynamic>? context,
    String? userId,
  }) async {
    if (userId != null) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
    
    if (context != null) {
      for (final entry in context.entries) {
        await FirebaseCrashlytics.instance.setCustomKey(
          entry.key,
          entry.value.toString(),
        );
      }
    }
    
    await FirebaseCrashlytics.instance.recordError(
      error,
      error.stackTrace,
      reason: error.message,
      information: [
        if (error.code != null) 'Error Code: ${error.code}',
      ],
    );
  }
}
```

## Layer-Specific Error Handling

### 1. API Layer Error Handling

```dart
class ApiClient {
  final ErrorHandlingBloc _errorBloc;
  
  Future<HttpResponse<T>> request<T>({
    required String method,
    required String path,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        options: Options(method: method),
      );
      
      return HttpResponse.success(response.data);
    } on DioException catch (e) {
      final supaException = _mapDioException(e);
      _errorBloc.add(ReportError(error: supaException));
      return HttpResponse.error(supaException);
    } catch (e, stackTrace) {
      final supaException = NetworkException(
        message: 'Unexpected network error: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      );
      _errorBloc.add(ReportError(error: supaException));
      return HttpResponse.error(supaException);
    }
  }
  
  SupaException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(endpoint: e.requestOptions.path);
      
      case DioExceptionType.connectionError:
        return NoInternetException();
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return UnauthorizedException();
        } else if (statusCode == 403) {
          return AuthenticationException(
            message: 'Access forbidden',
            code: 'FORBIDDEN',
          );
        }
        return NetworkException(
          message: 'HTTP $statusCode: ${e.message}',
          statusCode: statusCode,
          endpoint: e.requestOptions.path,
        );
      
      default:
        return NetworkException(
          message: e.message ?? 'Unknown network error',
          originalError: e,
          stackTrace: e.stackTrace,
        );
    }
  }
}
```

### 2. Repository Layer Error Handling

```dart
abstract class BaseRepository {
  final ErrorHandlingBloc _errorBloc;
  
  Future<Result<T>> safeCall<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      final result = await operation();
      return Result.success(result);
    } on SupaException catch (e) {
      _errorBloc.add(ReportError(
        error: e,
        context: {
          'operation': operationName ?? 'unknown',
          'repository': runtimeType.toString(),
        },
      ));
      return Result.error(e);
    } catch (e, stackTrace) {
      final supaException = SupaException(
        message: 'Repository operation failed: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      );
      _errorBloc.add(ReportError(error: supaException));
      return Result.error(supaException);
    }
  }
}

class UserRepository extends BaseRepository {
  Future<Result<User>> getUser(String userId) async {
    return safeCall(
      () async {
        final response = await _apiClient.get('/users/$userId');
        return User.fromJson(response.data);
      },
      operationName: 'getUser',
    );
  }
}
```

### 3. BLoC Layer Error Handling

```dart
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  final ErrorHandlingBloc _errorBloc;
  
  Future<void> handleError(
    SupaException error, {
    Map<String, dynamic>? context,
  }) async {
    _errorBloc.add(ReportError(
      error: error,
      context: {
        'bloc': runtimeType.toString(),
        ...?context,
      },
    ));
  }
  
  Future<void> safeEmit<T>(
    Emitter<State> emit,
    Future<State> Function() stateBuilder, {
    State Function(SupaException error)? errorStateBuilder,
  }) async {
    try {
      final newState = await stateBuilder();
      emit(newState);
    } on SupaException catch (e) {
      await handleError(e);
      if (errorStateBuilder != null) {
        emit(errorStateBuilder(e));
      }
    } catch (e, stackTrace) {
      final supaException = SupaException(
        message: 'BLoC operation failed: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      );
      await handleError(supaException);
      if (errorStateBuilder != null) {
        emit(errorStateBuilder(supaException));
      }
    }
  }
}
```

## UI Error Handling

### Error Display Components

```dart
class ErrorMessage extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  
  const ErrorMessage({
    Key? key,
    required this.message,
    this.actionLabel,
    this.onAction,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
```

### Global Error Handler

```dart
class GlobalErrorHandler extends StatelessWidget {
  final Widget child;
  
  const GlobalErrorHandler({Key? key, required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorHandlingBloc, ErrorHandlingState>(
      listener: (context, state) {
        if (state is ErrorHandlingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: ${state.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      child: child,
    );
  }
}
```

## Error Categories and Handling Strategies

### 1. User-Recoverable Errors

Errors that users can potentially resolve:

```dart
class RecoverableErrorHandler {
  static void handle(SupaException error, BuildContext context) {
    switch (error.runtimeType) {
      case NoInternetException:
        _showNetworkError(context);
        break;
      case ValidationException:
        _showValidationError(context, error as ValidationException);
        break;
      case UnauthorizedException:
        _redirectToLogin(context);
        break;
      default:
        _showGenericError(context, error);
    }
  }
  
  static void _showNetworkError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connection Problem'),
        content: Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

### 2. System-Level Errors

Errors that require system-level handling:

```dart
class SystemErrorHandler {
  static Future<void> handle(SupaException error) async {
    switch (error.runtimeType) {
      case StorageQuotaExceededException:
        await _cleanupStorage();
        break;
      case TokenExpiredException:
        await _refreshAuthentication();
        break;
      default:
        await _reportToMonitoring(error);
    }
  }
}
```

## Best Practices

### 1. Error Context

Always provide meaningful context when reporting errors:

```dart
void reportErrorWithContext(SupaException error) {
  final context = {
    'user_id': currentUser?.id,
    'screen': currentRoute,
    'timestamp': DateTime.now().toIso8601String(),
    'app_version': PackageInfo.fromPlatform().version,
    'platform': Platform.operatingSystem,
  };
  
  errorBloc.add(ReportError(error: error, context: context));
}
```

### 2. Error Message Localization

```dart
class ErrorMessages {
  static String getMessage(String errorCode, Locale locale) {
    final messages = _getMessages(locale);
    return messages[errorCode] ?? _getDefaultMessage(errorCode);
  }
  
  static Map<String, String> _getMessages(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return _englishMessages;
      case 'vi':
        return _vietnameseMessages;
      default:
        return _englishMessages;
    }
  }
}
```

### 3. Error Recovery

```dart
class ErrorRecoveryService {
  static Future<bool> attemptRecovery(SupaException error) async {
    switch (error.code) {
      case 'TOKEN_EXPIRED':
        return await _refreshToken();
      case 'NO_INTERNET':
        return await _waitForConnection();
      case 'QUOTA_EXCEEDED':
        return await _clearCache();
      default:
        return false;
    }
  }
}
```

---

*Documentation generated from [DeepWiki](https://deepwiki.com/supavn/supa_architecture)*