import 'package:flutter/material.dart';

class Transitions {
  // Getter for slideBottomTop transition
  static Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  )
  get slideBottomTop => (context, animation, secondaryAnimation, child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);
    return SlideTransition(position: offsetAnimation, child: child);
  };

  // Getter for fade transition
  static Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
    Widget,
  )
  get fade => (context, animation, secondaryAnimation, child) {
    const curve = Curves.easeInOut;
    final fadeAnimation = CurvedAnimation(parent: animation, curve: curve);
    return FadeTransition(opacity: fadeAnimation, child: child);
  };
}
