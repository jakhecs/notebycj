import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesbycj/constants/routes.dart';

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

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    devtools.log('Utilisateur introuvable');
                  } else if (e.code == 'wrong-password') {
                    devtools.log('Mot de passe incorrect');
                  } else if (e.code == 'invalid-credential') {
                    devtools.log(
                        'Les identifiants fournis sont incorrects (email ou mot de passe invalide).');
                  } else {
                    devtools.log('Erreur inconnue: ${e.code}');
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
