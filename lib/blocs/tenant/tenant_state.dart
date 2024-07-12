part of 'tenant_bloc.dart';

final class TenantInitial extends TenantState {}

final class TenantLoaded extends TenantState {
  final List<Tenant> tenants;

  const TenantLoaded(this.tenants);
}

final class TenantLoading extends TenantState {}

sealed class TenantState extends Equatable {
  const TenantState();

  @override
  List<Object> get props => [];
}
