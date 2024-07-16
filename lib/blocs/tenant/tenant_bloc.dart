import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/repositories/portal_authentication_repository.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  static final portalRepo = PortalAuthenticationRepository();

  TenantBloc() : super(TenantInitial()) {
    on<TenantInitialEvent>(_onTenantInitial);
    on<TenantLoadingEvent>(_onTenantLoading);
    on<TenantLoadedEvent>(_onTenantLoaded);
  }

  handleInitialize() {
    add(TenantInitialEvent());
  }

  Future<void> handleUpdateTenant() async {
    await portalRepo.listTenant().then((tenants) {
      add(TenantLoadedEvent(tenants));
    }).catchError((error) {
      if (error is Exception) {
        ///
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
