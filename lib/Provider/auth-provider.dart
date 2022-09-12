import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sure_keep/Pages/home/home-screen.dart';
import 'package:sure_keep/Pages/sign_in/login.dart';
import 'package:sure_keep/Pages/sign_up/components/otp-verification-code.dart';
import 'package:sure_keep/Pages/sign_up/signup-screen.dart';

import '../Models/user-model.dart';
import '../Pages/sign_in/sigin_screen.dart';
import '../Router/navigate-route.dart';
import '../Widgets/progress-dialog.dart';

class AuthProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;

  String? errorMessage;
  String? userEmail;
  String verificationID = "";
  String _phoneNumber = "";
  String _otpCode = "000000";
  String genderValue = "Man";

  String? passwordValue;

  bool isGenderMan = false;

  bool isGenderWoman = false;

  bool isAppActive = false;
  bool isBackGroundMode = false;
  bool _isHidden = true;

  bool get getAppActive => isAppActive;

  bool get getBackGroundMode => isBackGroundMode;

  setBackGroundMode(bool isActive) {
    isBackGroundMode = isActive;
    notifyListeners();
  }

  setAppActive(bool isActive) {
    isAppActive = isActive;
    notifyListeners();
  }

  setGenderMan(bool gen) {
    isGenderMan = gen;
    notifyListeners();
  }

  setGenderWoman(bool gen) {
    isGenderWoman = gen;
    notifyListeners();
  }

  setGenderValue(String gen) {
    genderValue = gen;
    notifyListeners();
  }

  setIsHidden(bool hide) {
    _isHidden = hide;
    notifyListeners();
  }

  setPassWordValue(String password) {
    passwordValue = password;
    notifyListeners();
  }

  String get getPasswordValue => passwordValue!;

  String get getGenderValue => genderValue;

  bool get getGenderMan => isGenderMan;

  bool get getGenderWoman => isGenderWoman;

  bool get getIsHidden => _isHidden;

  String get getPhoneNumber => _phoneNumber;

  String get getVerificationID => verificationID;

  String get getOtpCode => _otpCode;

  String get getUserEmail => userEmail!;

  Future<void> loginWithPhone(String phoneNumber, BuildContext context) async {
    int? resendToken;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait...",
          );
        });

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) {
            _otpCode = credential.smsCode!;

            Fluttertoast.showToast(
              msg: 'OTP sent successfully.',
              timeInSecForIosWeb: 3,
              gravity: ToastGravity.CENTER_RIGHT,
            );
            notifyListeners();
            print("Code Sent Successfully $_otpCode");
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
            timeInSecForIosWeb: 3,
            msg: e.message.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER_RIGHT,
          );

          // if (e.code == 'invalid-phone-number') {
          //   Fluttertoast.showToast(
          //     timeInSecForIosWeb: 3,
          //     msg: 'The phone number is invalid.',
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER_RIGHT,
          //   );
          // }else {
          //
          //   Fluttertoast.showToast(
          //     timeInSecForIosWeb: 3,
          //     msg: e.message.toString(),
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER_RIGHT,
          //   );
          // }
          Navigator.pop(context);
          print(e.toString());
        },
        forceResendingToken: resendToken,
        codeSent: (String verificationId, int? resendTokens) {
          verificationID = verificationId;
          _phoneNumber = phoneNumber;

          resendToken = resendTokens;
          UserCredential? userCredential;
          userCredential?.additionalUserInfo?.isNewUser;

          Navigator.pop(context);
          NavigateRoute.gotoPage(context, const OTPVerificationCode());
          print("Code Sent");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Navigator.pop(context);

          print("Code Timeout");
        },
        timeout: const Duration(seconds: 60),
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> verifyOTP(
      String otpCode, String verificationId, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Verifiying OTP Code, Please wait...",
          );
        });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);

      if (_otpCode != otpCode) {
        Fluttertoast.showToast(
          msg: "Invalid OTP Code",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Your account is successfully verified.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        NavigateRoute.gotoPage(context, const SignUpScreen());
      }

      await _auth.signInWithCredential(credential).then(
            (val) {},
          );
    } catch (e) {
      print(e.toString());
    }
  }

  signUp(String password, UserModel? userModel, BuildContext context) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(
              message: "Authenticating, Please wait...",
            );
          });

      String? token = await FirebaseMessaging.instance.getToken();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userModel!.email.toString(), password: password);
      user = userCredential.user;

      userModel.docID = user!.uid;

      String phoneNum =
          Provider.of<AuthProvider>(context, listen: false).getPhoneNumber;

      userModel.phoneNumber = _phoneNumber;
      userModel.token = token;

      await user!.updateDisplayName(userModel.firstName);
      await user!.updatePhotoURL(userModel.imageUrl);

      await user!.reload();
      user = _auth.currentUser;

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('table-user')
          .where('email', isEqualTo: userModel.email.toString())
          .get();
      final List<DocumentSnapshot> document = result.docs;

      if (document.isEmpty) {
        await FirebaseFirestore.instance
            .collection("table-user")
            .doc(user!.uid)
            .set(userModel.toMap())
            .then((uid) async {
          userEmail = userModel.email.toString();

          UserModel userData = UserModel(
              docID: userModel.docID,
              firstName: userModel.firstName,
              lastName: userModel.lastName,
              address: userModel.address,
              phoneNumber: userModel.phoneNumber,
              email: userModel.email,
              fakePassword: userModel.fakePassword,
              gender: userModel.gender,
              birthDate: userModel.birthDate,
              userType: userModel.userType,
              imageUrl: userModel.imageUrl);

          // DocumentSnapshot documentSnapshot = document[0];
          // UserModel userData =  UserModel.fromMap(documentSnapshot);

          NavigateRoute.gotoPage(context, Home());

          //
          // QuickAlert.show(
          //
          //   //customAsset: 'assets/images/form-header-img.png',
          //     context: context,
          //     autoCloseDuration: const Duration(seconds: 3),
          //     type: QuickAlertType.success,
          //     text: 'Welcome, You are now logged in !!!',
          //
          // );

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', userModel.email.toString());

          Fluttertoast.showToast(
            msg: "Account created successfully :) ",
            timeInSecForIosWeb: 3,
            gravity: ToastGravity.CENTER_RIGHT,
          );
        });
      }
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "email-already-in-use":
          errorMessage = "The account already exists for that email.";
          break;

        case "weak-password":
          errorMessage = "Weak Password.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Check Your Internet Access.";
      }

      Fluttertoast.showToast(
        timeInSecForIosWeb: 3,
        msg: errorMessage!,
        gravity: ToastGravity.CENTER,
      );
      print(error.code);
    }
  }

  signIn(String email, String password, BuildContext context) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(
              message: "Authenticating, Please wait...",
            );
          });

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('table-user')
          .where('email', isEqualTo: email)
          .get();
      final List<DocumentSnapshot> document = result.docs;

      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((id) async {
        if (document.isNotEmpty) {
          String? token = await FirebaseMessaging.instance.getToken();

          DocumentSnapshot documentSnapshot = document[0];
          UserModel userData = UserModel.fromMap(documentSnapshot);

          await FirebaseFirestore.instance
              .collection("table-user")
              .doc(userData.docID)
              .update({'token': token});
          NavigateRoute.gotoPage(context, Home());

          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('email', email);

          // QuickAlert.show(
          //
          //   //customAsset: 'assets/images/form-header-img.png',
          //   context: context,
          //   autoCloseDuration: const Duration(seconds: 3),
          //   type: QuickAlertType.success,
          //   text: 'Welcome, You are now logged in !!!',
          //
          // );
        }

        Fluttertoast.showToast(
          msg: "Welcome, You are now logged in !!! :) ",
          timeInSecForIosWeb: 3,
          gravity: ToastGravity.CENTER_RIGHT,
        );
      });

      notifyListeners();
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be invalid.";

          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Check Your Internet Access.";
      }

      // QuickAlert.show(
      //   context: context,
      //   autoCloseDuration: const Duration(seconds: 3),
      //   type: QuickAlertType.error,
      //   title: 'Oops...',
      //   text: errorMessage!,
      //);
      Fluttertoast.showToast(
        msg: errorMessage!,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.CENTER_RIGHT,
      );
      print(error.code);
    }
  }

  // the logout function
  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
  }

  Future<bool> isLoggedIn(UserModel userModel, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var email = prefs.getString('email');
    if (email != null) {
      return true;
    } else {
      return false;
    }
  }

  editProfile(String? uid, String? imageUrl, BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      await FirebaseFirestore.instance
          .collection('table-user')
          .doc(uid)
          .update({
        "imageUrl": imageUrl,
      }).whenComplete(() async {


        await user!.updatePhotoURL(imageUrl);


        Fluttertoast.showToast(msg: "Successfully Save Changes");
        print("success!");
        notifyListeners();
      });
    } on FirebaseException {
      // print(error);
      Fluttertoast.showToast(msg: "Something went wrong !!!");
    }
  }
}
