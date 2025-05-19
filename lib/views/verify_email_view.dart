import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        const Text("Vérifiez votre email"),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text("Envoyé le mail de vérification"),
        ),
      ]),
    );
  }
}

// class _VerifyEmailViewState extends State<VerifyEmailView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vérification de l\'email'),
//       ),
//       body: Column(
//         children: [
//           const Text("Vérifiez votre email"),
//           TextButton(
//             onPressed: () async {
//               final user = FirebaseAuth.instance.currentUser;
//               if (user != null) {
//                 await user.sendEmailVerification();
//                 await user
//                     .reload(); // Recharge l'état pour vérifier la mise à jour
//                 if (user.emailVerified) {
//                   // Si vérifié, redirige ou mets à jour l'UI
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Email vérifié !')),
//                   );
//                   // Optionnel : Navigue vers une autre vue si nécessaire
//                   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NextScreen()));
//                 }
//               }
//             },
//             child: const Text("Envoyé le mail de vérification"),
//           ),
//         ],
//       ),
//     );
//   }
// }
