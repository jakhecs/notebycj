import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesbycj/services/auth/bloc/auth_bloc.dart';
import 'package:notesbycj/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification de l\'email')),
      body: Column(
        children: [
          const Text(
            "Un email de vérification vient de vous être envoyé. S'il vous plaît, ouvrer votre boîte de réception et cliquer sur le lien pour vérifier votre adresse email.",
          ),
          const Text(
            "Vous n'avez pas reçu de mail de vérification ? Cliquez sur le bouton ci-dessous.",
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                const AuthEventSendEmailVerification(),
              );
            },
            child: const Text("Envoyé le mail de vérification"),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogout());
            },
            child: const Text("Retourner à la page de connexion"),
          ),
        ],
      ),
    );
  }
}
