import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sure_keep/All-Constants/all_constants.dart';
import 'package:sure_keep/Provider/chat-provider.dart';
import '../Models/conversation.dart';
import '../Models/user-model.dart';
import '../Provider/auth-provider.dart';
import '../Utensils/read_timestamp.dart';
import 'encrypted-chat-message.dart';
import 'package:http/http.dart' as http;

class ChatConversation extends StatefulWidget {
  final UserModel user;

  const ChatConversation({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  TextEditingController messageController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  String? currentUserId;
  String? groupChatId;


  bool? _isForeGround;


  Future<bool?> isForeGround() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isForeGround = prefs.getBool('isBackGroundMode') ?? false;
    _isForeGround = isForeGround;

    return  _isForeGround;
  }

  void read() {
    currentUserId = user!.uid;

    if (currentUserId!.compareTo(widget.user.docID.toString()) > 0) {
      groupChatId = '$currentUserId-${widget.user.docID.toString()}';
    } else {
      groupChatId = '${widget.user.docID.toString()}-$currentUserId';
    }
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, Object> dataNeedUpdate) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate).whenComplete(() => messageController.text = "");
  }


  void sendPushMessage(String token, String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA46pw8dw:APA91bH16DQMBlHChehqWl-REs6Y4pkEVqOTtME1yRgGvN-8yrQcy5uwzXDW_HbR_jK2o_sGwjTo-rWKVXkbz62nMKJN3lqrhWCrkxMN7XG4D32V3utQlgHLUvmwhAdIgnVDIkOLJRCJ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void loadFCM() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }



  void loadSend() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;



      bool isallowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isallowed) {
        //no permission of local notification
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        if (notification != null && android != null && !kIsWeb) {


          //show notification
          AwesomeNotifications().createNotification(
              content: NotificationContent( //simgple notification
                id: 123,
                channelKey: 'basic',
                //set configuration wuth key "basic"
                title: notification.title,
                body: notification.body,
                payload: {"name": "FlutterCampus"},
                autoDismissible: false,
                bigPicture: widget.user.imageUrl,
                roundedBigPicture: true

              ),

              actionButtons: [
                NotificationActionButton(
                  key: "open",
                  label: "Open File",
                ),

                NotificationActionButton(
                  key: "delete",
                  label: "Delete File",
                )
              ]
          );
        }
      }

    });


  }

  @override
  void initState() {
    super.initState();
    isForeGround();
    read();

    //loadFCM();
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {

    if(content.trim() == ""){
        Fluttertoast.showToast(
          timeInSecForIosWeb: 3,
          msg: "Enter Text Message",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER_RIGHT,
        );

    }else{
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('table-chat-conversation')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      Conversation conversation = Conversation()
        ..idTo = peerId
        ..idFrom = currentUserId
        ..messageText = content
        ..dateCreated = DateTime.now()
        ..type = type;

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, conversation.toMap());

        sendPushMessage(widget.user.token.toString(), user!.displayName.toString(),content);
        //loadSend();

      }).whenComplete(() {
        if (currentUserId == widget.user.docID.toString()) {
          return;
        }
        updateDataFirestore(
          'table-user',
          currentUserId,
          {
            'chattingWith': {
              'chattingWith': widget.user.email,
              'lastMessage': messageController.text,
              "dateLastMessage": DateTime.now(),
            }
          },
        );
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    print("Build");
    return Scaffold(
      appBar: AppBar(

        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              Spacer(),

              Hero(
                tag:  widget.user.docID.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: widget.user.imageUrl.toString(),
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // CircleAvatar(
              //   backgroundImage:
              //       NetworkImage(widget.user.imageUrl.toString()),
              //   maxRadius: 20,
              // ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      " ${widget.user.firstName}",
                    style: GoogleFonts.chakraPetch(
                textStyle: const TextStyle(color: AppColors.logoColor, letterSpacing: 2,fontSize: 16,fontWeight: FontWeight.bold),
              ),
                    ),

                    // Text(
                    //   "  Online",
                    //   style: TextStyle(
                    //       color: Colors.grey.shade600, fontSize: 10),
                    // ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[

          Expanded(child: buildListMessage()),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      autofocus: false,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
                      //onChanged: (value) {

                          //
                          // if (value.isEmpty) {
                          //   context.read<ChatProvider>().setSend(true);
                          //
                          // }else{
                          //   context.read<ChatProvider>().setSend(false);
                          // }


                      //},
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {


                                sendChatMessage(
                                    messageController.text,
                                    0,
                                    groupChatId!,
                                    currentUserId!,
                                    widget.user.docID.toString());
                              },
                              child: Icon(Icons.send,color: AppColors.logoColor,)),
                        // suffixIcon: context.watch<AuthProvider>().getAppActive != false ? InkWell(
                        //     onTap: () {
                        //
                        //       sendChatMessage(
                        //           messageController.text,
                        //           0,
                        //           groupChatId!,
                        //           currentUserId!,
                        //           widget.user.docID.toString());
                        //     },
                        //     child: Icon(Icons.send,color: AppColors.logoColor,)) :  Icon(Icons.send,color: Colors.grey,),

                        hintText: "   Write Comment",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // FloatingActionButton(
                  //   onPressed: () async {
                  //     sendChatMessage(messageController.text, 0, groupChatId!,
                  //         currentUserId!, widget.user.docID.toString());
                  //   },
                  //   child: Icon(
                  //     Icons.send,
                  //     color: Colors.white,
                  //     size: 18,
                  //   ),
                  //   backgroundColor: Colors.blue,
                  //   elevation: 0,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget buildListMessage() {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('table-chat-conversation')
          .doc(groupChatId)
          .collection(groupChatId!)
          .orderBy("dateCreated", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasData) {
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data?.docs.length,
              reverse: true,
              itemBuilder: (context, index) {
                final messageData = snapshot.data!.docs[index];

                if (context.watch<AuthProvider>().getAppActive == true &&  _isForeGround == true) {
                  return  EncryptedChatMessage(messageData: messageData, user: widget.user);
                }else{   return Container(
                  padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messageData.get('idFrom') == user!.uid
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Wrap(
                              spacing: 6,
                      children: [
                        (messageData.get('idFrom') == user!.uid
                            ? const SizedBox.shrink()
                            : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:CachedNetworkImage(
                              imageUrl: widget.user.imageUrl.toString(),
                              width: 20.0,
                              height: 20.0,
                              fit: BoxFit.cover,
                            ),)),


                        Column(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 40, maxWidth: 250),
                              child:

                              messageData.get('idFrom') == user!.uid ? Container(

                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20)
                                      ,bottomRight:  Radius.circular(20)
                                      ,bottomLeft:  Radius.circular(20)),

                                  color:  Colors.grey.shade200

                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  messageData.get('message'),

                                  style: const TextStyle(fontSize: 15),
                                ),
                              ) : Container(

                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20)
                                      ,bottomRight:  Radius.circular(20)
                                      ,bottomLeft:  Radius.circular(20)),
                                  color: Colors.blue[200],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  messageData.get('message'),

                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Text(
                              readTimestamp(
                                messageData
                                    .get('dateCreated')
                                    .millisecondsSinceEpoch,
                              ),
                              style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),

                        messageData.get('idFrom') == user!.uid ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:CachedNetworkImage(
                            imageUrl: user!.photoURL.toString(),
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),


                        ) : SizedBox.shrink(),

                      ],
                    ),
                  ),
                );}


              });
          //buildItem(index, snapshot.data?.docs[index]));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
  //   if (documentSnapshot != null) {
  //     ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
  //     if (chatMessages.idFrom == user!.uid) {
  //       // right side (my message)
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               chatMessages.type == 0
  //                   ? messageBubble(
  //                 chatContent: chatMessages.content,
  //                 color: Colors.blueGrey,
  //                 textColor: Colors.white,
  //                 margin: const EdgeInsets.only(right: 10),
  //               )
  //
  //                   : const SizedBox.shrink(),
  //                Container(
  //                 clipBehavior: Clip.hardEdge,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 child: Image.network(
  //                   "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000",
  //                   width: 40,
  //                   height:40,
  //                   fit: BoxFit.cover,
  //                   loadingBuilder: (BuildContext ctx, Widget child,
  //                       ImageChunkEvent? loadingProgress) {
  //                     if (loadingProgress == null) return child;
  //                     return Center(
  //                       child: CircularProgressIndicator(
  //                         color: Colors.grey,
  //                         value: loadingProgress.expectedTotalBytes !=
  //                             null &&
  //                             loadingProgress.expectedTotalBytes !=
  //                                 null
  //                             ? loadingProgress.cumulativeBytesLoaded /
  //                             loadingProgress.expectedTotalBytes!
  //                             : null,
  //                       ),
  //                     );
  //                   },
  //                   errorBuilder: (context, object, stackTrace) {
  //                     return const Icon(
  //                       Icons.account_circle,
  //                       size: 35,
  //                       color: Colors.grey,
  //                     );
  //                   },
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //          Container(
  //             margin: const EdgeInsets.only(
  //                 right: 50,
  //                 top: 6,
  //                 bottom: 8),
  //             child: Text(
  //               DateFormat('dd MMM yyyy, hh:mm a').format(
  //                 DateTime.fromMillisecondsSinceEpoch(
  //                   int.parse(chatMessages.timestamp),
  //                 ),
  //               ),
  //               style: const TextStyle(
  //                   color: Colors.grey,
  //                   fontSize: 12,
  //                   fontStyle: FontStyle.italic),
  //             ),
  //           ),
  //
  //         ],
  //       );
  //     }else{
  //       return Text("No Data");
  //     }
  //   } else {
  //     return const SizedBox.shrink();
  //   }
  // }

  Widget messageBubble(
      {required String chatContent,
      required EdgeInsetsGeometry? margin,
      Color? color,
      Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: margin,
      width: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        chatContent,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(
      {required this.peerId,
      required this.peerAvatar,
      required this.peerNickname});
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
