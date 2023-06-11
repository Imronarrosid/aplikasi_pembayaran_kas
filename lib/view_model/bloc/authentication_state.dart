part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable{
  @override
  List<Object?> get props => [];

}
class Loading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class Authenticated extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

// This is the initial state of the bloc. When the user is not authenticated the state is changed to Unauthenticated.
class UnAuthenticated extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

// If any error occurs the state is changed to AuthError.
class AuthError extends AuthenticationState {
  final String error;

  AuthError(this.error);
  @override
  List<Object?> get props => [error];
}
 
