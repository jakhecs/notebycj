import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesbycj/services/auth/auth_exceptions.dart';
import 'package:notesbycj/services/auth/bloc/auth_bloc.dart';
import 'package:notesbycj/services/auth/bloc/auth_event.dart';
import 'package:notesbycj/services/auth/bloc/auth_state.dart';
import 'package:notesbycj/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordRegisterException) {
            await showErrorDialog(context, 'Mot de passe trop faible.');
          } else if (state.exception is InvalidEmailRegisterException) {
            await showErrorDialog(context, 'Email invalide.');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Une erreur inconnue est survenue.');
          } else if (state.exception is EmailAlreadyInUseRegisterException) {
            await showErrorDialog(context, 'Cet email existe déjà .');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Créer un compte')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Entrez vos informations pour créer un compte.'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Entrez votre email'),
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                          AuthEventRegister(email, password),
                        );
                      },
                      child: const Text('Créer un compte'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogout());
                      },
                      child: const Text("Déjà un compte ? Se connecter!"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
