part of "api_client.dart";

/// Extension methods for parsing HTTP responses from the [Dio] package.
///
/// This extension provides methods for converting response data into various
/// data types, including custom JSON models, lists, primitives, and `DateTime`.
extension HttpResponse on Response {
  /// Converts the response data to a [JsonModel] instance.
  ///
  /// **Type Parameter:**
  /// - `T`: The type of the [JsonModel].
  ///
  /// **Returns:**
  /// - A [T] instance populated with the response data.
  T body<T extends JsonModel>() {
    final T model = GetIt.instance.get<T>();
    model.fromJson(data);
    return model;
  }

  /// Converts the response data to a list of [JsonModel] instances.
  ///
  /// **Type Parameter:**
  /// - `T`: The type of each item in the list, extending [JsonModel].
  ///
  /// **Returns:**
  /// - A list of [T] instances populated with the response data.
  List<T> bodyAsList<T extends JsonModel>() {
    if (data is! List) {
      throw const FormatException("Response data is not a list.");
    }
    return (data as List).map((element) {
      final T model = GetIt.instance.get<T>();
      model.fromJson(element);
      return model;
    }).toList();
  }

  /// Converts the response data to an integer.
  ///
  /// **Returns:**
  /// - An integer value parsed from the response data.
  int bodyAsInteger() {
    if (data is String) {
      return int.tryParse(data) ??
          (throw FormatException("Invalid integer: $data"));
    }
    if (data is num) {
      return data.toInt();
    }
    throw FormatException("Cannot convert ${data.runtimeType} to int.");
  }

  /// Converts the response data to a double.
  ///
  /// **Returns:**
  /// - A double value parsed from the response data.
  double bodyAsDouble() {
    if (data is num) {
      return data.toDouble();
    }
    if (data is String) {
      return double.tryParse(data) ??
          (throw FormatException("Invalid double: $data"));
    }
    throw FormatException("Cannot convert ${data.runtimeType} to double.");
  }

  /// Converts the response data to a number.
  ///
  /// **Returns:**
  /// - A number parsed from the response data.
  num bodyAsNumber() {
    if (data is num) {
      return data;
    }
    if (data is String) {
      return num.tryParse(data) ??
          (throw FormatException("Invalid number: $data"));
    }
    throw FormatException("Cannot convert ${data.runtimeType} to num.");
  }

  /// Converts the response data to a string.
  ///
  /// **Returns:**
  /// - The response data as a string.
  String bodyAsString() {
    return data?.toString() ?? "";
  }

  /// Converts the response data to a boolean.
  ///
  /// **Returns:**
  /// - A boolean value parsed from the response data.
  bool bodyAsBoolean() {
    if (data is bool) {
      return data;
    }
    if (data is String) {
      final lowerData = data.toLowerCase();
      if (lowerData == "true" || lowerData == "1") {
        return true;
      }
      if (lowerData == "false" || lowerData == "0") {
        return false;
      }
    }
    throw FormatException("Invalid boolean: $data");
  }

  /// Converts the response data to a [DateTime].
  ///
  /// **Returns:**
  /// - A [DateTime] object parsed from the response data.
  DateTime bodyAsDateTime() {
    if (data is String) {
      return DateTime.tryParse(data) ??
          (throw FormatException("Invalid DateTime: $data"));
    }
    throw FormatException("Cannot convert ${data.runtimeType} to DateTime.");
  }
}
