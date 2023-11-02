


import 'package:cloud_firestore/cloud_firestore.dart';

import '../Data/FireStoreConstants.dart';


class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;


  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,

  });

  Map<String, dynamic> toJson() {
    return {
      FireStoreConstants.idFrom: this.idFrom,
      FireStoreConstants.idTo: this.idTo,
      FireStoreConstants.timestamp: this.timestamp,
      FireStoreConstants.content: this.content,
      FireStoreConstants.type: this.type,

    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FireStoreConstants.idFrom);
    String idTo = doc.get(FireStoreConstants.idTo);
    String timestamp = doc.get(FireStoreConstants.timestamp);
    String content = doc.get(FireStoreConstants.content);
    int type = doc.get(FireStoreConstants.type);

    return MessageChat(idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content, type: type);
  }
}






class Convo {

  String timestamp;
  String content;
  String idFrom;



  Convo({

    required this.timestamp,
    required this.content,
    required this.idFrom


  });

  Map<String, dynamic> toJson() {
    return {

      FireStoreConstants.timestamp: this.timestamp,
      FireStoreConstants.content: this.content,
      FireStoreConstants.idFrom:this.idFrom

    };
  }

  factory Convo.fromDocument(DocumentSnapshot doc) {

    String timestamp = doc.get(FireStoreConstants.timestamp);
    String content = doc.get(FireStoreConstants.content);
    String idFrom=doc.get(FireStoreConstants.idFrom);


    return Convo(timestamp: timestamp, content: content,idFrom: idFrom);
  }
}
