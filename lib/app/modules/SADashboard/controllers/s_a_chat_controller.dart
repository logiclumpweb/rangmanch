import 'package:champcash/Data/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Data/fr_constants.dart';

class SAChatController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final textSearch = "".obs;
  final ediTextSeachController = TextEditingController().obs;

  Stream<QuerySnapshot> getChatForFireStore(String pathCollection, int limit) {
    print("UUUUSSSSS" + userLoginModel!.data.userId);
    return firebaseFirestore
        .collection(pathCollection)
        .doc(userLoginModel!.data.userId)
        .collection(FireBaseConstants.allChat)
        .limit(100)
        .snapshots();
  }
}
