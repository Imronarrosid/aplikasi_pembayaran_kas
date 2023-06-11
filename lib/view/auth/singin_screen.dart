import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pembayaran_kas/view_model/bloc/authentication_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void _googleSignInHandler(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context).add(GoogleSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Masuk'),
          ElevatedButton(
              onPressed: () => _googleSignInHandler(context),
              child: const Text('Google'))
        ],
      ),
    );
  }
}
