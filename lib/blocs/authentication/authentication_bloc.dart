import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationInitialEvent>(_onInitial);
    on<AuthenticationWithPasswordEvent>(_onPassword);
    on<AuthenticationWithGoogleEvent>(_onGoogleLogin);
    on<AuthenticationWithAppleEvent>(_onAppleLogin);
    on<AuthenticationWithMicrosoftEvent>(_onMicrosoftLogin);
    on<AuthenticationWithBiometricEvent>(_onBiometricLogin);
    on<AuthenticationLogoutEvent>(_onLogout);
  }

  Future<void> _onInitial(
    AuthenticationInitialEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  _onPassword(
    AuthenticationWithPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  _onGoogleLogin(
    AuthenticationWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  _onAppleLogin(
    AuthenticationWithAppleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  _onMicrosoftLogin(
    AuthenticationWithMicrosoftEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  _onBiometricLogin(
    AuthenticationWithBiometricEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
  }

  _onLogout(
    AuthenticationLogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationInitial());
  }
}
