import 'package:flutter/material.dart';
import 'package:sure_keep/Pages/sign_up/phone-auth_screen.dart';

class NavigateRoute {
  static gotoPage(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }


  static routePageAnimation(BuildContext context, Route widget) {
    Navigator.push(
      context,
        widget
    );
  }

}