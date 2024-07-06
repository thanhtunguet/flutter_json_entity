part of 'filters.dart';

/// This class defines filter operations for ID (primary key, foreign key) fields
/// that is in int type
class AbstractIdFilter<T> extends FilterField {
  /// Query all records that has id is in this list
  List<T>? inList;

  /// Query all records that has id is not in this list
  List<T>? notInList;

  /// Query all records that has a specific id
  T? equal;

  /// Query all records that have id is different from this value
  T? notEqual;

  /// Initialize new IdFilter instance
  AbstractIdFilter(super.fieldName);

  @override
  void fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return;
    }
    if (json.containsKey(FilterField.inList)) {
      inList = json[FilterField.inList];
    }
    if (json.containsKey(FilterField.notInList)) {
      notInList = json[FilterField.notInList];
    }
    if (json.containsKey(FilterField.equal)) {
      equal = json[FilterField.equal];
    }
    if (json.containsKey(FilterField.notEqual)) {
      notEqual = json[FilterField.notEqual];
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {};
    if (equal != null) {
      json[FilterField.equal] = equal;
    }
    if (notEqual != null) {
      json[FilterField.notEqual] = notEqual;
    }
    if (inList != null) {
      json[FilterField.inList] = inList;
    }
    if (notInList != null) {
      json[FilterField.notInList] = notInList;
    }
    return json;
  }
}
