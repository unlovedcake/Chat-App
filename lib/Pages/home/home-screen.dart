import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sure_keep/All-Constants/all_constants.dart';
import 'package:sure_keep/Pages/home/home-content/ListAllContactsPhone.dart';
import 'package:sure_keep/Pages/Profile/profile-screen.dart';
import 'package:sure_keep/Provider/auth-provider.dart';
import 'package:http/http.dart' as http;
import 'package:sure_keep/Router/navigate-route.dart';
import '../../Chat/person-who-chatted-you.dart';
import '../../Models/user-model.dart';
import '../search-user/search-user-screen.dart';


class Home extends StatefulWidget {
  //final UserModel userData;

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  PageController? _pageController;
  late AnimationController animationController;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  User? user = FirebaseAuth.instance.currentUser;

  UserModel? userData = UserModel();

  Future<UserModel> getLoggedInUser() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('table-user')
        .where('email', isEqualTo: user!.email)
        .get();
    List<DocumentSnapshot> document = result.docs;
    DocumentSnapshot documentSnapshot = document[0];

    print(user!.email);


    return userData = UserModel.fromMap(documentSnapshot);
  }


  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  @override
  void initState() {


    _pageController = PageController(initialPage: _selectedIndex);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _pages = <Widget>[
      ListAllContactPhone(userData: userData!),
      // const Icon(
      //   Icons.message_outlined,
      //   size: 150,
      // ),
      const Icon(
        Icons.search,
        size: 150,
      ),
      const Icon(
        Icons.contact_phone_outlined,
        size: 150,
      ),

      const Icon(
        Icons.person,
        size: 150,
      ),
    ];
    super.initState();

    getLoggedInUser();
    loadFCM();
    listenFCM();

  }




  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
          await _getByteArrayFromUrl(userData!.imageUrl.toString()));
      final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
          await _getByteArrayFromUrl(userData!.imageUrl.toString()));

      final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(bigPicture,
          largeIcon: largeIcon,
          contentTitle: notification?.title,
          htmlFormatContentTitle: true,
          summaryText: notification?.body,
          htmlFormatSummaryText: true);

      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              styleInformation: bigPictureStyleInformation,  // it will display the url image
              icon: 'img',

              //largeIcon: const DrawableResourceAndroidBitmap('ic_launcher'),
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();

    return FutureBuilder(
        future: getLoggedInUser(),
        builder: (context, snapshot) {
          return Scaffold(

            appBar: AppBar(
                backgroundColor: Colors.transparent,
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [

                  Image.asset('assets/images/logo.png',width: 50,height: 50,),
                  Text('SUREKEEP',style: GoogleFonts.monoton(color: AppColors.logoColor,
                    textStyle: const TextStyle( letterSpacing: 5,fontSize: 12,fontWeight: FontWeight.bold),
                  ),),
                  // Text(
                  //   _selectedIndex == 1
                  //       ? "Chat"
                  //       : _selectedIndex == 2
                  //           ? "Search"
                  //           : _selectedIndex == 3
                  //               ? "Profile"
                  //               : "Contact",
                  // ),

                ],
              ),
              automaticallyImplyLeading: false,

              elevation: 0,
              // leading: Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(10),
              //     child: Image.network(
              //       userData!.imageUrl.toString(),
              //     ),
              //   ),
              // ),

                actions: [
                  _selectedIndex == 2 ?
                  IconButton(
                    onPressed: () {
                      // method to show the search bar
                      showSearch(
                          context: context,
                          // delegate to customize the search bar
                          delegate: CustomSearchDelegate());
                    },
                    icon: const Icon(Icons.search,color: Colors.black,),
                  ): SizedBox.shrink(),
                ]
              // actions: [
              //   Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: InkWell(
              //       onTap: () {
              //         AuthProvider.logout(context);
              //       },
              //       child: Icon(Icons.logout),
              //     ),
              //   ),
              // ],
            ),

            body: WillPopScope(
              onWillPop: () async{
                final timegap = DateTime.now().difference(pre_backpress);
                final cantExit = timegap >= Duration(seconds: 2);
                pre_backpress = DateTime.now();
                if(cantExit){

                  Fluttertoast.showToast(
                    msg: 'Press back button again to exit.',
                    timeInSecForIosWeb: 3,
                    gravity: ToastGravity.CENTER_RIGHT,
                  );
                  return false;
                }else{
                  return true;
                }
              },
              child: PageView(
                controller: _pageController,
                onPageChanged: (int newpage) {
                  setState(() {
                    _selectedIndex = newpage;
                  });
                },
                children: [

                  ListAllContactPhone(userData: userData!),

                  const PersonWhoChattedYou(),
                  SearchUser(),
                  ProfileScreen(user: userData!),
                  //ListAllContactPhone(),

                  // IndexedStack(
                  //   index: _selectedIndex,
                  //   children: _pages,
                  // ),
                ],
              ),
            ),

            // bottomNavigationBar: SizeTransition(
            // sizeFactor: animationController,
            // axisAlignment: -1.0,
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.black,
              currentIndex: _selectedIndex,
              //New
              backgroundColor: AppColors.logoColor,
              // iconSize: 40,
              //mouseCursor: SystemMouseCursors.grab,

              selectedFontSize: 12,
              selectedIconTheme:
                  const IconThemeData(color: AppColors.logoColor, size: 40),
              selectedItemColor: AppColors.logoColor,
              selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),

              //hide label text
              //showSelectedLabels: false,
              //showUnselectedLabels: false,

              unselectedIconTheme: const IconThemeData(
                color: Colors.grey,
              ),

              onTap: (index) {
                _pageController?.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              //onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.home),
                //   label: 'Home',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone_outlined),
                  label: 'Contact',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Chat',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        });
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: const Color(0xff764abc)),
              accountName: Text(
                "Pinkesh Darji",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "pinkesh.earth@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: FlutterLogo(),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Page 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.train,
              ),
              title: const Text('Page 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            AboutListTile(
              // <-- SEE HERE
              icon: Icon(
                Icons.info,
              ),
              child: Text('About app'),
              applicationIcon: Icon(
                Icons.local_play,
              ),
              applicationName: 'My Cool App',
              applicationVersion: '1.0.25',
              applicationLegalese: '© 2019 Company',
              aboutBoxChildren: [
                ///Content goes here...
              ],
            ),
          ],
        ),
      ),
    );
  }
}
