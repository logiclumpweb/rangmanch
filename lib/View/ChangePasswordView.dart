import 'package:champcash/Data/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Apis/api.dart';
import '../shared/extras.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  var editOldController = TextEditingController();
  var editNewPasswordController = TextEditingController();
  var editConfirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      body: Column(
        children: [
          iAPPBARUI(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: ColorConstants.appPrimaryBlackColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0))),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20, right: 20),
                          child: TextFormField(
                            decoration:
                                cPInputDecoration(hintText: "Old Password"),
                            keyboardType: TextInputType.name,
                            controller: editOldController,
                            enabled: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, left: 20, right: 20),
                          child: TextFormField(
                            decoration:
                                cPInputDecoration(hintText: "New Password"),
                            keyboardType: TextInputType.name,
                            controller: editNewPasswordController,
                            enabled: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20, right: 20),
                          child: TextFormField(
                            controller: editConfirmPasswordController,
                            enabled: true,
                            decoration:
                                cPInputDecoration(hintText: "Confirm Password"),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 5.0, left: 20, right: 20),
                          child: Divider(
                            height: 3,
                            color: Color(0xffe9e9ea),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 20, right: 20, bottom: 30),
                    child: GradientButton1(
                        text: "UPDATE",
                        onPressed: () {
                          if (validation()) {
                            ChangePasswordAPIs();
                          }
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  iAPPBARUI() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "Change Password", fontSize: 16),
    );
  }

  bool validation() {
    if (editOldController.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter Old Password.");
      return false;
    }

    if (editNewPasswordController.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter new password.");
      return false;
    }

    if (editConfirmPasswordController.text.trim().isEmpty) {
      showErrorBottomSheet("Please re-enter password.");
      return false;
    }

    return true;
  }

  void ChangePasswordAPIs() {
    var hashMap = {
      "user_id": userLoginModel!.data.userId,
      "newpassword": editNewPasswordController.text.trim(),
      "oldpassword": editOldController.text.trim(),
      "confirm_password": editConfirmPasswordController.text.trim(),
    };
    print(hashMap);
    changePassword(hashMap).then((value) {
      if (value.status) {
        toastMessage(value.message);
      } else {
        showErrorBottomSheet(value.message);
      }
    });
  }
}

InputDecoration cPInputDecoration({required String hintText}) =>
    InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffc4c4c4)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffc4c4c4)),
      ),
      hintText: hintText,
      hintStyle: textStyleW600(
          fontSize: 15, color: ColorConstants.APPPRIMARYWHITECOLOR),
    );
