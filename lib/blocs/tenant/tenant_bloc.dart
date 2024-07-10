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

  Future<void> _onTenantInitial(
      TenantInitialEvent event, Emitter<TenantState> emit) async {
    add(TenantLoadingEvent());
    await portalRepo.listTenant().then((tenants) {
      add(TenantLoadedEvent(tenants));
    }).catchError((error) {
      /// TODO: handle tenants error
    });
  }

  Future<void> _onTenantLoading(
      TenantLoadingEvent event, Emitter<TenantState> emit) async {
    emit(TenantLoading());
  }

  Future<void> _onTenantLoaded(
      TenantLoadedEvent event, Emitter<TenantState> emit) async {
    emit(TenantLoaded(event.tenants));
  }

  initialize() {
    add(TenantInitialEvent());
  }
}
