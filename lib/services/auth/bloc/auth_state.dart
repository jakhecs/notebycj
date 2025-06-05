import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:notesbycj/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Svp patienter...',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required super.isLoading, this.exception});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required super.isLoading, required this.user});
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required super.isLoading,
    this.exception,
    required this.hasSentEmail,
  });
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
    super.loadingText = null,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
