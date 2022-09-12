import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_view/splash_view.dart';
import 'package:splash_view/utils/done.dart';
import 'package:sure_keep/All-Constants/all_constants.dart';
import 'package:sure_keep/Pages/home/home-screen.dart';
import 'package:sure_keep/Pages/sign_in/sigin_screen.dart';
import 'package:sure_keep/Router/navigate-route.dart';
import 'Models/user-model.dart';
import 'Provider/auth-provider.dart';
import 'Provider/chat-provider.dart';
import 'Provider/theme-provider.dart';
import 'Theme/theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // AwesomeNotifications().initialize(
  // //     'resource://drawable/img',
  // //     [            // notification icon
  // //       NotificationChannel(
  // //         channelGroupKey: 'basic_test',
  // //         channelKey: 'basic',
  // //         channelName: 'Basic notifications',
  // //         channelDescription: 'Notification channel for basic tests',
  // //         channelShowBadge: true,
  // //         importance: NotificationImportance.High,
  // //         enableVibration: true,
  // //
  // //
  // //       ),
  // //
  // //     ]
  // );


  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email') ?? "";
  int duration = prefs.getInt('duration') ?? 30;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MyApp(email: email, duration: duration),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String email;
  final int duration;
  // final bool isBackGround;

  MyApp({required this.email,required this.duration, Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  bool? isBackGround;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  void isAppBackGround()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isBackGround = prefs.getBool('isBackGroundMode') ?? false;

  }

  @override
  void initState() {

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print(message.notification!.body != null);
    //   if (message.notification!.body != null) {
    //     NavigateRoute.gotoPage(context, Home());
    //   }
    // });

    WidgetsBinding.instance.addObserver(this);
    super.initState();

    AwesomeNotifications().actionStream.listen((action) {
      if(action.buttonKeyPressed == "open"){
        print("Open button is pressed");
      }else if(action.buttonKeyPressed == "delete"){
        print("Delete button is pressed.");
        print(action.payload);
      }else{
        print(action.payload);
        print("OKEYKA");//notification was pressed
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    isAppBackGround();
    if (state == AppLifecycleState.resumed) {

      print("RESUME");

    } else if (state == AppLifecycleState.inactive &&  isBackGround == true) {

       Future.delayed(Duration(seconds: widget.duration)).then((value) {
         print("INACTIVE");
         context.read<AuthProvider>().setAppActive(true);
       });

    } else if (state == AppLifecycleState.paused  &&  isBackGround == true) {

      Future.delayed(Duration(seconds: widget.duration)).then((value) {
        print("PAUSE");
        context.read<AuthProvider>().setAppActive(true);
      });

    } else if (state == AppLifecycleState.detached  &&  isBackGround == true) {
      Future.delayed(Duration(seconds: widget.duration)).then((value) {
        print("DETACHED");
        context.read<AuthProvider>().setAppActive(true);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      theme: lightTheme,
      home: SplashView(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.white, AppColors.logoColor]),
          loadingIndicator: const RefreshProgressIndicator(),

          logo: SizedBox(
            height: 150,
            width: 150,
            child: Image.asset('assets/images/logo.png'),
          ),
          done: widget.email == "" ? Done(const SignInScreen(), animationDuration: Duration(seconds: 2),
            curve: Curves.easeInOut,) : Done(const Home(),
            curve: Curves.easeInOut,)),
      //home:  email == "" ? const SignInScreen() : Home(),
      debugShowCheckedModeBanner: false,
      color: Colors.indigo[900],
    );
  }
}
