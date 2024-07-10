part of 'tenant_bloc.dart';

sealed class TenantState extends Equatable {
  const TenantState();

  @override
  List<Object> get props => [];
}

final class TenantInitial extends TenantState {}

final class TenantLoading extends TenantState {}

final class TenantLoaded extends TenantState {
  final List<Tenant> tenants;

  const TenantLoaded(this.tenants);
}
