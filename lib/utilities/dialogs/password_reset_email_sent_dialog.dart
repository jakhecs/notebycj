import 'package:flutter/material.dart';
import 'package:notesbycj/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) async {
  return showGenericDialog<void>(
    context: context,
    text: 'Modification du mot de passe',
    content:
        'Nous vous avons envoyé un mail de confirmation à l\'adresse '
        'indiquée. Veuillez suivre les instructions contenues dans ce mail.',
    optionsBuilder: () => {'OK': null},
  );
}
