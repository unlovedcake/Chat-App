import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/credentials.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.2),
              Container(
                height: size.height,
                child: Credentials(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
