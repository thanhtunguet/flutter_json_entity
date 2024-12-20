import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";
import "package:flutter/material.dart";
import "package:supa_architecture/models/tenant.dart";
import "package:supa_architecture/repositories/portal_authentication_repository.dart";

part "tenant_event.dart";
part "tenant_state.dart";

/// A BLoC (Business Logic Component) class for managing tenant state.
///
/// This class handles the initialization, loading, and updating of tenants
/// using events and states. It communicates with the [PortalAuthenticationRepository]
/// to fetch tenant data.
class TenantBloc extends Bloc<TenantEvent, TenantState> {
  /// A repository that handles authentication operations.
  final PortalAuthenticationRepository portalRepo;

  /// Constructs an instance of [TenantBloc] with a dependency-injected repository.
  ///
  /// This allows better testability by injecting a mock or different repository in tests.
  TenantBloc({PortalAuthenticationRepository? portalRepo})
      : portalRepo = portalRepo ?? PortalAuthenticationRepository(),
        super(TenantInitial()) {
    on<TenantInitialEvent>(_onTenantInitial);
    on<TenantLoadingEvent>(_onTenantLoading);
    on<TenantLoadedEvent>(_onTenantLoaded);
  }

  /// Handles the initialization of the tenant state.
  void handleInitialize() {
    add(TenantInitialEvent());
  }

  /// Handles the update of tenant data.
  ///
  /// Fetches the list of tenants from the repository and triggers
  /// [TenantLoadedEvent] with the fetched tenants. If an error occurs,
  /// it logs the error and optionally handles it.
  Future<void> handleUpdateTenant() async {
    try {
      final tenants = await portalRepo.listTenant();
      add(TenantLoadedEvent(tenants));
    } catch (error) {
      if (error is Exception) {
        // Log the error or handle it as needed.
        debugPrint("Error fetching tenants: $error");
        rethrow;
      }
    }
  }

  /// Event handler for initializing tenant state.
  Future<void> _onTenantInitial(
      TenantInitialEvent event, Emitter<TenantState> emit) async {
    add(TenantLoadingEvent());
    await handleUpdateTenant();
  }

  /// Event handler for loaded tenant data.
  Future<void> _onTenantLoaded(
      TenantLoadedEvent event, Emitter<TenantState> emit) async {
    emit(TenantLoaded(event.tenants));
  }

  /// Event handler for loading state.
  Future<void> _onTenantLoading(
      TenantLoadingEvent event, Emitter<TenantState> emit) async {
    emit(TenantLoading());
  }
}
