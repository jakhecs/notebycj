import 'package:flutter/material.dart';
import 'package:notesbycj/constants/routes.dart';
import 'package:notesbycj/services/auth/auth_service.dart';
import 'package:notesbycj/utilities/show_error_dialog.dart';
import 'package:notesbycj/services/auth/auth_exceptions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Entrez votre email',
            ),
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
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createdUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      verifyEmailRoute,
                    );
                  }
                } on WeakPasswordRegisterException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Mot de passe trop faible.');
                  }
                } on InvalidEmailRegisterException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Email invalide.');
                  }
                } on GenericAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                        context, 'Une erreur inconnue est survenue.');
                  }
                } on EmailAlreadyInUseRegisterException {
                  if (context.mounted) {
                    await showErrorDialog(context,
                        'Cet email est déjà utilisé par un autre utilisateur.');
                  }
                }
              },
              child: const Text('Créer un compte')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Déjà un compte ? Se connecter!"),
          ),
        ],
      ),
    );
  }
}
