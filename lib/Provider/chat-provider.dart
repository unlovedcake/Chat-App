import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sure_keep/Chat/chatConversation.dart';

import '../Chat/default-fake-conversation.dart';
import '../Chat/fake-conversation.dart';
import '../Models/user-model.dart';
import '../Router/navigate-route.dart';
import '../Widgets/progress-dialog.dart';
import 'auth-provider.dart';

class ChatProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool isSend = true;
  bool isRead = false;

  String? isRadioButton ="";

  String errorMessage = "";

  setSend(bool send) {
    isSend = send;
    notifyListeners();
  }

  setRadioButton(String rb) {
    isRadioButton = rb;
    notifyListeners();
  }

  setIsRead(bool read) {
    isRead = read;
    notifyListeners();
  }


  String get getRadioButton => isRadioButton!;
  bool get getSend => isSend;
  bool get getIsRead => isRead;

  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<UserModel>> getUsers() {
    return FirebaseFirestore.instance
        .collection('table-user')
        .where("chattingWith.chattingWith", isEqualTo: user!.email)
        .snapshots()
        .map((comments) {
      return comments.docs.map((e) => UserModel.fromMap(e.data())).toList();
    });
  }

  Stream<List<UserModel>> get list => getUsers();

  late final List<UserModel> _myList;

  List<UserModel> get myList => _myList;

  void addToList(UserModel userModel) {}

  getUsersss() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('table-user')
        .where('chattingWith.chattingWith', isEqualTo: user!.email)
        .get();
    final List<DocumentSnapshot> document = result.docs;

    for (int i = 0; i < document.length; i++) {
      _myList.addAll(document[i]['firstName']);
    }
  }

  signInFakePassword(String email, String password, UserModel userModel,
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
      DocumentSnapshot documentSnapshot = document[0];
      UserModel userData = UserModel.fromMap(documentSnapshot);


      if (userData.fakePassword == password) {
        String docId = prefs.getString('docID') ?? "";

        if(docId == ""){
          Navigator.pop(context);
          NavigateRoute.gotoPage(context, DefaultFakeConversation(user: userModel));
        }

        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('table-user')
            .where('docID', isEqualTo: docId )
            .get();
        final List<DocumentSnapshot> document = result.docs;
        DocumentSnapshot documentSnapshot = document[0];
        UserModel userData = UserModel.fromMap(documentSnapshot);


        Navigator.pop(context);

        NavigateRoute.gotoPage(context,  FakeConversation(user:userData, userNameAndImage: userModel ));
        // NavigateRoute.gotoPage(context, FakeConversation(user: userModel));

      } else {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((id) async {
          Navigator.pop(context);
          NavigateRoute.gotoPage(context, ChatConversation(user: userModel));

          context.read<AuthProvider>().setAppActive(false);

          // QuickAlert.show(
          //
          //   //customAsset: 'assets/images/form-header-img.png',
          //   context: context,
          //   autoCloseDuration: const Duration(seconds: 3),
          //   type: QuickAlertType.success,
          //   text: 'Welcome, You are now logged in !!!',
          //
          // );

          // Fluttertoast.showToast(
          //   msg: "You are now logged in... :) ",
          //   gravity: ToastGravity.CENTER_RIGHT,
          // );
        });

        notifyListeners();
      }
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
}
