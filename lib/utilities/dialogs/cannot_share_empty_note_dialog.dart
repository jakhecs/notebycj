import 'package:flutter/material.dart';
import 'package:notesbycj/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    text: 'Partager',
    content: 'Vous ne pouvez pas partager une note vide.',
    optionsBuilder: () => {'OK': null},
  );
}
