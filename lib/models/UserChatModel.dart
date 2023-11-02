import 'package:champcash/shared/extras.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Data/FireStoreConstants.dart';
import '../Data/fr_constants.dart';

class UserChatModel {
  String id;
  String photoUrl;
  String nickname;
  String aboutMe;
  String tblUserId;
  String content;
  String timeStamp;
  String idTo;
  int noOfUnRead;

  UserChatModel(
      {required this.id,
      required this.photoUrl,
      required this.nickname,
      required this.aboutMe,
      required this.tblUserId,
      required this.content,
      required this.timeStamp,
      required this.idTo,
      required this.noOfUnRead});

  Map<String, String> toJson() {
    return {
      FireStoreConstants.nickname: nickname,
      FireStoreConstants.aboutMe: aboutMe,
      FireStoreConstants.photoUrl: photoUrl,
      FireStoreConstants.tblUserId: tblUserId,
      FireStoreConstants.content: FireStoreConstants.content,
      FireStoreConstants.idTo: idTo
    };
  }

  factory UserChatModel.fromDocument(DocumentSnapshot doc) {
    String aboutMe = "";
    String photoUrl = "";
    String nickname = "";
    String tblUserId = "";
    String content = "null";
    String timeStamp = "null";
    String idTo = "";
    int noOfUnRead = 0;
    try {
      aboutMe = doc.get(FireStoreConstants.aboutMe);
    } catch (e) {}
    try {
      photoUrl = doc.get(FireStoreConstants.photoUrl);
    } catch (e) {}
    try {
      nickname = doc.get(FireStoreConstants.nickname);
    } catch (e) {}
    try {
      tblUserId = doc.get(FireStoreConstants.tblUserId);
    } catch (e) {}
    try {
      content = doc.get(FireStoreConstants.content);
      idTo = doc.get(FireStoreConstants.idTo);
      timeStamp = doc.get(FireStoreConstants.timestamp);
      noOfUnRead = doc.get(FireStoreConstants.noOfUnRead);
    } catch (e) {}
    return UserChatModel(
        id: doc.id,
        photoUrl: photoUrl,
        nickname: nickname,
        aboutMe: aboutMe,
        tblUserId: tblUserId,
        content: content,
        timeStamp: timeStamp,
        idTo: idTo,
        noOfUnRead: noOfUnRead);
  }
}

class ConVoModel {
  String peerId;
  String message;
  String isActive;
  String messageId;
  String timeStamp;
  String userImage;
  String userName;
  // int noOfUnRead;

  ConVoModel({
    required this.peerId,
    required this.message,
    required this.isActive,
    required this.messageId,
    required this.timeStamp,
    required this.userImage,
    required this.userName,
    // required this.noOfUnRead
  });

  Map<String, String> toJson() {
    return {
      FireBaseConstants.peerId: peerId,
      FireBaseConstants.message: message,
      FireBaseConstants.messageId: messageId,
      FireBaseConstants.isActive: isActive,
      FireBaseConstants.timeStamp: timeStamp,
      FireBaseConstants.userImage: userImage,
      FireBaseConstants.userName: userName,

    };
  }

  factory ConVoModel.fromDocument(DocumentSnapshot doc) {
    String peerId = "";
    String message = "";
    String isActive = "";
    String messageId = "";
    String timeStamp = "";
    String userImage = "";
    String userName = "";

    try {
      peerId = doc.get(FireBaseConstants.peerId);
      message = doc.get(FireBaseConstants.message);
      messageId = doc.get(FireBaseConstants.messageId);
      timeStamp = doc.get(FireBaseConstants.timeStamp);
      userImage = doc.get(FireBaseConstants.userImage);
      userName = doc.get(FireBaseConstants.userName);
    } catch (e) {}
    return ConVoModel(
        peerId: peerId,
        message: message,
        isActive: isActive,
        messageId: messageId,
        timeStamp: timeStamp,
        userImage: userImage,
        userName: userName);
  }
}
