part of 'tenant_bloc.dart';

/// Abstract class representing tenant-related events.
sealed class TenantEvent extends Equatable {
  const TenantEvent();

  @override
  List<Object> get props => [];
}

/// Event to initialize the tenant state.
final class TenantInitialEvent extends TenantEvent {}

/// Event to trigger tenant loading state.
final class TenantLoadingEvent extends TenantEvent {}

/// Event to indicate that tenants have been loaded.
final class TenantLoadedEvent extends TenantEvent {
  final List<Tenant> tenants;

  /// Constructs an instance of [TenantLoadedEvent].
  ///
  /// **Parameters:**
  /// - `tenants`: The list of loaded tenants.
  const TenantLoadedEvent(this.tenants);

  @override
  List<Object> get props => [tenants];
}
