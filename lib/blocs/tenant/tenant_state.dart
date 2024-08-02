part of 'tenant_bloc.dart';

/// Represents the initial state of the tenant management.
final class TenantInitial extends TenantState {}

/// Represents the state when tenants have been loaded.
final class TenantLoaded extends TenantState {
  final List<Tenant> tenants;

  /// Constructs an instance of [TenantLoaded].
  ///
  /// **Parameters:**
  /// - `tenants`: The list of loaded tenants.
  const TenantLoaded(this.tenants);

  @override
  List<Object> get props => [tenants];
}

/// Represents the state when tenant data is being loaded.
final class TenantLoading extends TenantState {}

/// An abstract class representing the states of tenant management.
sealed class TenantState extends Equatable {
  const TenantState();

  @override
  List<Object> get props => [];
}
