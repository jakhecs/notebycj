import 'package:flutter/material.dart';
import 'package:notesbycj/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String message) {
  return showGenericDialog<void>(
    context: context,
    text: 'Une erreur est survenue',
    content: message,
    optionsBuilder: () => {'OK': null},
  );
}
