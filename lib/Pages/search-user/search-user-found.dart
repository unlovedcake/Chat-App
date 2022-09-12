import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sure_keep/Chat/chatConversation.dart';
import 'package:sure_keep/Pages/Profile/image-profile-widget.dart';

import '../../All-Constants/color_constants.dart';
import '../../All-Constants/size_constants.dart';
import '../../Models/user-model.dart';
import '../../Router/navigate-route.dart';
import '../Profile/profile-screen.dart';
import '../home/settings-screen.dart';

class SearchUserFound extends StatelessWidget {
  final UserModel user;

  SearchUserFound({required this.user});

  Widget buildImage() {
    final image = NetworkImage(user.imageUrl.toString());

    return   ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Hero(
        tag:  user.docID.toString(),
        child: CachedNetworkImage(
          imageUrl:user.imageUrl.toString(),
          width: 128.0,
          height: 128.0,
          fit: BoxFit.cover,
        ),
      ),
    );
    // return ClipOval(
    //   child: Material(
    //     color: Colors.transparent,
    //     child: Ink.image(
    //       image: image,
    //       fit: BoxFit.cover,
    //       width: 128,
    //       height: 128,
    //
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text("Search Found"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient:  LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.darkPrimary,
                              AppColors.logoColor,
                            ]
                        ),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(3,3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            color:  AppColors.darkShadow,
                          ),
                          BoxShadow(
                            offset: Offset(-5,-5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            color:  AppColors.lightShadow,
                          ),
                        ]
                    ),
                    child: Column(
                      children: [


                        buildImage(),
                        SizedBox(
                          height: Sizes.dimen_10,
                        ),
                        Text(
                          "${user.firstName}",
                          //acessing the name property of the  MyPlatforms class
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: Sizes.dimen_10,
                        ),

                        // Wrap(
                        //   spacing: 20,
                        //   children: [
                        //     Wrap(
                        //       direction: Axis.vertical,
                        //       crossAxisAlignment: WrapCrossAlignment.center,
                        //       spacing: 6,
                        //       children: const [
                        //         Text("143"),
                        //         Text(
                        //           "Following",
                        //           //acessing the name property of the  MyPlatforms class
                        //           style: TextStyle(fontSize: 14, color: Colors.grey),
                        //         ),
                        //       ],
                        //     ),
                        //     Wrap(
                        //       direction: Axis.vertical,
                        //       crossAxisAlignment: WrapCrossAlignment.center,
                        //       spacing: 6,
                        //       children: const [
                        //         Text("143"),
                        //         Text(
                        //           "Followers",
                        //           //acessing the name property of the  MyPlatforms class
                        //           style: TextStyle(fontSize: 14, color: Colors.grey),
                        //         ),
                        //       ],
                        //     ),
                        //     Wrap(
                        //       direction: Axis.vertical,
                        //       crossAxisAlignment: WrapCrossAlignment.center,
                        //       spacing: 6,
                        //       children: const [
                        //         Text("143"),
                        //         Text(
                        //           "Like",
                        //           //acessing the name property of the  MyPlatforms class
                        //           style: TextStyle(fontSize: 14, color: Colors.grey),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),


                Wrap(
                  spacing: 40,
                  children: [

                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black, //<-- SEE HERE
                      ),
                      onPressed: () {
                        NavigateRoute.gotoPage(context,ChatConversation(user: user));
                      },
                      child: const Text(
                        'Send Message',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Wrap(
                  spacing: 20,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Photos',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Videos',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Tagged',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: Center(
                        child: Container(
                          child: Text("You don't have any videos yet."),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

