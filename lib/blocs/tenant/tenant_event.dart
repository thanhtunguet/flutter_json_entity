part of 'tenant_bloc.dart';

sealed class TenantEvent extends Equatable {
  const TenantEvent();

  @override
  List<Object> get props => [];
}

final class TenantInitialEvent extends TenantEvent {}

final class TenantLoadingEvent extends TenantEvent {}

final class TenantLoadedEvent extends TenantEvent {
  final List<Tenant> tenants;

  const TenantLoadedEvent(this.tenants);
}
