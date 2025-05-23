import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesbycj/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification de l\'email'),
      ),
      body: Column(children: [
        const Text(
            "Un email de vérification vient de vous être envoyé. S'il vous plaît, ouvrer votre boîte de réception et cliquer sur le lien pour vérifier votre adresse email."),
        const Text(
            "Vous n'avez pas reçu de mail de vérification ? Cliquez sur le bouton ci-dessous."),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text("Envoyé le mail de vérification"),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Text("Retourner à la page de connexion"),
        ),
      ]),
    );
  }
}
