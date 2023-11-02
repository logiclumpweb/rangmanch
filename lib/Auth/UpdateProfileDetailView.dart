import 'dart:io';

import 'package:champcash/Auth/OTPScreen.dart';
import 'package:champcash/DashBoardView.dart';
import 'package:champcash/app/modules/SADashboard/controllers/s_a_profile_controller.dart';
import 'package:champcash/models/SigninModel.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Apis/api.dart';
import '../Data/UserData.dart';
import '../Routes/AppRoutes.dart';
import '../models/GetProfileDataModel.dart';
import '../shared/extras.dart';

class UpdateProfileDetailView extends StatefulWidget {
  final String type, Id;
  const UpdateProfileDetailView(
      {Key? key, required this.type, required this.Id})
      : super(key: key);

  @override
  State<UpdateProfileDetailView> createState() => _MyProfileDetailViewState();
}

class _MyProfileDetailViewState extends State<UpdateProfileDetailView> {
  var editNameController = TextEditingController();
  var editEmailController = TextEditingController();
  var editMobileController = TextEditingController();
  var editPasswordController = TextEditingController();
  var editGenderController = TextEditingController();
  var editUODAdressController = TextEditingController();
  var editSponsorController = TextEditingController();
  var editYoutubeController = TextEditingController();
  var editFacebookController = TextEditingController();
  var editInstaController = TextEditingController();
  var editOUDController = TextEditingController();
  var editPANController = TextEditingController();
  var editUserNameController = TextEditingController();
  String profilePhotoUrl = "", gender = "Select Gender", currentLocation = "";
  List<String> genderList = ["Select Gender", "Male", "Female", "Other"];

  var cObscureText = true;
  File? file;

  @override
  void initState() {
    super.initState();
    getProfileDetailAPIs();
    //getProfileDetailAPIs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appPrimaryBlackColor,
      //appBar: appBarUI(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                iAPPBARUI(),
                addPadding(0, 55),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: ColorConstants.APPPRIMARYBLACKCOLOR,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50))),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 20, right: 20),
                                  child: SATextField(
                                    hintText: "Name",
                                    controller: editNameController,
                                    enabled: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 20, right: 20),
                                  child: SATextField(
                                    hintText: "User Name",
                                    controller: editUserNameController,
                                    enabled: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 20, right: 20),
                                  child: SATextField(
                                    hintText: "Email",
                                    controller: editEmailController,
                                    enabled: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 20, right: 20),
                                  child: SATextField(
                                    hintText: "Mobile Number",
                                    controller: editMobileController,
                                    enabled: false,
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 25.0, left: 20, right: 20),
                                //   child: SATextField(
                                //     hintText: "Enter OUD Adress",
                                //     controller: editOUDController,
                                //     enabled: true,
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 25.0, left: 20, right: 20),
                                //   child: SATextField(
                                //     hintText: "Enter PAN Adress",
                                //     controller: editPANController,
                                //     enabled: true,
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 20, right: 20),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: ColorConstants
                                            .APPPRIMARYGREYCOLOR
                                            .withOpacity(0.15)),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                      color:
                                          ColorConstants.appPrimaryWhiteColor,
                                    ),
                                    dropdownColor: ColorConstants
                                        .APPPRIMARYGREYCOLOR
                                        .withOpacity(0.15),
                                    isExpanded: true,
                                    value: gender,
                                    items: genderList.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: headingText(
                                            title: e,
                                            fontSize: 15,
                                            color: ColorConstants
                                                .APPPRIMARYWHITECOLOR),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        gender = value!;
                                      });
                                    },
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 25.0, left: 20, right: 20),
                                //   child: SATextField(
                                //     hintText: "Enter Youtube Channel Link",
                                //     controller: editYoutubeController,
                                //     enabled: true,
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 25.0, left: 20, right: 20),
                                //   child: SATextField(
                                //     hintText: "Enter Facebook Profile Link",
                                //     controller: editFacebookController,
                                //     enabled: true,
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 25.0, left: 20, right: 20),
                                //   child: SATextField(
                                //     hintText: "Enter Instagram Profile Link",
                                //     controller: editInstaController,
                                //     enabled: true,
                                //   ),
                                // ),
                                addPadding(0, 10),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20, right: 20, bottom: 30),
                          child: GradientButton1(
                              text: "UPDATE",
                              onPressed: () {
                                if (validation()) {
                                  saveProfileDetailAPIs();
                                }
                              }),
                        )
                      ],
                    ),
                  ).paddingOnly(top: widget.type == "SetUp" ? 0 : 50),
                )
              ],
            ),
            widget.type == "SetUp"
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          onTap: () {
                            ImagePicker.platform
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              setState(() {
                                file = File(value!.path);
                                print(file);
                                uploadUserProfileIMageAPIs(file!);
                              });
                            });
                          },
                          child: SACellRoundContainer(
                              height: 95,
                              width: 95,
                              color: ColorConstants.APPPRIMARYWHITECOLOR,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ClipOval(
                                    child: profilePhotoUrl == ""
                                        ? AssetImageView(
                                            img: "assets/iconDefulat.png",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            profilePhotoUrl,
                                            fit: BoxFit.cover,
                                          )),
                              ),
                              radius: 60,
                              borderWidth: 1,
                              borderWidthColor: Colors.transparent),
                        )),
                  ),
            widget.type == "SetUp"
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 135.0, left: 60),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: SACellRoundContainer(
                            height: 22,
                            width: 22,
                            color: ColorConstants.appPrimaryColor,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              size: 17,
                              color: ColorConstants.APPPRIMARYWHITECOLOR,
                            )),
                            radius: 60,
                            borderWidth: 1,
                            borderWidthColor: Colors.transparent)),
                  ),
          ],
        ),
      ),
    );
  }

  iAPPBARUI() {
    return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 25.0, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SABackButton(
                onPressed: () {
                  Get.back();
                },
                color: ColorConstants.APPPRIMARYWHITECOLOR,
              ),
              const Spacer(),
              headingText(
                  title: "Update Profile",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.APPPRIMARYWHITECOLOR),
              const Spacer(),
            ],
          ),
        ));
  }

  /* Future<void> getProfileDetailAPIs() async {
    APIResponse response = await getProfileDetailAPI(
        {"tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString()});
    if (response.status) {
      ProfileDetailModel model = response.data;
      viewProfileDetail = model;
      if (viewProfileDetail != null) {
      setState(() {
        editNameController.text=viewProfileDetail!.data.first.fullName.toString();
        editEmailController.text =
            viewProfileDetail!.data.first.email.toString();
        editMobileController.text= viewProfileDetail!.data.first.mobile.toString();
        profilePhotoUrl =
            viewProfileDetail!.data.first.userImage.toString();
        gender=viewProfileDetail!.data.first.gender.toString()==""?"Select Gender":
        viewProfileDetail!.data.first.gender.toString();
        currentLocation=viewProfileDetail!.data.first.location.toString()==""?"Location":
        viewProfileDetail!.data.first.location.toString();
        isUpdateProfileStatus(viewProfileDetail!.data.first.isUpdateProfileStatus.toString());
      });
      }
    } else {
      showErrorBottomSheet(response.message.toString());
    }
  }*/

  void uploadUserProfileIMageAPIs(File file) {
    uploadProfileViewAPI(file).then((value) {
      if (value.status) {
        toastMessage(value.message.toString());
        getProfileDetailAPIs();
      } else {
        showErrorBottomSheet(value.message.toString());
      }
    });
  }

  saveProfileDetailAPIs() {
    String Id = "739";
    var hashMap = {
      "user_id": widget.type == "SetUp"
          ? widget.Id
          : userLoginModel!.data.userId.toString(),
      "user_name": editUserNameController.text.toString().trim(),
      "name": editNameController.value.text.trim(),
      "gender": gender,
      "email": editEmailController.text,
      "facebook": editFacebookController.text.toString().trim(),
      "location": currentLocation,
      "instagram": editInstaController.text.toString().trim(),
      "contract_address": editOUDController.text.toString().trim(),
      "youtube": editYoutubeController.text.toString().trim(),
    };

    print(hashMap);
    saveProfileDetailAPI(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message.toString());
        getUserInfo().whenComplete(() {
          toastMessage(value.message);
          Get.back();
        });
        if (widget.type == "SetUp") login();
      } else {
        showErrorBottomSheet(value.message.toString());
      }
    });
  }

  bool validation() {
    if (editNameController.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter name.");
      return false;
    }
    if (editUserNameController.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter user name.");
      return false;
    }

    if (editEmailController.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter your email-Id.");
      return false;
    }

    if (editMobileController.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter your mobile number.");
      return false;
    }

    if (gender == "Select Gender") {
      showErrorBottomSheet("Please select gender.");
      return false;
    }

    /*if(currentLocation=="Location"){
      showErrorBottomSheet("Please your location.");
      return false;
    }*/

    return true;
  }

  void getProfileDetailAPIs() async {
    APIResponse response = await getProfileDetailAPI(
        {"user_id": userLoginModel!.data.userId.toString()});
    if (response.status) {
      setState(() {
        GetProfileDataModel model = response.data;
        userProfileModel = model;
        print("OOUUUUU${userProfileModel!.data.userImage}");
        editNameController.text = userProfileModel!.data.name;
        editUserNameController.text = userProfileModel!.data.userName;
        editEmailController.text = userProfileModel!.data.email;
        editMobileController.text = userProfileModel!.data.mobile;
        if (userProfileModel!.data.userImage != "") {
          profilePhotoUrl = userProfileModel!.data.userImage;
        }
        gender = userProfileModel!.data.gender.toString() == ""
            ? "Select Gender"
            : userProfileModel!.data.gender.toString() == "1"
                ? "Male"
                : userProfileModel!.data.gender.toString();

        editGenderController.text =
            userProfileModel!.data.gender.toString().capitalizeFirst!;
        //gender = userProfileModel!.data.gender.toString().capitalizeFirst!;
        editSponsorController.text =
            userProfileModel!.data.usedReferalCode.toString();
        editPANController.text = userProfileModel!.data.panNo.toString();
        editOUDController.text =
            userProfileModel!.data.contractAddress.toString();
        editInstaController.text = userProfileModel!.data.instagram.toString();
        editFacebookController.text =
            userProfileModel!.data.facebook.toString();
        editYoutubeController.text = userProfileModel!.data.youtube.toString();
      });
    } else {
      showErrorBottomSheet(response.message.toString());
    }
  }

  appBarUI() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "Update Profile", fontSize: 16),
    );
  }

  void login() {
    var hashMap = {
      "type": "Normal",
      "mobile": editMobileController.text.trim(),
      "password": "123456",
    };
    print(hashMap);
    LoginApi(hashMap).then((value) {
      if (value.status) {
        SigninModel model = value.data;
        userLoginModel = model;
        if (model.data.mobileOtpVerify == "1") {
          if (userLoginModel != null) {
            toastMessage(value.message.toString());
            setUserInfo(model).whenComplete(() {
              Get.toNamed(Routes.S_A_DASHBOARD);
              //getProfileDetailAPIs();
            });
          } else {
            toastMessage("Something went wrong");
          }
        }
      } else {
        showErrorBottomSheet(value.message.toString());
      }
    });
  }
}
