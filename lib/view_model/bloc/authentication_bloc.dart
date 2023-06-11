import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pembayaran_kas/model/repository/authentication_repository/authentication_repository.dart';
import 'package:pembayaran_kas/model/user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : super(UnAuthenticated()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authenticationRepository.signInWithGoogle();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authenticationRepository.signOut();
      emit(UnAuthenticated());
    });
  }
}
