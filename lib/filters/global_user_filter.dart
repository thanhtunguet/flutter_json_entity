part of "filters.dart";

class GlobalUserFilter extends DataFilter {
  @override
  List<FilterField> get fields => [
        id,
        userId,
        globalUserTypeId,
        businessPartnerId,
        username,
        displayName,
        email,
        phone,
        statusId,
        tenantId,
      ];

  final id = IdFilter('id');
  final userId = IdFilter('userId');
  final globalUserTypeId = IdFilter('globalUserTypeId');
  final businessPartnerId = IdFilter('businessPartnerId');
  final username = StringFilter('username');
  final displayName = StringFilter('displayName');
  final email = StringFilter('email');
  final phone = StringFilter('phone');

  final statusId = IdFilter('statusId');

  final tenantId = IdFilter('tenantId');
}
