import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/FireStoreConstants.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_dashboard_controller.dart';
import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:champcash/shared/extras.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../Data/fr_constants.dart';

class ConversionView extends StatefulWidget {
  final int type;
  final String peerId, nickName, photoUrl;

  const ConversionView({
    Key? key,
    required this.peerId,
    required this.nickName,
    required this.photoUrl,
    this.type = 0,
  }) : super(key: key);

  @override
  State<ConversionView> createState() => _ConversionViewState();
}

class _ConversionViewState extends State<ConversionView> {
  var editConversionSendController = TextEditingController();
  RxList<QueryDocumentSnapshot> conversionList = <QueryDocumentSnapshot>[].obs;
  var editOfferController = TextEditingController();
  var editTextEditOfferController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? uniqueKey;

  int noOfUnRead = 1;

  bool goodOffer = true;
  String offerLabel = "Very good offer! ";

  bool isBlocked = false;

  @override
  void initState() {
    super.initState();
    //onInit1();
    String tblUserId = userLoginModel!.data.userId.toString();
    print('tblUserId => $tblUserId, peerId => ${widget.peerId}');
    firebaseUserBlockListner();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backPressed(context),
      child: Scaffold(
        backgroundColor: ColorConstants.appPrimaryBlackColor,
        body: SafeArea(
            child: Column(
          children: [
            addPadding(0, 15),
            Row(
              children: [
                SABackButton(
                    onPressed: () {
                      Get.back();
                    },
                    color: ColorConstants.APPPRIMARYWHITECOLOR),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(2, 3),
                                blurRadius: 5,
                                color: Colors.grey)
                          ],
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                              width: 1, color: const Color(0xff3E57B4))),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipOval(
                            child: Image.network(
                          widget.photoUrl,
                          fit: BoxFit.cover,
                        )),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: headingText(
                          title: widget.nickName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorConstants.APPPRIMARYWHITECOLOR),
                    ),
                    /*      Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 2),
                      child: headingText(
                          title: "Online",
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xff8BCF52)),
                    ),*/
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 0, bottom: 0),
                  child: IconButton(
                    onPressed: () {
                      blockBottomSheetUI();
                    },
                    icon: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.more_horiz,
                          color: ColorConstants.APPPRIMARYWHITECOLOR,
                        )),
                  ),
                )
              ],
            ),
            addPadding(0, 15),
            Expanded(
                child: Column(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    addPadding(0, 15),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: StreamBuilder(
                            //controller: scrollController,
                            // scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            stream: FirebaseDatabase.instance
                                .ref()
                                .child("User_Messages")
                                .child(userLoginModel!.data.userId.toString())
                                .child(widget.peerId.toString())
                                .onValue,
                            builder: (BuildContext context,
                                AsyncSnapshot<DatabaseEvent> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return GIFLaaderPage();
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("No Conversation yet"));
                              } else if (snapshot.hasData) {
                                Map<dynamic, dynamic>? map =
                                    snapshot.data!.snapshot.value as Map?;

                                List<dynamic> conList = map == null
                                    ? []
                                    : map!.values.toList()
                                  ..sort((a, b) =>
                                      b[FireBaseConstants.conVotime].compareTo(
                                          a[FireBaseConstants.conVotime]));
                                return ListView.builder(
                                    reverse: true,
                                    itemCount: conList.length ?? 0,
                                    itemBuilder: (c, pos) {
                                      return conList[pos][
                                                  FireStoreConstants.attachment]
                                              .toString()
                                              .isNotEmpty
                                          ? attachmentView(conList, pos)
                                          : userConversionUI(conList, pos);
                                    });
                              }
                              return GIFLaaderPage();
                              //  ;
                            }),
                      ),
                    ),
                    addPadding(0, 15),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SACellRoundContainer1(
                      height: 60,
                      color: const Color(0xff2a3352),
                      child: Row(
                        children: [
                          addPadding(15, 0),
                          // const Icon(
                          //   Icons.emoji_emotions_rounded,
                          //   color: Color(0xffF1B419),
                          //   size: 30,
                          // ),
                          addPadding(10, 0),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                  color: ColorConstants.APPPRIMARYWHITECOLOR),
                              controller: editConversionSendController,
                              decoration: InputDecoration(
                                  hintText: "Type your message...",
                                  hintStyle: GoogleFonts.urbanist(
                                      color:
                                          ColorConstants.APPPRIMARYWHITECOLOR,
                                      fontSize: 13),
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            child: const Icon(
                              Icons.attach_file,
                              size: 25,
                              color: ColorConstants.appPrimaryWhiteColor,
                            ),
                            onTap: () {
                              ImagePicker.platform
                                  .pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                File file = File(value!.path);
                                // uploadUserProfileIMageAPIs(file);
                                sendAttachment(file);
                              });
                            },
                          ),
                          addPadding(10, 0),
                          GestureDetector(
                            onTap: () {
                              ImagePicker.platform
                                  .pickImage(source: ImageSource.camera)
                                  .then((value) {
                                File file = File(value!.path);
                                // uploadUserProfileIMageAPIs(file);
                                sendAttachment(file);
                              });
                            },
                            child: const Icon(Icons.camera_alt,
                                size: 25,
                                color: ColorConstants.appPrimaryWhiteColor),
                          ),
                          addPadding(10, 0),

                          //Button Send UI
                          GestureDetector(
                            onTap: () {
                              onSendMessage(
                                  editConversionSendController.text, "No");
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color(0xff54ba8b),
                                        Color(0xff54ba8b),
                                        Color(0xff54ba8b),
                                        Color(0xff54ba8b),
                                      ]),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                  child: Icon(
                                Icons.send,
                                color: ColorConstants.APPPRIMARYWHITECOLOR,
                                size: 18,
                              )),
                            ),
                          ),
                          addPadding(10, 0),
                        ],
                      ),
                      radius: 35,
                      borderWidth: 0,
                      borderWidthColor: Colors.transparent),
                )
              ],
            )),
          ],
        )),
      ),
    );
  }

  void sendAttachment(File file) {
    Get.to(SendAttachment(file: file))?.then((value) {
      if (value != null) {
        onSendMessage('Attachment', "No", attachment: value);
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  firebaseUserBlockListner() {
    FirebaseFirestore.instance
        .collection(FireBaseConstants.pathUserCollection)
        .doc(userLoginModel!.data.userId.toString())
        .collection(FireBaseConstants.allChat)
        .doc(widget.peerId)
        .snapshots()
        .listen((event) {
      setState(() {
        isBlocked = !event.get(FireBaseConstants.isActive);
        print(
            "VALuuuueee$isBlocked  ${userLoginModel!.data.userId.toString()}  ${widget.peerId}");
      });
    });
    FirebaseFirestore.instance
        .collection(FireStoreConstants.pathUserCollection)
        .doc(userLoginModel!.data.userId.toString())
        .collection(FireBaseConstants.allChat)
        .doc(widget.peerId)
        .update({FireStoreConstants.noOfUnRead: 0});
  }

  userConversionUI(List conList, int pos) {
    if (conList[pos][FireBaseConstants.idFrom].toString() ==
        userLoginModel!.data.userId.toString()) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addPadding(60, 0),
            headingText(
                title: DateFormat('hh:mm aa').format(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(
                        conList[pos][FireBaseConstants.conVotime].toString()))),
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: ColorConstants.appPrimaryWhiteColor),
            addPadding(15, 0),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorConstants.appPrimaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: headingFullText(
                    title: conList[pos][FireBaseConstants.message].toString(),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: ColorConstants.APPPRIMARYWHITECOLOR),
              ),
            )),
            addPadding(15, 0),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: ColorConstants.APPPRIMARYWHITECOLOR,
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(2, 3),
                          blurRadius: 5,
                          color: Colors.grey)
                    ],
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: ClipOval(
                      child: Image.network(
                    conList[pos][FireBaseConstants.userImage].toString(),
                    fit: BoxFit.fitHeight,
                  )),
                ),
              ),
            ),
            addPadding(15, 0),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xff323856),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: headingFullText(
                    title: conList[pos][FireBaseConstants.message].toString(),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: ColorConstants.APPPRIMARYWHITECOLOR),
              ),
            )),
            addPadding(15, 0),
            headingText(
                title: DateFormat('hh:mm aa').format(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(
                        conList[pos][FireBaseConstants.conVotime].toString()))),
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: ColorConstants.APPPRIMARYWHITECOLOR),
            addPadding(15, 0),
          ],
        ),
      );
    }
  }

  Future<void> onSendMessage(String text, String offer,
      {String attachment = ""}) async {
    //Id

    if (isBlocked) {
      // EasyLoading.showToast('this user is  blocked');
      showErrorBottomSheet("This user is blocked");
      return;
    }

    if (text.trim().isNotEmpty) {
      editConversionSendController.clear();
      final DatabaseReference userReference =
          FirebaseDatabase.instance.ref().child("UserConversion");
      DatabaseReference ref = userReference
          .child(userLoginModel!.data.userId.toString())
          .child(widget.peerId!)
          .push();
      uniqueKey = ref.key!;
      Map<dynamic, dynamic> userMap = {
        FireBaseConstants.message: text.toString(),
        FireBaseConstants.conVotime:
            DateTime.now().millisecondsSinceEpoch.toString(),
        FireBaseConstants.messageId: uniqueKey.toString(),
        FireStoreConstants.attachment: attachment,
        FireBaseConstants.userImage: userLoginModel!.data.userImage,
        FireBaseConstants.isActive: true,
        FireBaseConstants.idFrom: userLoginModel!.data.userId.toString(),
      };
      Map<dynamic, dynamic> peerMap = {
        FireBaseConstants.message: text.toString(),
        FireBaseConstants.conVotime:
            DateTime.now().millisecondsSinceEpoch.toString(),
        FireBaseConstants.messageId: uniqueKey.toString(),
        FireBaseConstants.isActive: true,
        FireBaseConstants.userImage: userLoginModel!.data.userImage,
        FireStoreConstants.attachment: attachment,
        FireBaseConstants.idFrom: userLoginModel!.data.userId.toString(),
      };

      Map<String, dynamic> childrenPathValueMap = {};

      childrenPathValueMap[
              "User_Messages/${userLoginModel!.data.userId.toString()}/${widget.peerId}/$uniqueKey"] =
          userMap;
      childrenPathValueMap[
              "User_Messages/${widget.peerId}/${userLoginModel!.data.userId.toString()}/$uniqueKey"] =
          peerMap;
      FirebaseDatabase.instance
          .reference()
          .update(childrenPathValueMap)
          .whenComplete(() {
        updateLastConversion(text, attachment);
        // onInit1();
      });
    }
  }

  void updateLastConversion(String content, String attachment) {
    _db
        .collection(FireBaseConstants.pathUserCollection)
        .doc(userLoginModel!.data.userId.toString())
        .collection(FireBaseConstants.allChat)
        .doc(widget.peerId)
        .set({
      FireBaseConstants.message: content,
      FireBaseConstants.timeStamp:
          DateTime.now().millisecondsSinceEpoch.toString(),
      FireBaseConstants.userImage: widget.photoUrl,
      FireBaseConstants.userName: widget.nickName,
      FireBaseConstants.peerId: widget.peerId,
      FireBaseConstants.isActive: true,
    }).whenComplete(() {
      _db
          .collection(FireBaseConstants.pathUserCollection)
          .doc(widget.peerId)
          .collection(FireBaseConstants.allChat)
          .doc(userLoginModel!.data.userId.toString())
          .set({
        FireBaseConstants.message: content,
        FireBaseConstants.timeStamp:
            DateTime.now().millisecondsSinceEpoch.toString(),
        FireBaseConstants.isActive: true,
        FireBaseConstants.userImage: userLoginModel!.data.userImage,
        FireBaseConstants.userName: userLoginModel!.data.userName,
        FireBaseConstants.peerId: userLoginModel!.data.userId,
        FireStoreConstants.noOfUnRead: noOfUnRead++,
      });
    });
    chatNotificationAPIs({
      "user_id": widget.peerId,
      "message": attachment == "" ? content : "Attachment"
    }).then((value) {});
  }

  Widget attachmentView(List conList, int pos) {
    return Row(
      children: [
        if (conList[pos][FireBaseConstants.idFrom].toString() ==
            userLoginModel!.data.userId.toString())
          const Spacer(),
        if (conList[pos][FireBaseConstants.idFrom].toString() ==
            userLoginModel!.data.userId.toString())
          headingText(
              title: DateFormat('hh:mm aa').format(
                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                      conList[pos][FireBaseConstants.conVotime].toString()))),
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.80)),
        GestureDetector(
          onTap: () {
            Get.to(SendAttachment(
              file:
                  File(conList[pos][FireStoreConstants.attachment].toString()),
              showing: true,
            ))?.then((value) {
              // scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
            });
          },
          child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: const Color(0xffC5C5C5).withOpacity(0.25),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: CachedNetworkImage(
                imageUrl:
                    conList[pos][FireStoreConstants.attachment].toString(),
                fit: BoxFit.contain,
              )),
        ),
        if (conList[pos][FireBaseConstants.idFrom].toString() !=
            userLoginModel!.data.userId.toString())
          headingText(
              title: DateFormat('hh:mm aa').format(
                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                      conList[pos][FireBaseConstants.conVotime].toString()))),
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.80)),
      ],
      // Image.network(snapshot.child(FireStoreConstants.attachment).value.toString())
    );
  }

  // void onInit1() {
  //   _db
  //       .collection(FireStoreConstants.pathUserCollection)
  //       .doc(userLoginModel!.data.userId.toString())
  //       .collection("allChat")
  //       .doc(widget.tblAdsId)
  //       .update({FireStoreConstants.noOfUnRead: 0}).whenComplete(() {
  //     _db
  //         .collection(FireStoreConstants.pathUserCollection)
  //         .doc(widget.peerId)
  //         .collection("allChat")
  //         .doc(widget.tblAdsId)
  //         .update({FireStoreConstants.noOfUnRead: 0});
  //   });
  // }

  _backPressed(BuildContext context) {
    // onInit1();
    Get.back();
  }

  blockBottomSheetUI() {
    Get.bottomSheet(Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ColorConstants.appPrimaryWhiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              children: [
                addPadding(25, 15),
                headingText(
                    title: "Are you sure you want to block?",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.appPrimarylightBlackColor),
                addPadding(15, 0),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20),
                ),
                addPadding(17, 0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SACellRoundContainer(
                                height: 45,
                                width: 120,
                                color: const Color(0xffffffff),
                                child: Center(
                                  child: headingText(
                                      title: "Cancel",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          ColorConstants.appPrimaryBlackColor),
                                ),
                                radius: 15,
                                borderWidth: 0,
                                borderWidthColor: Colors.transparent),
                          ),
                        ),
                        Expanded(
                          child: GradientButton1(
                              height: 45,
                              text: "Block",
                              onPressed: () {
                                userBlockAPIs();
                              }),
                        )
                      ],
                    ),
                  ),
                ),
                addPadding(15, 0),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void userBlockAPIs() {
    //  params.put("user_id", sessionManager.getUserDeatail().getUser_id() + "");
    //                 params.put("type", "block");
    //                 params.put("blocked_user_id", from_key);
    //                 params.put("report_msg", "Block from my end");
    //                 Log.e("newpar", params + "");
    userBlockAPI({
      "user_id": userLoginModel!.data.userId.toString(),
      "type": "block",
      "blocked_user_id": widget.peerId,
      "report_msg": "Block from my end"
    }).then((value) {
      if (value.status) {
        Get.back();
        toastMessage(value.message == "User blocked."
            ? "User blocked successfully"
            : value.message);
        Get.find<SADashboardController>()
            .callingUserBlocked(widget.peerId ?? "-1");
      } else {
        showErrorBottomSheet(value.message);
      }
    });
  }
}

class SendAttachment extends StatelessWidget {
  final File file;
  final bool showing;

  const SendAttachment({super.key, required this.file, this.showing = false});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: showing
                  ? CachedNetworkImage(
                      imageUrl: file.path,
                    )
                  : Image.file(file)),
          Positioned(
              top: 60,
              left: 0,
              child: IconButton(
                  onPressed: () => Get.back(), icon: const Icon(Icons.cancel)))
        ],
      ),
      floatingActionButton: !showing
          ? FloatingActionButton(
              onPressed: () {
                uploadChatImageAPI(file).then((value) {
                  if (value.status) {
                    toastMessage(value.message.toString());
                    Map data = value.data;
                    Get.back(result: data['URL']);
                  } else {
                    showErrorBottomSheet(value.message.toString());
                  }
                });
              },
              child: const Icon(Icons.send),
            )
          : null,
    );
  }
}
