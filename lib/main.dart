import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesbycj/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // home: const RegisterView(),
    home: const HomePage(),
    // home: const LoginView(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page d\'accueil'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
                print("Bienvenue ${user?.email}");
              } else {
                print(" Email non vérifié");
              }
              return const Text("Connecter");
            default:
              return Text('Loading...');
          }
        },
      ),
    );
  }
}
