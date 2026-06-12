import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_profile.dart';

enum AuthBlocStatus {
  initial,
  loading,
  success,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  static const Object _kNoChange = Object();

  final AuthBlocStatus status;
  final String? errorMessage;
  final String? successMessage;
  final UserProfile? user;

  const AuthState({
    this.status = AuthBlocStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.user,
  });

  factory AuthState.initial() => const AuthState(status: AuthBlocStatus.initial);

  AuthState copyWith({
    AuthBlocStatus? status,
    Object? errorMessage = _kNoChange,
    Object? successMessage = _kNoChange,
    Object? user = _kNoChange,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage == _kNoChange
          ? this.errorMessage
          : errorMessage as String?,
      successMessage: successMessage == _kNoChange
          ? this.successMessage
          : successMessage as String?,
      user: user == _kNoChange ? this.user : user as UserProfile?,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage, user];
}
