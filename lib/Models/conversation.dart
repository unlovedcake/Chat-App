import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String? idFrom;
  String? idTo;
  String? messageText;
  Map? user;
  DateTime? dateCreated;
  int? type;

  Conversation(
      {this.idFrom,
      this.idTo,
      this.messageText,
      this.user,
      this.dateCreated,
      this.type});

  // receiving data from server
  factory Conversation.fromMap(map) {
    return Conversation(
      idFrom: map['idFrom'],
      idTo: map['idTo'],
      messageText: map['message'],
      dateCreated: map['dateCreated'],
      type: map['type'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'message': messageText,
      'dateCreated': dateCreated,
      'type': type,
    };
  }

  factory  Conversation.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc}){
    return  Conversation(
      idFrom: doc.data()!["idFrom"],
      idTo: doc.data()!["idTo"],
      messageText: doc.data()!["message"],
      dateCreated: doc.data()!["dateCreated"],
      type: doc.data()!["type"],
    );
  }
}
