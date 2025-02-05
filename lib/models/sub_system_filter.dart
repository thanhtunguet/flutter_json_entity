import 'package:supa_architecture/filters/filters.dart';

class SubSystemFilter extends DataFilter {
  @override
  List<FilterField> get fields => [
        id,
        code,
        name,
      ];

  final id = IdFilter("id");

  final code = StringFilter("code");

  final name = StringFilter("name");
}
