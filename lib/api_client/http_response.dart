part of 'api_client.dart';

extension HttpResponse on Response {
  T body<T extends JsonModel>() {
    final T model = JsonModel.construct(T) as T;
    model.fromJSON(data);
    return model;
  }

  List<T> bodyAsList<T extends JsonModel>() {
    return (data as List).map((element) {
      final T model = JsonModel.construct(T) as T;
      model.fromJSON(element);
      return model;
    }).toList();
  }

  int bodyAsInteger() {
    if (data is String) {
      return int.parse(data);
    }
    if (data is num) {
      return data.toInt();
    }
    return data;
  }

  double bodyAsDouble() {
    return (data as num).toDouble();
  }

  String bodyAsString() {
    return data.toString();
  }

  bool bodyAsBoolean() {
    return bool.parse(data);
  }

  DateTime bodyAsDateTime() {
    return DateTime.parse(data);
  }
}
