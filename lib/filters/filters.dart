import 'dart:convert';

import 'package:supa_architecture/json/json.dart';

part 'abstract_id_filter.dart';
part 'abstract_number_filter.dart';
part 'date_filter.dart';
part 'double_filter.dart';
part 'filter_field.dart';
part 'guid_filter.dart';
part 'id_filter.dart';
part 'int_filter.dart';
part 'number_filter.dart';
part 'string_filter.dart';

abstract class DataFilter implements JsonSerializable {
  static const orderAsc = "ASC";

  static const orderDesc = "DESC";

  static const viewCodeAll = "ALL";

  static const viewCodePending = "PENDING";

  static const viewCodeApproved = "APPROVED";

  /// Number of entities to skip
  int skip = 0;

  /// Number of entities to take in a request
  int take = 20;

  /// Field name to order by
  String? orderBy;

  /// Order orientation
  String? orderType;

  /// Search field
  String? search;

  /// Document view code
  String? viewCode;

  List<FilterField> get fields;

  @override
  toJSON() {
    final Map<String, dynamic> json = {};
    json["skip"] = skip;
    json["take"] = take;
    if (orderBy != null) {
      json["orderBy"] = orderBy;
    }
    if (orderType != null) {
      json["orderType"] = orderType;
    }
    if (search != null) {
      json["search"] = search;
    }
    if (viewCode != null) {
      json["viewCode"] = viewCode;
    }
    for (final field in fields) {
      json[field.name] = field.toJSON();
    }
    return json;
  }

  @override
  void fromJSON(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json.containsKey("skip") && json["skip"] is int?) {
        skip = json["skip"];
      }
      if (json.containsKey("take") && json["take"] is int?) {
        take = json["take"];
      }
      if (json.containsKey("orderBy") && json["orderBy"] is String?) {
        take = json["orderBy"];
      }
      if (json.containsKey("orderType") && json["orderType"] is String?) {
        take = json["orderType"];
      }
      if (json.containsKey("search") && json["search"] is String?) {
        search = json["search"];
      }
      if (json.containsKey("viewCode") && json["viewCode"] is String?) {
        viewCode = json["viewCode"];
      }

      for (final field in fields) {
        if (json.containsKey(field.name) && json[field.name] != null) {
          field.fromJSON(json[field.name]);
        }
      }
    }
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
  }

  int nextPage() {
    return skip + take;
  }
}
