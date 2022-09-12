import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sure_keep/Pages/sign_in/sigin_screen.dart';
import '../../Router/navigate-route.dart';
import '../../Theme/color-theme.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: CustomPaint(
                  size: Size.fromHeight(200),
                  //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: RPSCustomPainter(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntlPhoneField(
                      cursorColor:Colors.blue,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
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
                    Visibility(
                      visible: otpVisibility,
                      child: TextField(
                        controller: otpController,
                        decoration: const InputDecoration(
                          hintText: 'OTP',
                          prefix: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(''),
                          ),
                        ),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (otpVisibility) {
                            verifyOTP();
                          } else {
                            loginWithPhone();
                          }
                          print(phoneController.text);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          NavigateRoute.gotoPage(context, SignInScreen());
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 18),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black),
                        )),

                    TextButton(
                        onPressed: () {

                        },
                        child: const Text(
                          "All Contacts List",
                          style: TextStyle(color: Colors.black),
                        )),
                    MaterialButton(
                      color: Colors.indigo[900],
                      onPressed: () {
                        NavigateRoute.routePageAnimation(
                            context, _createRoute());
                      },
                      child: Text(
                        otpVisibility ? "Verify" : "Go To Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                child: CustomPaint(
                  size: Size.fromHeight(200),
                  //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: RPSCustomPainter1(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),

          // child: SizeTransition(
          //   sizeFactor: animation,
          //   axis: Axis.horizontal,
          //   axisAlignment: -1,
          //     child: Padding(
          //           padding: padding,
          //           child: child(index),
          //         ),
          // ),
          //
          child: Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
              axisAlignment: 0.0,
            ),
          ),

          // child: FadeTransition(
          //   opacity:animation,
          //   child: child,
          // ),

          // child: ScaleTransition(
          //   scale: animation,
          //   child: Padding(
          //     padding:EdgeInsets.all(8),
          //     child: child,
          //   ),
          // ),

          // child: SlideTransition(
          //   position: Tween<Offset>(
          //     begin: Offset(0, -0.1),
          //     end: Offset.zero,
          //   ).animate(animation),
          //   child: Padding(
          //     padding: padding,
          //     child: child(index),
          //   ),
          // ),
        );
        // return SlideTransition(
        //   position: animation.drive(tween),
        //   child: child,
        // );
      },
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      // phoneNumber: "+63" + phoneController.text,
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Home(),
          //   ),
          // );
        } else {
          Fluttertoast.showToast(
            msg: "your login is failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
    );
  }
}


class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path0 = Path();
    path0.moveTo(0,0);
    path0.quadraticBezierTo(size.width*0.0006250,size.height*0.7456068,0,size.height*0.9941424);
    path0.quadraticBezierTo(0,size.height*0.7728307,0,size.height*0.3222093);
    path0.lineTo(size.width,size.height*0.9965843);
    path0.lineTo(size.width*0.9988917,0);
    path0.lineTo(0,0);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class RPSCustomPainter1 extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color =Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path0 = Path();
    path0.moveTo(0,0);
    path0.quadraticBezierTo(size.width*0.0006250,size.height*0.7456068,0,size.height*0.9941424);
    path0.quadraticBezierTo(0,size.height*0.7728307,0,size.height*1.0023401);
    path0.lineTo(size.width,size.height);
    path0.lineTo(size.width,size.height*0.7614390);
    path0.lineTo(0,0);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}


