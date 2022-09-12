import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'animated-signup-textfield.dart';

class SignUpCredentials extends StatelessWidget {
  SignUpCredentials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(height:size.height,child:  const AnimateSignUpFields());
  }
}
