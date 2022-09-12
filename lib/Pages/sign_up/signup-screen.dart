import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../sign_in/components/credentials.dart';
import 'components/signup-credentials.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                height: size.height,
                child: SignUpCredentials(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
