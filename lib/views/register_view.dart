import 'package:flutter/material.dart';
import 'package:notesbycj/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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

                          print(user);
                        } on FirebaseAuthException catch (e) {
                          print('Erreur: ${e.message}');
                          print('Code: ${e.code}');
                          if (e.code == 'user-already-exists') {
                            print('Utilisateur déjà existant');
                          } else if (e.code == 'invalid-email') {
                            print('Email invalide');
                          } else if (e.code == 'operation-not-allowed') {
                            print(
                                'L\'opération n\'est pas autorisée pour cette application');
                          } else if (e.code == 'weak-password') {
                            print('Mot de passe trop faible');
                          } else if (e.code == 'app-not-authorized') {
                            print(
                                'L\'application n\'est pas autorisée à utiliser ce service');
                          } else if (e.code == 'too-many-requests') {
                            print(
                                'Trop de requêtes ont été envoyées à ce service');
                          } else {
                            print('Erreur inconnue: ${e.code}');
                          }
                        }
                      },
                      child: const Text('Register')),
                ],
              );
            default:
              return Text('Loading...');
          }
        },
      ),
    );
  }
}
