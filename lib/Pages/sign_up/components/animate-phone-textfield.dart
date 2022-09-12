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
import '../../../Widgets/rectangular_button.dart';
import '../../../Widgets/rectangular_input_field.dart';

class AnimatePhoneFields extends StatefulWidget {
  const AnimatePhoneFields({Key? key}) : super(key: key);

  @override
  State<AnimatePhoneFields> createState() => _AnimatePhoneFieldsState();

}

class _AnimatePhoneFieldsState extends State<AnimatePhoneFields> {
  int itemsCount = 0;
  List<Widget> icon = [];
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    icon = [


      const HeadText(),

      Form(
        key: _formKey,
        child: IntlPhoneField(
          cursorColor: AppColors.logoColor,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color:  AppColors.logoColor, width: 2.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          initialCountryCode: 'PH',
          onChanged: (phone) {
            phoneController.text = phone.completeNumber;
            print(phone.completeNumber);
          },
        ),
      ),
      const SizedBox(
        height: Sizes.appPadding / 2,
      ),
      RectangularButton(
          text: 'Continue',
          press: () {
            // UserModel userModel = UserModel()
            //   ..firstName = firstNameController.text
            //   ..lastName = lastNameController.text
            //   ..email = emailController.text
            //   ..userType = "User"
            //   ..chattingWith = {
            //     'chattingWith' : "",
            //     'lastMessage' : "",
            //     'dateLastMessage' : DateTime.now(),
            //
            //   }
            //   ..imageUrl =
            //       "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000";
            if (_formKey.currentState!.validate()) {

                context.read<AuthProvider>().loginWithPhone(phoneController.text, context);
              //NavigateRoute.gotoPage(context, OTPVerificationCode());

            }
          }),
      const SizedBox(
        height: Sizes.dimen_40  / 2,
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

    return LiveList(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        showItemInterval: Duration(milliseconds: 200),
        showItemDuration: Duration(milliseconds: 750),
        // showItemInterval: Duration(milliseconds: 150),
        // showItemDuration: Duration(milliseconds: 250),
        visibleFraction: 0.001,
        itemCount: itemsCount,
        itemBuilder: animationItemBuilder((index) => icon[index]));
  }
}
