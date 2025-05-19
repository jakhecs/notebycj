import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  final user =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  print(user);
                } on FirebaseAuthException catch (e) {
                  print('Erreur: ${e.message}');
                  print('Code: ${e.code}');
                  if (e.code == 'user-not-found') {
                    print('Utilisateur introuvable');
                  } else if (e.code == 'wrong-password') {
                    print('Mot de passe incorrect');
                  } else if (e.code == 'invalid-credential') {
                    print(
                        'Les identifiants fournis sont incorrects (email ou mot de passe invalide).');
                  } else {
                    print('Erreur inconnue: ${e.code}');
                  }
                }
              },
              child: const Text('Connexion')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/',
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
