import 'package:flutter/material.dart';
import 'package:notesbycj/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    text: 'Se déconnecter',
    content: 'Êtes-vous sûr de vouloir vous déconnecter ?',
    optionsBuilder: () => {'Oui': true, 'Non': false},
  ).then((value) => value ?? false);
}
