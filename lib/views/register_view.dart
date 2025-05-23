import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:firebase_auth/firebase_auth.dart';

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
                  final user = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  devtools.log(user.toString());
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-already-exists') {
                    devtools.log('Utilisateur déjà existant');
                  } else if (e.code == 'invalid-email') {
                    devtools.log('Email invalide');
                  } else if (e.code == 'operation-not-allowed') {
                    devtools.log(
                        'L\'opération n\'est pas autorisée pour cette application');
                  } else if (e.code == 'weak-password') {
                    devtools.log('Mot de passe trop faible');
                  } else if (e.code == 'app-not-authorized') {
                    devtools.log(
                        'L\'application n\'est pas autorisée à utiliser ce service');
                  } else if (e.code == 'too-many-requests') {
                    devtools
                        .log('Trop de requêtes ont été envoyées à ce service');
                  } else {
                    devtools.log('Erreur inconnue: ${e.code}');
                  }
                }
              },
              child: const Text('Créer un compte')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
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
