import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user-model.dart';
import '../Provider/chat-provider.dart';
import '../Utensils/read_timestamp.dart';
import 'chatConversation.dart';

class SetDefaultConversation extends StatefulWidget {
  const SetDefaultConversation({Key? key}) : super(key: key);

  @override
  State<SetDefaultConversation> createState() => _SetDefaultConversationState();
}

class _SetDefaultConversationState extends State<SetDefaultConversation> {
  User? user = FirebaseAuth.instance.currentUser;


  String? docId ;
  Future<String?> isAppBackGround()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('docID') ?? "";
    docId = id;

    return docId;

  }


  Stream<QuerySnapshot> getFirestoreData() {
    return FirebaseFirestore.instance
        .collection('table-user')
        .where('chattingWith.chattingWith', isEqualTo: user!.email)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    isAppBackGround();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // List<UserModel> mylist = context.watch<ChatProvider>().myList;
    // Stream<List<UserModel>> userList = context.watch<ChatProvider>().list;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Default Conversation"),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getFirestoreData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data?.docs.length ?? 0) > 0) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) =>
                              buildItem(context, snapshot.data?.docs[index]),
                          // separatorBuilder: (BuildContext context, int index) =>
                          //     const Divider(),
                        );
                      } else {
                        return const Center(
                          child: Text('No user found...'),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),

              // Expanded(
              //     child: StreamBuilder<List<UserModel>>(
              //         stream: userList,
              //         //context.watch<ChatProvider>().getUsers(),
              //         builder: (context, snapshot) {
              //
              //
              //
              //           if (snapshot.hasData) {
              //             return ListView.builder(
              //                 shrinkWrap: true,
              //                 itemCount: snapshot.data!.length,
              //                 itemBuilder: (context, index) {
              //
              //                   return Row(
              //                     children: [
              //                       Text(snapshot.data![index].firstName
              //                           .toString()),
              //                       InkWell(
              //                         child: Icon(Icons.favorite_outline,
              //                         color:  mylist.contains(snapshot.data[index].firstName) ? Colors.red : Colors.grey,),
              //                         onTap: (){
              //
              //                         },
              //                       ),
              //                     ],
              //                   );
              //                 }
              //
              //                 // separatorBuilder: (BuildContext context, int index) =>
              //                 //     const Divider(),
              //                 );
              //           }
              //           return Text("Error");
              //         }))
            ],
          ),
        ),
      ),
    );
  }






  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    User? user = FirebaseAuth.instance.currentUser;






    if (documentSnapshot != null) {
      UserModel userChat = UserModel.fromMap(documentSnapshot);


      if (userChat.docID == user!.uid) {
        return const SizedBox.shrink();
      } else {

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              documentSnapshot.get('imageUrl').isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        documentSnapshot.get('imageUrl'),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        loadingBuilder: (BuildContext ctx, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null),
                            );
                          }
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return const Icon(Icons.account_circle, size: 50);
                        },
                      ),
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 50,
                    ),
              Text(
                '   ${documentSnapshot.get('firstName')}',
                style: const TextStyle(color: Colors.black),
              ),
              Spacer(),
              Radio<String>(
                groupValue: documentSnapshot.get('docID'),
                value:   docId.toString() ,
                onChanged: (value) async{


                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  setState(() {

                    docId = documentSnapshot.get('docID');

                    context.read<ChatProvider>().setRadioButton(documentSnapshot.get('docID'));

                    prefs.setString('docID', docId!);
                    print(  documentSnapshot.get('docID'));
                  });

                },
              ),
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
