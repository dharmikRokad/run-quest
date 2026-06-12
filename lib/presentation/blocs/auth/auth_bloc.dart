import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authStateSubscription;

  AuthBloc({required this._authRepository})
      : super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthEmailVerificationCheckRequested>(_onAuthEmailVerificationCheckRequested);
    on<AuthSendVerificationEmailRequested>(_onAuthSendVerificationEmailRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);

    // Reactive listener to auth changes in background
    _authStateSubscription = _authRepository.authStateChanges.listen((userProfile) {
      add(AuthStatusChanged(userProfile));
    });
  }

  void _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user == null) {
      if (state.status != AuthBlocStatus.unauthenticated) {
        emit(state.copyWith(
          status: AuthBlocStatus.unauthenticated,
          user: null,
          errorMessage: null,
          successMessage: null,
        ));
      }
    } else {
      emit(state.copyWith(
        status: AuthBlocStatus.authenticated,
        user: event.user,
      ));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthBlocStatus.loading));
    try {
      final user = await _authRepository.getCurrentUser;
      if (user == null) {
        emit(state.copyWith(status: AuthBlocStatus.unauthenticated, user: null));
        return;
      }

      emit(state.copyWith(status: AuthBlocStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthBlocStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthBlocStatus.loading));
    try {
      final user = await _authRepository.loginWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(state.copyWith(status: AuthBlocStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthBlocStatus.error,
        errorMessage: _cleanErrorMessage(e.toString()),
      ));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthBlocStatus.loading));
    try {
      final user = await _authRepository.registerWithEmailAndPassword(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      emit(state.copyWith(status: AuthBlocStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthBlocStatus.error,
        errorMessage: _cleanErrorMessage(e.toString()),
      ));
    }
  }

  Future<void> _onAuthEmailVerificationCheckRequested(
    AuthEmailVerificationCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = state.user;
    if (user != null && state.status == AuthBlocStatus.authenticated) {
      try {
        final verified = await _authRepository.isEmailVerified();
        if (verified) {
          final updatedUser = await _authRepository.getCurrentUser;
          if (updatedUser != null) {
            emit(state.copyWith(
              status: AuthBlocStatus.authenticated,
              user: updatedUser.copyWith(isEmailVerified: true),
            ));
          }
        } else {
          // Re-emit authenticated state to refresh listeners, ensuring verification stays false
          emit(state.copyWith(
            status: AuthBlocStatus.authenticated,
            user: user.copyWith(isEmailVerified: false),
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: AuthBlocStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onAuthSendVerificationEmailRequested(
    AuthSendVerificationEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.sendEmailVerification();
      emit(state.copyWith(
        status: AuthBlocStatus.success,
        successMessage: 'verification_sent',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthBlocStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(state.copyWith(
      status: AuthBlocStatus.unauthenticated,
      user: null,
      errorMessage: null,
      successMessage: null,
    ));
  }

  String _cleanErrorMessage(String rawError) {
    if (rawError.contains('email-already-in-use')) {
      return 'This email address is already in use.';
    } else if (rawError.contains('wrong-password') || rawError.contains('user-not-found')) {
      return 'Invalid email or password.';
    } else if (rawError.contains('invalid-email')) {
      return 'The email address is invalid.';
    } else if (rawError.contains('weak-password')) {
      return 'The password is too weak.';
    } else if (rawError.contains('Username is already taken')) {
      return 'This username is already taken by another runner.';
    }
    return rawError.replaceAll(RegExp(r'\[.*\]'), '').trim();
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
