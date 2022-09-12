import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/credentials.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Credentials(),

          ],
        ),
      ),
    );
  }
}
