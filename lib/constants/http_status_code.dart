part of "constants.dart";

/// A class containing constants for HTTP status codes.
abstract class HttpStatusCode {
  // 2xx Success
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // 3xx Redirection
  static const int movedPermanently = 301;
  static const int found = 302;
  static const int seeOther = 303;
  static const int notModified = 304;
  static const int temporaryRedirect = 307;
  static const int permanentRedirect = 308;

  // 4xx Client Errors
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int paymentRequired = 402;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int notAcceptable = 406;
  static const int requestTimeout = 408;
  static const int conflict = 409;
  static const int gone = 410;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  // 5xx Server Errors
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}
