import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesbycj/services/auth/bloc/auth_bloc.dart';
import 'package:notesbycj/services/auth/bloc/auth_event.dart';
import 'package:notesbycj/services/auth/bloc/auth_state.dart';
import 'package:notesbycj/utilities/dialogs/error_dialog.dart';
import 'package:notesbycj/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetEmailSentDialog(context);
          }
          if (state.exception != null) {
            if (context.mounted) {
              await showErrorDialog(
                context,
                'Nous ne pouvons pas exécuter cette reuqete. Veuillez vous assurer que votre adresse mail est correcte ou  que vous avez créé un compte.',
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Mot de passe oublié')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                ('Si vous avez oublié votre mot de passe, vous pouvez le réinitialiser en renseignant votre adresse mail.'),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Adresse mail'),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(
                    AuthEventForgotPassword(email: email),
                  );
                },
                child: const Text(
                  'Envoyez-moi le lien de réinitialisation du mot de passe',
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text('Revenir à la page de connexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
