import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/user-model.dart';

class DefaultFakeConversation extends StatefulWidget {

  final UserModel user;
  const DefaultFakeConversation({required this.user,Key? key}) : super(key: key);

  @override
  State<DefaultFakeConversation> createState() => _DefaultFakeConversationState();
}

class _DefaultFakeConversationState extends State<DefaultFakeConversation> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello,", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey , I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
    ChatMessage(messageContent: "No, dont worry, I can handle this.", messageType: "receiver"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(widget.user.imageUrl.toString()),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.user.firstName}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType == "receiver"
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
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
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextFormField(

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
                        suffixIcon:   Icon(Icons.send,color: Colors.grey,),
                        // suffixIcon:  context.watch<ChatProvider>().getSend == false ? InkWell(
                        //     onTap: () {
                        //       sendChatMessage(
                        //           messageController.text,
                        //           0,
                        //           groupChatId!,
                        //           currentUserId!,
                        //           widget.user.docID.toString());
                        //     },
                        //     child: Icon(Icons.send,color: AppColors.logoColor,)) : Icon(Icons.send,color: Colors.grey,),
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
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}