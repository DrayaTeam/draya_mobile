import 'package:draya_mobile/core/widgets/fade_in_up_animation.dart';
import 'package:flutter/material.dart';

class AppDialogHelper {
  static void display(BuildContext context, Widget dialog, {Function()? then}) {
    showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => FadeInUp(delay: 200, child: dialog),
    ).then((_) {
      then;
    });
  }
}
