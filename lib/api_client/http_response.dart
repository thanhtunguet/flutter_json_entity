part of "api_client.dart";

/// Extension methods for handling HTTP responses from the [Dio] package.
///
/// Provides convenience methods for parsing the response data into various
/// data types, including JSON models, integers, doubles, numbers, strings,
/// booleans, and date-times.
extension HttpResponse on Response {
  /// Converts the response data to a [JsonModel] object.
  ///
  /// **Type Parameter:**
  /// - `T`: The type of [JsonModel] to convert the data into.
  ///
  /// **Returns:**
  /// - The [JsonModel] instance populated with the response data.
  T body<T extends JsonModel>() {
    final T model = GetIt.instance.get<T>();
    model.fromJSON(data);
    return model;
  }

  /// Converts the response data to a list of [JsonModel] objects.
  ///
  /// **Type Parameter:**
  /// - `T`: The type of [JsonModel] to convert each item in the list into.
  ///
  /// **Returns:**
  /// - A list of [JsonModel] instances populated with the response data.
  List<T> bodyAsList<T extends JsonModel>() {
    return (data as List).map((element) {
      final T model = GetIt.instance.get<T>();
      model.fromJSON(element);
      return model;
    }).toList();
  }

  /// Converts the response data to an integer.
  ///
  /// **Returns:**
  /// - The response data as an integer.
  int bodyAsInteger() {
    if (data is String) {
      return int.parse(data);
    }
    if (data is num) {
      return data.toInt();
    }
    return data;
  }

  /// Converts the response data to a double.
  ///
  /// **Returns:**
  /// - The response data as a double.
  double bodyAsDouble() {
    return (data as num).toDouble();
  }

  /// Converts the response data to a number.
  ///
  /// **Returns:**
  /// - The response data as a number.
  num bodyAsNumber() {
    return num.parse(data);
  }

  /// Converts the response data to a string.
  ///
  /// **Returns:**
  /// - The response data as a string.
  String bodyAsString() {
    return data.toString();
  }

  /// Converts the response data to a boolean.
  ///
  /// **Returns:**
  /// - The response data as a boolean.
  bool bodyAsBoolean() {
    return bool.parse(data);
  }

  /// Converts the response data to a [DateTime] object.
  ///
  /// **Returns:**
  /// - The response data as a [DateTime] object.
  DateTime bodyAsDateTime() {
    return DateTime.parse(data);
  }
}
