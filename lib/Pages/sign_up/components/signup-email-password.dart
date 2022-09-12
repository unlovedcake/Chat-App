import 'package:auto_animated/auto_animated.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sure_keep/All-Constants/all_constants.dart';
import 'package:sure_keep/Pages/sign_up/components/head_text.dart';
import 'package:sure_keep/Pages/sign_up/components/otp-verification-code.dart';
import 'package:sure_keep/Pages/sign_up/components/social.dart';
import 'package:sure_keep/Router/navigate-route.dart';

import '../../../All-Constants/size_constants.dart';
import '../../../Models/user-model.dart';
import '../../../Provider/auth-provider.dart';
import '../../../Theme/color-theme.dart';
import '../../../Widgets/animation-item-builder.dart';
import '../../../Widgets/neumorphic_text_field_container.dart';
import '../../../Widgets/rectangular_button.dart';
import '../../../Widgets/rectangular_input_field.dart';
import 'gender.dart';
import 'header-signup.dart';
import 'package:intl/intl.dart';

class EmailPasswordTextFields extends StatefulWidget {
  final UserModel userModel;
  const EmailPasswordTextFields({required this.userModel, Key? key}) : super(key: key);

  @override
  State<EmailPasswordTextFields> createState() => _EmailPasswordTextFieldsState();
}

class _EmailPasswordTextFieldsState extends State<EmailPasswordTextFields> {
  int itemsCount = 0;
  List<Widget> icon = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fakeController = TextEditingController();
  TextEditingController dateinput = TextEditingController();

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
      const HeaderSignUp(),
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
            RectangularInputField(
              sufixIcon: null,
              controller: passwordController,
              textInputType: TextInputType.text,
              hintText: 'Password',
              icon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              obscureText: true,
              onChanged: (val) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Password  is required");
                }
              },
            ),
            RectangularInputField(
              sufixIcon: null,
              controller: fakeController,
              textInputType: TextInputType.text,
              hintText: 'Fake Password',
              icon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              obscureText: true,
              onChanged: (val) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Fake Password  is required");
                }else if(passwordController.text == fakeController.text){
                  return ("Fake Password  should be different for password.");
                }
              },
            ),




          ],
        ),
      ),


      const SizedBox(
        height: Sizes.appPadding / 2,
      ),
      RectangularButton(
          text: 'Sign Up',
          press: () {

            UserModel userModel = UserModel()
              ..firstName = widget.userModel.firstName
              ..lastName = widget.userModel.lastName
              ..email = emailController.text
              ..fakePassword = fakeController.text
              ..birthDate = widget.userModel.birthDate
              ..gender = widget.userModel.gender
              ..imageUrl =widget.userModel.imageUrl
              ..userType = "User"
              ..geoLocation = {
                'latitude': "",
                'longitude': "",
              }
            ..chattingWith = {
              'chattingWith': "",
              'lastMessage': "",
              'dateLastMessage': DateTime.now(),
            };


            if (_formKey.currentState!.validate()) {


              context.read<AuthProvider>().signUp(passwordController.text,userModel, context);

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


