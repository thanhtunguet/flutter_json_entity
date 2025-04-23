part of "filters.dart";

mixin DateFilterMixin {
  DateFilter date = DateFilter('date');

  IdFilter dateTypeId = IdFilter('dateTypeId');

  DateType dateTypeValue = DateType();

  List<FilterField> get dateFilterMixinFields => [
        date,
        dateTypeId,
      ];
}
