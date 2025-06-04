import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesbycj/constants/routes.dart';
import 'package:notesbycj/services/auth/auth_exceptions.dart';
import 'package:notesbycj/services/auth/bloc/auth_bloc.dart';
import 'package:notesbycj/services/auth/bloc/auth_event.dart';
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
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                context.read<AuthBloc>().add(AuthEventLogin(email, password));
              } on UserNotFoundAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'Utilisateur introuvable.');
                }
              } on WrongPasswordAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'Mot de passe incorrect.');
                }
              } on InvalidCredentialAuthException {
                if (context.mounted) {
                  await showErrorDialog(
                    context,
                    'Les identifiants fournis sont incorrects (email ou mot de passe invalide).',
                  );
                }
              } on InvalidEmailAuthException {
                if (context.mounted) {
                  await showErrorDialog(context, 'Email invalide.');
                }
              } on GenericAuthException {
                if (context.mounted) {
                  await showErrorDialog(
                    context,
                    'Une erreur inconnue est survenue.',
                  );
                }
              }
            },
            child: const Text('Connexion'),
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
