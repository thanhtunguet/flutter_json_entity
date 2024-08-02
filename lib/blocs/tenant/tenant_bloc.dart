import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/repositories/portal_authentication_repository.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

/// A BLoC (Business Logic Component) class for managing tenant state.
///
/// This class handles the initialization, loading, and updating of tenants
/// using events and states. It communicates with the [PortalAuthenticationRepository]
/// to fetch tenant data.
class TenantBloc extends Bloc<TenantEvent, TenantState> {
  static final portalRepo = PortalAuthenticationRepository();

  /// Constructs an instance of [TenantBloc].
  TenantBloc() : super(TenantInitial()) {
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
  /// it catches the error.
  Future<void> handleUpdateTenant() async {
    await portalRepo.listTenant().then((tenants) {
      add(TenantLoadedEvent(tenants));
    }).catchError((error) {
      if (error is Exception) {
        // Handle exception
      }
    });
  }

  Future<void> _onTenantInitial(
      TenantInitialEvent event, Emitter<TenantState> emit) async {
    add(TenantLoadingEvent());
    await handleUpdateTenant();
  }

  Future<void> _onTenantLoaded(
      TenantLoadedEvent event, Emitter<TenantState> emit) async {
    emit(TenantLoaded(event.tenants));
  }

  Future<void> _onTenantLoading(
      TenantLoadingEvent event, Emitter<TenantState> emit) async {
    emit(TenantLoading());
  }
}
