import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sure_keep/All-Constants/all_constants.dart';
import 'package:sure_keep/Provider/auth-provider.dart';

import '../../../Widgets/rectangular_button.dart';

class OTPVerificationCode extends StatefulWidget {
  const OTPVerificationCode({Key? key}) : super(key: key);

  @override
  State<OTPVerificationCode> createState() => _OTPVerificationCodeState();
}

class _OTPVerificationCodeState extends State<OTPVerificationCode> {
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();


  String? _phoneNumber;


  late String otpCode;

  void otp()async{

     otpCode =  Provider.of<AuthProvider>(context,listen: false).getOtpCode;

    await Future.delayed(const Duration(milliseconds: 500)).then((value){
      otpController1.text = otpCode[0];
    });
    await  Future.delayed(const Duration(milliseconds: 500)).then((value) {
      otpController2.text = otpCode[1];
    });
    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      otpController3.text = otpCode[2];
    });
    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      otpController4.text = otpCode[3];
    });
    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      otpController5.text = otpCode[4];
    });
    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      otpController6.text = otpCode[5];
    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
 _phoneNumber =  context.watch<AuthProvider>().getPhoneNumber;


 otp();




    return Scaffold(
      appBar: AppBar(

      ),
      backgroundColor: Color(0xfff7f6fb),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 32),
          child: Column(
            children: [

              SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/otp-image.png',color: AppColors.logoColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
               const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
               '$_phoneNumber',

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),


              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                otpCode,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 4,
                      children: [
                        otpTextField(true, false, otpController1),
                        otpTextField(true, false, otpController2),
                        otpTextField(true, false, otpController3),
                        otpTextField(true, false, otpController4),
                        otpTextField(true, false, otpController5),
                        otpTextField(true, true, otpController6),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    RectangularButton(text: 'Verify', press: (

                        ){

                      String otpCode = otpController1.text + otpController2.text + otpController3.text +
                          otpController4.text + otpController5.text + otpController6.text ;

                      String verificationId = Provider.of<AuthProvider>(context,listen: false).getVerificationID;

                      context.read<AuthProvider>().verifyOTP(otpCode, verificationId, context);

                      print("Verifiying OTP COde $otpCode ");
                      print("$verificationId ");
                    }),

                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 18,
              ),
              InkWell(
                onTap: (){
                  context.read<AuthProvider>().loginWithPhone(_phoneNumber!, context);
                },
                child: const Text(
                  "Resend New Code",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.logoColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox otpTextField(bool first, last, TextEditingController? controller) {
    return SizedBox(
      width: 40,
      height: 50,
      child: TextFormField(
        controller: controller,
        //autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length == 0 && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
       // showCursor: false,

        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 1, top: 2),
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color:AppColors.logoColor),
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, last}) {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextFormField(
        autofocus: true,
        onChanged: (value) {
          print(value);
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length == 0 && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        //readOnly: false,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counter: Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.purple),
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
