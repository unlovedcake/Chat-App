import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sure_keep/Pages/Profile/profile-screen.dart';
import 'package:sure_keep/Pages/search-user/search-user-found.dart';

import '../../All-Constants/color_constants.dart';
import '../../Models/user-model.dart';
import '../../Router/navigate-route.dart';

class MyPlatforms {
  String name;
  Widget icon;

  MyPlatforms({required this.icon, required this.name});
}

//A MyPlatforms list created using that modal
final List<MyPlatforms> myPlatformsList = [
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.payment,
            size: 40,
            color: Colors.orange,
          ),
          Text(
            "Buy Prepaid Load",
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
      name: "Buy Prepaid Load"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.payments,
            size: 40,
            color: Colors.red,
          ),
          Text(
            "Pay Bills",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
      name: "Pay Bills"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.description,
            size: 40,
            color: Colors.yellow,
          ),
          Text(
            "Buy GK Vouchers",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          )
        ],
      ),
      name: "Buy GK Vouchers"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.business_center,
            size: 40,
            color: Colors.blueGrey,
          ),
          Text(
            "GK Negosyo",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
      name: "GK Negosyo"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.document_scanner,
            size: 40,
            color: Colors.amber,
          ),
          Text(
            "Scan Promo Code",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          )
        ],
      ),
      name: "Scan Promo Code"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.groups,
            size: 40,
            color: Colors.cyan,
          ),
          Text(
            "CPMPC",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
      name: "CPMPC"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.smart_button,
            size: 40,
          ),
          Text(
            "Reload Smart Retail Wallet",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
      name: "Reload Smart Retail Wallet"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.water_drop,
            size: 28,
            color: Colors.lightBlueAccent,
          ),
          Text(
            "Drop Off",
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
      name: "Drop Off"),
  MyPlatforms(
      icon: Row(
        children: const [
          Icon(
            Icons.child_care,
            size: 28,
            color: Colors.amber,
          ),
          Text(
            "Refer A Friend",
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
      name: "Refer A Friend"),
];

final List<String> myList = [
  "Buy Prepaid Load",
  "Pay Bills",
  "Buy GK Vouchers",
  "GK Negosyo",
  "Scan Promo Code",
  "CPMPC",
  "Reload Smart Retail Wallet",
  "Drop Off",
  "Refer A Friend",
];

class DetailScreen extends StatelessWidget {
  final UserModel user;

  DetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: size.height,
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: "${user.imageUrl}",
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                      ),
                      Text(
                        "${user.firstName}",
                        //acessing the name property of the  MyPlatforms class
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Wrap(
                    spacing: 20,
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text("143"),
                          Text(
                            "Following",
                            //acessing the name property of the  MyPlatforms class
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text("143"),
                          Text(
                            "Followers",
                            //acessing the name property of the  MyPlatforms class
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text("143"),
                          Text(
                            "Like",
                            //acessing the name property of the  MyPlatforms class
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 40,
                    children: [
                      OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "Follow",
                            style: TextStyle(fontSize: 15),
                          )),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black, //<-- SEE HERE
                        ),
                        onPressed: () {
                          //NavigateRoute.gotoPage(context, ChatDetail(user: user));
                        },
                        child: const Text(
                          'Send',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
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
        ));
  }
}

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  static List listUsers = [];

  Future getAllUser() async {
    try {
      final res =
      await FirebaseFirestore.instance.collection("table-user").get();

      for (var doc in res.docs) {
        listUsers.add(doc.data());
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getAllUser();
    });
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("table-user")
          .orderBy('firstName', descending: false)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                final user = snapshot.data!.docs[index];

                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {

                            NavigateRoute.gotoPage(context, SearchUserFound(user:UserModel.fromMap(
                                user)));

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => DetailScreen(
                            //           user: UserModel.fromMap(
                            //               user), //pass the index of the MyPlatforms list
                            //         )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Hero(
                                    tag:  user.get('docID'),
                                    child: CachedNetworkImage(
                                      imageUrl:  user.get('imageUrl'),
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text('   ${ user.get('firstName',)}'
                                 ,
                                    style: GoogleFonts.assistant(
                                    textStyle: const TextStyle(color: AppColors.logoColor, letterSpacing: 1,fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]);
              });
        } else {
          return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ));
        }
      },
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(
    //       "Search",
    //     ),
    //     // actions: [
    //     //   IconButton(
    //     //     onPressed: () {
    //     //       // method to show the search bar
    //     //       showSearch(
    //     //           context: context,
    //     //           // delegate to customize the search bar
    //     //           delegate: CustomSearchDelegate());
    //     //     },
    //     //     icon: const Icon(Icons.search),
    //     //   )
    //     // ],
    //   ),
    //
    //   body: StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection("table-user").snapshots(),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
    //       if (snapshot.hasData) {
    //         return ListView.builder(
    //             itemCount: snapshot.data?.docs.length,
    //             itemBuilder: (context, index) {
    //               final user = snapshot.data!.docs[index];
    //
    //               return Column(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: InkWell(
    //                         onTap: () {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => DetailScreen(
    //                                     user: UserModel.fromMap(
    //                                         user), //pass the index of the MyPlatforms list
    //                                   )));
    //                         },
    //                         child: Card(
    //                           child: Row(
    //                             children: [
    //                               CircleAvatar(
    //                                   backgroundColor: Colors.transparent,
    //                                   radius: 30,
    //                                   child: Image.network(
    //                                     user.get('imageUrl'),
    //                                     width: 20,
    //                                     height: 20,
    //                                   )),
    //                               Text(
    //                                 user.get('firstName'),
    //                                 style: TextStyle(
    //                                   fontSize: 12,
    //                                 ),
    //                                 textAlign: TextAlign.center,
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ]);
    //             });
    //       } else {
    //         return const Center(
    //             child: CircularProgressIndicator(
    //               color: Colors.black,
    //             ));
    //       }
    //     },
    //   ),
    //   // body:  SearchListView(),
    // );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("table-user").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
        if (!snapshot.hasData) return Center(child: new Text('No Found...'));

        final results =
        snapshot.data?.docs.where((a) => a['firstName'].contains(query));

        return ListView(
          children: results!.map<Widget>((a) => Text(a['firstName'])).toList(),
        );
      },
    );
    // List searchQuery = [];
    //
    // for(int i=0; i < _SearchUserState.listUsers.length ; i++){
    //
    //
    //   if (_SearchUserState.listUsers[i]['firstName'].toLowerCase().contains(query.toLowerCase())) {
    //     searchQuery.addAll(_SearchUserState.listUsers);
    //   }
    // }

    // return ListView.builder(
    //   itemCount: searchQuery.length,
    //   itemBuilder: (context, index) {
    //
    //     return ListTile(
    //       leading: CircleAvatar(radius: 20, child: Image.network(searchQuery[index]['imageUrl'],width: 10,height: 10,)),
    //       title: Text(searchQuery[index]['firstName']),
    //     );
    //   },
    // );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("table-user").
      snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
        if (!snapshot.hasData) return Center(child: new Text('No Found...'));

        final results = snapshot.data?.docs.where(
                (a) => a['firstName'].toLowerCase().contains(query.toLowerCase()));

        if (query.isEmpty) {
          return Center(child: Text("Search Name"));
        }else  if (results!.isEmpty) {
          return Center(child: new Text('No Found...'));
        }

        return ListView(
          children: results
              .map<Widget>((a) => InkWell(
            onTap: () {

              NavigateRoute.gotoPage(context, SearchUserFound(user:UserModel.fromMap(a
                             .data())));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => DetailScreen(
              //           user: UserModel.fromMap(a
              //               .data()), //pass the index of the MyPlatforms list
              //         )));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Hero(
                      tag:  a['docID'],
                      child: CachedNetworkImage(
                        imageUrl: a['imageUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),


                  Text("  ${a['firstName']}",               style: GoogleFonts.acme(
                    textStyle: const TextStyle(color: AppColors.logoColor, letterSpacing: 5,fontSize: 12,fontWeight: FontWeight.bold),
                  ),),
                ],
              ),
            ),
          ))
              .toList(),
        );
      },
    );

    // List searchQuery = [];
    //
    //
    // for(int i=0; i < _SearchUserState.listUsers.length ; i++){
    //
    //
    //   if (_SearchUserState.listUsers[i]['firstName'].toLowerCase().contains(query.toLowerCase())) {
    //     searchQuery.add(_SearchUserState.listUsers);
    //   }
    // }
    //
    // return ListView.builder(
    //   itemCount: _SearchUserState.listUsers.length,
    //   itemBuilder: (context, index) {
    //     return Text(_SearchUserState.listUsers[index]['firstName']);
    //   }
    // );
    // return ListView.builder(
    //   itemBuilder: (context, index) => ListTile(
    //     onTap: () {
    //       close(context,  searchQuery[index]);
    //
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => DetailScreen(
    //                 item:  searchQuery[index], //pass the index of the MyPlatforms list
    //               )));
    //     },
    //
    //     title: Column(
    //       children: [
    //         CircleAvatar(radius: 20, child: Image.network(searchQuery[index]['imageUrl'],width: 10,height: 10,)),
    //         Text(searchQuery[index]['firstName']),
    //       ],
    //     ),
    //   ),
    //   itemCount:   searchQuery.length,
    // );
  }
}
