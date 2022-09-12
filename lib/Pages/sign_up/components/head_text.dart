import 'package:flutter/material.dart';

import '../../../All-Constants/size_constants.dart';




class HeadText extends StatelessWidget {
  const HeadText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(

      children:  [
        SizedBox(height: size.height * 0.08),

        RichText(
          text: TextSpan(
            text: 'We will send you  ',
            style: DefaultTextStyle.of(context).style,
            children: const <TextSpan>[
              TextSpan(text: 'One Time Password OTP', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' on this mobile number.'),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.05),

      ],
    );
  }
}
