import 'package:auto_animated/auto_animated.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sure_keep/All-Constants/all_constants.dart';
import 'package:sure_keep/Pages/sign_in/components/password-input-field.dart';
import 'package:sure_keep/Pages/sign_up/components/head_text.dart';
import 'package:sure_keep/Pages/sign_up/components/otp-verification-code.dart';
import 'package:sure_keep/Pages/sign_in/components/social.dart';
import 'package:sure_keep/Router/navigate-route.dart';

import '../../../All-Constants/size_constants.dart';
import '../../../Models/user-model.dart';
import '../../../Provider/auth-provider.dart';
import '../../../Theme/color-theme.dart';
import '../../../Widgets/animation-item-builder.dart';
import '../../../Widgets/neumorphic_text_field_container.dart';
import '../../../Widgets/rectangular_button.dart';
import '../../../Widgets/rectangular_input_field.dart';
import '../../sign_up/components/header-signup.dart';
import 'header-signin.dart';


class SignInEmailPassword extends StatefulWidget {

  const SignInEmailPassword({ Key? key}) : super(key: key);

  @override
  State<SignInEmailPassword> createState() => _SignInEmailPasswordState();
}

class _SignInEmailPasswordState extends State<SignInEmailPassword> {
  int itemsCount = 0;
  List<Widget> icon = [];

  TextEditingController emailController = TextEditingController();



  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";
  String? genderValue;
  bool isGender = false;

  final _formKey = GlobalKey<FormState>();






  @override
  void initState() {


    icon = [
      const HeaderSignIn(),
      Form(
        key: _formKey,
        child: Column(

          children: [



            RectangularInputField(
              sufixIcon: null,
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              hintText: 'Email',
              icon: const Icon(
                Icons.email_rounded,
                color: Colors.green,
              ),
              obscureText: false,
              onChanged: (val) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Email  is required");
                }
              },
            ),
          PasswordInputField(),





          ],
        ),
      ),


      const SizedBox(
        height: Sizes.appPadding / 2,
      ),
      RectangularButton(
          text: 'Sign In',
          press: () {



            if (_formKey.currentState!.validate()) {


              context.read<AuthProvider>().signIn(emailController.text,  Provider.of<AuthProvider>(context,listen: false).getPasswordValue, context);

            }
          }),
      const SizedBox(
        height: Sizes.dimen_40 / 2,
      ),
      const Social(),
    ];



    itemsCount = icon.length;

    Future.delayed(Duration(milliseconds: 1000) * 5, () {
      if (!mounted) {
        return;
      }
      setState(() {
        if (icon.length > itemsCount) {
          itemsCount += 6;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LiveList(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          showItemInterval: Duration(milliseconds: 200),
          showItemDuration: Duration(milliseconds: 750),
          // showItemInterval: Duration(milliseconds: 150),
          // showItemDuration: Duration(milliseconds: 250),
          visibleFraction: 0.001,
          itemCount: itemsCount,
          itemBuilder: animationItemBuilder((index) => icon[index])),
    );
  }
}


