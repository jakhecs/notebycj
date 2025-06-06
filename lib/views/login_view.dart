import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesbycj/services/auth/auth_exceptions.dart';
import 'package:notesbycj/services/auth/bloc/auth_bloc.dart';
import 'package:notesbycj/services/auth/bloc/auth_event.dart';
import 'package:notesbycj/services/auth/bloc/auth_state.dart';
import 'package:notesbycj/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'Impossible de trouver l\'utilisateur avec cet email.',
            );
          } else if (state.exception is InvalidCredentialAuthException) {
            await showErrorDialog(context, 'Identifiants  incorrects.');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Errer inconnu est survenue.');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Connexion')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Entrez votre email'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventLogin(email, password));
                },
                child: const Text('Connexion'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());
                },
                child: const Text('Mot de passe oublié?'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text("Pas encore de compte ? Créez-en un!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
