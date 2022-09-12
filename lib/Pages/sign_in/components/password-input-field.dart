import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../All-Constants/color_constants.dart';
import '../../../Provider/auth-provider.dart';
import '../../../Widgets/rectangular_input_field.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({Key? key}) : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isHidden = true;

  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return   RectangularInputField(

      controller: passwordController,
      textInputType: TextInputType.text,
      hintText: 'Password',
      icon: const Icon(
        Icons.lock,
        color: Colors.black,
      ),
      sufixIcon: IconButton(
        icon: Icon(
          Provider.of<AuthProvider>(context,listen: false).getIsHidden ? Icons.visibility : Icons.visibility_off,
          color: AppColors.logoColor,
        ),
        onPressed: () {
          // This is the trick

          _isHidden = !_isHidden;

          Provider.of<AuthProvider>(context,listen: false).setIsHidden(_isHidden);

        },
      ),
      obscureText: context.watch<AuthProvider>().getIsHidden,
      onChanged: (val) {
        Provider.of<AuthProvider>(context,listen: false).setPassWordValue(passwordController.text);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return ("Password  is required");
        }
      },
    );
  }
}
