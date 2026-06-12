import 'package:flutter/foundation.dart';
import '../../../domain/entities/user_profile.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
  });
}

class AuthEmailVerificationCheckRequested extends AuthEvent {}

class AuthSendVerificationEmailRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final UserProfile? user;
  const AuthStatusChanged(this.user);
}
