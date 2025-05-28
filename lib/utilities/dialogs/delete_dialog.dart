import 'package:flutter/material.dart';
import 'package:notesbycj/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    text: 'Supprimer',
    content: 'Êtes-vous sûr de vouloir supprimer cette note ?',
    optionsBuilder: () => {'Oui': true, 'Non': false},
  ).then((value) => value ?? false);
}
