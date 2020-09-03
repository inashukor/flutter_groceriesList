import 'package:listina/services/auth_service.dart';
import 'package:flutter/material.dart';

class Provide extends InheritedWidget {
  final AuthService auth;
  final db;

  Provide({
    Key key,
    Widget child,
    this.auth,
    this.db,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provide of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provide) as Provide);
}
