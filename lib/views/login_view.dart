import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesbycj/constants/routes.dart';
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
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Column(
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
            decoration: InputDecoration(hintText: 'Entrez votre mot de passe'),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthException) {
                  await showErrorDialog(context, 'Utilisateur introuvable.');
                } else if (state.exception is InvalidCredentialAuthException) {
                  await showErrorDialog(context, 'Identifiants  incorrects.');
                } else if (state.exception is GenericAuthException) {
                  await showErrorDialog(context, 'Errer inconnu est survenue.');
                }
              }
            },
            child: TextButton(
              onPressed: () {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventLogin(email, password));
              },
              child: const Text('Connexion'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Pas encore de compte ? Créez-en un!"),
          ),
        ],
      ),
    );
  }
}
