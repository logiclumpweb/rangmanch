
import 'package:champcash/ARGear/controllers/ar_gear_controller.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/View/PackageListScreen.dart';
import 'package:champcash/View/PackageTransactionScreen.dart';
import 'package:champcash/View/UsersBlcokListScreen.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Apis/api.dart';
import '../Routes/AppRoutes.dart';
import '../Auth/UpdateProfileDetailView.dart';
import '../View/BadgesListView.dart';
import '../View/BankDetailsUpdateView.dart';
import '../View/ChangePasswordView.dart';
import '../View/LevelBonusView.dart';
import '../View/OrderTransationHistoryPage.dart';
import '../View/ReferAndEarnView.dart';
import '../View/WithdrawalHistoryView.dart';
import '../shared/extras.dart';
import '../Auth/login.dart';
import '../models/GetProfileDataModel.dart';
import '../Apis/urls.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  var editReasonController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileDetailAPIs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
        appBar: appBarUI(),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: userProfileModel == null
                ? const Center(
                    child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: ColorConstants.appPrimaryColor,
                  ))
                : myActionAccountUI()));
  }

  myActionAccountUI() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          MyListTile(
            onTap: () {
              Get.to(const UpdateProfileDetailView(
                type: "Profile",
                Id: "",
              ));
            },
            title: 'Update Profile',
            assetImage: updateProfile,
          ),

          ListTile(
            onTap: () {
              Get.to(const PackageTransactionScreen());
            },
            title: Text(
              'Wallet',
              style: textStyleW600(
                  fontSize: 16, color: ColorConstants.APPPRIMARYWHITECOLOR),
            ),
            leading: const SizedBox(
                width: 25, child: AssetImageView(img: walletIcon)),
            trailing: SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.diamond,
                    color: Colors.amber,
                    size: 15,
                  ),
                  addPadding(5, 0),
                  Text(
                    userProfileModel!.data.tokenWallet,
                    style: textStyleW600(
                        fontSize: 14,
                        color: ColorConstants.APPPRIMARYWHITECOLOR),
                  ),
                  addPadding(8, 0),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: ColorConstants.appPrimaryWhiteColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ).paddingAll(8),

          ListTile(
            onTap: () {
              Get.to(const UsersBlockListScreen());
            },
            title: Text(
              'Users Block List',
              style: textStyleW600(
                  fontSize: 16, color: ColorConstants.APPPRIMARYWHITECOLOR),
            ),
            leading: Icon(Icons.block,
                color: ColorConstants.APPPRIMARYWHITECOLOR, size: 25),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: ColorConstants.appPrimaryWhiteColor,
              size: 18,
            ),
          ).paddingAll(8),
          MyListTile(
            onTap: () {
              Get.to(const PackageListScreen());
            },
            title: 'Buy Coins',
            assetImage: "assets/orderfulfillment.png",
          ),
          // MyListTile(
          //   onTap: () {
          //     Get.to(const ReferEarn());
          //   },
          //   title: "Invite",
          //   assetImage: refericon,
          // ),
          // MyListTile(
          //   onTap: () {
          //     Get.to(const ChangePasswordView());
          //   },
          //   title: "Change Password",
          //   assetImage: changepassword,
          // ),
          MyListTile(
            onTap: () {
              Get.to(const AboutUsView());
            },
            title: "Help & Support",
            assetImage: levelImg,
          ),
          MyListTile(
            onTap: () {
              deleteProfileDialogUI();
            },
            title: "Delete My Account",
            assetImage: deleteaccount,
          ),
          MyListTile(
            onTap: () {
              logoutDialogUI();
            },
            title: "Logout",
            assetImage: logouticon,
          ),
          addPadding(0, 30)
        ],
      ),
    );
  }

  void settingDialogUI() {
    Get.bottomSheet(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              addPadding(0, 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  headingText(
                      title: "Settings",
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: const Color(0xff262626)),
                  addPadding(120, 0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              color: ColorConstants.APPPRIMARYWHITECOLOR,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(2, 3),
                                    blurRadius: 4,
                                    color: Colors.grey.withOpacity(0.8))
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addPadding(0, 10),
              GestureDetector(
                onTap: () {
                  changeLanguageDialogUI();
                },
                child: SizedBox(
                  child: Row(
                    children: [
                      addPadding(30, 0),
                      Image.asset(
                        lanunageImg,
                        height: 25,
                        width: 25,
                        color: const Color(0xff3E57B4),
                      ),
                      addPadding(15, 0),
                      headingText(
                          title: "Change app language",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: const Color(0xff434343)),
                    ],
                  ),
                ),
              ),
              addPadding(0, 25),
              Row(
                children: [
                  addPadding(30, 0),
                  Image.asset(
                    notificationImg,
                    height: 25,
                    width: 25,
                    color: const Color(0xff3E57B4),
                  ),
                  addPadding(15, 0),
                  headingText(
                      title: "Switch on notifications for new ads",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: const Color(0xff434343)),
                ],
              ),
              addPadding(0, 25),
              GestureDetector(
                onTap: () {
                  deactivateProfileDialogUI();
                },
                child: SizedBox(
                  child: Row(
                    children: [
                      addPadding(30, 0),
                      Image.asset(
                        deactiviedImg,
                        height: 25,
                        width: 25,
                        color: const Color(0xff3E57B4),
                      ),
                      addPadding(15, 0),
                      headingText(
                          title: "Deactivate profile",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: const Color(0xff434343)),
                    ],
                  ),
                ),
              ),
              addPadding(0, 25),
              GestureDetector(
                onTap: () {
                  deleteProfileDialogUI();
                },
                child: SizedBox(
                  child: Row(
                    children: [
                      addPadding(30, 0),
                      Image.asset(
                        userDeleteImg,
                        height: 25,
                        width: 25,
                        color: const Color(0xff3E57B4),
                      ),
                      addPadding(15, 0),
                      headingText(
                          title: "Delete profile",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: const Color(0xff434343)),
                    ],
                  ),
                ),
              ),
              addPadding(0, 20),
            ],
          ),
        )
      ],
    ));
  }

  void changeLanguageDialogUI() {
    Get.bottomSheet(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              addPadding(0, 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              color: ColorConstants.APPPRIMARYWHITECOLOR,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(2, 3),
                                    blurRadius: 4,
                                    color: Colors.grey.withOpacity(0.8))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.network(
                              cancelIconUrl,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 15, 5),
                child: Row(
                  children: [
                    headingText(
                        title: "Change language",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.APPPRIMARYBLACKCOLOR),
                    const Spacer(),
                    headingText(
                        title: "More language",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff3E57B4)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 10, 28.0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingText(
                      title: "English",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff434343)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 10, 28.0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingText(
                      title: "Mandarin",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff434343)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 10, 28.0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingText(
                      title: "Hindi",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff434343)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 10, 28.0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingText(
                      title: "Spanish",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff434343)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 10, 28.0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingText(
                      title: "French",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff434343)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 10, 28.0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: headingText(
                      title: "Arabic",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff434343)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 1,
                  color: ColorConstants.APPPRIMARYGREYCOLOR,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 28.0, left: 28, right: 28),
                child: GradientButton1(text: "SUBMIT", onPressed: () {}),
              )
            ],
          ),
        )
      ],
    ));
  }

  deactivateProfileDialogUI() {
    Get.bottomSheet(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              addPadding(0, 15),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: headingLongText(
                    title: "Are you sure you want to deactivate your profile?",
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    align: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(38.0, 0, 38, 10),
                child: headingLongText(
                    title:
                        "This will erase all of your Ads from the App. To deactivate your profile enter you password below.",
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    align: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 8, 35, 8),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Color(0xffA4A4A4),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xffCBCBCB))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xffCBCBCB))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xffCBCBCB)),
                        ),
                        contentPadding: const EdgeInsets.only(top: 0, left: 10),
                        label: headingText(title: "Password"),
                        labelStyle: GoogleFonts.inter(
                            color: Color(0xffA4A4A4),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: ColorConstants.APPPRIMARYWHITECOLOR),
                  ),
                ),
              ),
              addPadding(0, 10),
              Row(
                children: [
                  addPadding(30, 0),
                  Expanded(
                      child: GradientButton1(
                          text: "DEACTIVATE PROFILE", onPressed: () {})),
                  addPadding(10, 0),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffC5C5C5).withOpacity(0.22)),
                      child: Center(
                        child: headingText(
                            title: "CANCEL",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff262626)),
                      ),
                    ),
                  ),
                  addPadding(35, 0),
                ],
              ),
              addPadding(0, 25),
            ],
          ),
        )
      ],
    ));
  }

  deleteProfileDialogUI() {
    Get.bottomSheet(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              addPadding(0, 15),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: headingLongText(
                    title: "Are you sure you want to delete your profile?",
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    align: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(38.0, 0, 38, 10),
                child: headingLongText(
                    title:
                        "This will erase all of your Profile data with Videos from the App.",
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    align: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 8, 35, 8),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextFormField(
                    controller: editReasonController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xffCBCBCB))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: Color(0xffCBCBCB))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xffCBCBCB)),
                        ),
                        contentPadding: const EdgeInsets.only(top: 0, left: 10),
                        label: headingText(title: "Reason  (Optional)"),
                        labelStyle: GoogleFonts.inter(
                            color: Color(0xffA4A4A4),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: ColorConstants.APPPRIMARYWHITECOLOR),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ColorConstants.APPPRIMARYWHITECOLOR),
                      child: Center(
                        child: headingText(
                            title: "CANCEL",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff262626)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      deleteAccount();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: ColorConstants.appPrimaryColor),
                        child: Center(
                          child: headingText(
                              title: "SUBMIT",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.APPPRIMARYWHITECOLOR),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addPadding(35, 0),
              addPadding(0, 25),
            ],
          ),
        )
      ],
    ));
  }

  helpDialogUI() {
    Get.bottomSheet(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              addPadding(0, 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  headingText(
                      title: "Help",
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: const Color(0xff262626)),
                  addPadding(120, 0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              color: ColorConstants.APPPRIMARYWHITECOLOR,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(2, 3),
                                    blurRadius: 4,
                                    color: Colors.grey.withOpacity(0.8))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.network(
                              cancelIconUrl,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addPadding(0, 10),
              addPadding(0, 5),
              SizedBox(
                child: Row(
                  children: [
                    addPadding(30, 0),
                    Image.asset(
                      deactiviedImg,
                      height: 25,
                      width: 25,
                      color: const Color(0xff3E57B4),
                    ),
                    addPadding(15, 0),
                    headingText(
                        title: "Deactivate profile",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xff434343)),
                  ],
                ),
              ),
              addPadding(0, 25),
              SizedBox(
                child: Row(
                  children: [
                    addPadding(30, 0),
                    Image.asset(
                      userDeleteImg,
                      height: 25,
                      width: 25,
                      color: const Color(0xff3E57B4),
                    ),
                    addPadding(15, 0),
                    headingText(
                        title: "Delete profile",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xff434343)),
                  ],
                ),
              ),
              addPadding(0, 25),
              SizedBox(
                child: Row(
                  children: [
                    addPadding(30, 0),
                    Image.asset(
                      notificationImg,
                      height: 25,
                      width: 25,
                      color: const Color(0xff3E57B4),
                    ),
                    addPadding(15, 0),
                    headingText(
                        title: "Notifications",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xff434343)),
                  ],
                ),
              ),
              addPadding(0, 25),
              SizedBox(
                child: Row(
                  children: [
                    addPadding(30, 0),
                    Image.asset(
                      deactiviedImg,
                      height: 25,
                      width: 25,
                      color: const Color(0xff3E57B4),
                    ),
                    addPadding(15, 0),
                    headingText(
                        title: "Report",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xff434343)),
                  ],
                ),
              ),
              addPadding(0, 25),
              SizedBox(
                child: Row(
                  children: [
                    addPadding(30, 0),
                    const Icon(Icons.settings_outlined,
                        size: 25, color: Color(0xff3E57B4)),
                    addPadding(15, 0),
                    headingText(
                        title: "Setting",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xff434343)),
                  ],
                ),
              ),
              addPadding(0, 25),
              SizedBox(
                child: Row(
                  children: [
                    addPadding(34, 10),
                    Image.asset(
                      userProfileImg,
                      height: 18,
                      width: 18,
                      color: const Color(0xff3E57B4),
                    ),
                    addPadding(15, 0),
                    headingText(
                        title: "Profile",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xff434343)),
                  ],
                ),
              ),
              addPadding(0, 20),
            ],
          ),
        )
      ],
    ));
  }

  void logoutDialogUI() {
    Get.bottomSheet(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              addPadding(0, 15),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: headingLongText(
                    title: "Logout",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    align: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(38.0, 0, 38, 10),
                child: headingLongText(
                    title: "Are you sure you want to logout?",
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    align: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    addPadding(30, 0),
                    GradientButton1(
                        text: "SUBMIT",
                        onPressed: () {
                          Get.delete<ArGearController>(force: true);
                          setUserInfo(null).whenComplete(() {
                            Get.offAll(const Login());
                          });
                        }),
                    addPadding(0, 10),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xffC5C5C5).withOpacity(0.22)),
                        child: Center(
                          child: headingText(
                              title: "CANCEL",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff262626)),
                        ),
                      ),
                    ),
                    addPadding(35, 0),
                  ],
                ),
              ),
              addPadding(0, 25),
            ],
          ),
        )
      ],
    ));
  }

  void getProfileDetailAPIs() async {
    APIResponse response = await getProfileDetailAPI(
        {"user_id": userLoginModel!.data.userId.toString()});
    if (response.status) {
      setState(() {
        GetProfileDataModel model = response.data;
        userProfileModel = model;
      });

      if (userProfileModel != null) {}
    } else {
      showErrorBottomSheet(response.message.toString());
    }
  }

  void deleteAccount() {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "reason": editReasonController.text.trim(),
    };
    print(hashMap);
    deleteProfileAPI(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
      } else {
        showErrorBottomSheet(value.message);
      }
    });
  }

  appBarUI() {
    return AppBar(
      backgroundColor: ColorConstants.appPrimaryBlackColor,
      title: Padding(
        padding: const EdgeInsets.only(left: 60.0),
        child: headingText(title: "My Account", fontSize: 16),
      ),
      leading: Container(
        child: SABackButton(
          onPressed: () {
            Get.back();
          },
          color: ColorConstants.APPPRIMARYWHITECOLOR,
        ),
      ),
    );
  }
}

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      body: Container(
          width: double.infinity,
          child: Column(children: [
            iAPPBARUI(),
            addPadding(0, 15),
            SizedBox(
              height: 100,
              child: Image.asset(
                support,
                width: 400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: headingFullText(
                  title: "For any query and help \n please contact us on",
                  align: TextAlign.center,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: headingFullText(
                  title: "Email Us : info@rangmanch.com",
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  fontSize: 15),
            ),
          ])),
    );
  }

  iAPPBARUI() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "Help and Support", fontSize: 16),
    );
  }
}

class MyListTile extends StatelessWidget {
  final String title, assetImage;
  final Function() onTap;
  const MyListTile(
      {super.key,
      required this.title,
      required this.assetImage,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: textStyleW600(
            fontSize: 16, color: ColorConstants.APPPRIMARYWHITECOLOR),
      ),
      leading: Image.asset(
        assetImage,
        color: ColorConstants.APPPRIMARYWHITECOLOR,
        width: 25,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: ColorConstants.appPrimaryWhiteColor,
        size: 18,
      ),
    ).paddingAll(8);
  }
}
