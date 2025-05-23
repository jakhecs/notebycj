import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesbycj/constants/routes.dart';
import 'package:notesbycj/utilities/show_error_dialog.dart';

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
      appBar: AppBar(
        title: const Text('Connexion'),
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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  final user = FirebaseAuth.instance.currentUser;

                  if (user?.emailVerified ?? false) {
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        notesRoute,
                        (route) => false,
                      );
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  const errorMessages = {
                    'user-not-found': 'Utilisateur introuvable.',
                    'wrong-password': 'Mot de passe incorrect.',
                    'invalid-credential':
                        'Les identifiants fournis sont incorrects (email ou mot de passe invalide).',
                    'invalid-email': 'Email invalide.',
                    'too-many-requests':
                        'Trop de tentatives. Veuillez réessayer plus tard.',
                    'network-request-failed':
                        'Erreur de connexion réseau. Veuillez vérifier votre connexion.',
                  };
                  final errorMessage = errorMessages[e.code] ??
                      'Une erreur inconnue est survenue: ${e.code}';
                  if (context.mounted) {
                    await showErrorDialog(context, errorMessage);
                  }
                }
              },
              child: const Text('Connexion')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Pas encore de compte ? Créez-en un!"),
          ),
        ],
      ),
    );
  }
}
