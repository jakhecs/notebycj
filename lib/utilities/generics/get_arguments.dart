import 'package:flutter/material.dart';

extension GetArguments on BuildContext {
  T? getArgument<T>() {
    final modalroute = ModalRoute.of(this);
    if (modalroute != null) {
      final args = modalroute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
