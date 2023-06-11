import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pembayaran_kas/view/auth/singin_screen.dart';
import 'package:pembayaran_kas/view/root_page.dart';
import 'package:pembayaran_kas/view_model/bloc/authentication_bloc.dart';

class InitialScreen extends StatelessWidget {
  final AuthenticationState state;
  const InitialScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state == Loading()){
          return Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }else if (state == Authenticated()) {
          return const RootPage();
        }
        return const SignInScreen();
      },
    );
  }
}
