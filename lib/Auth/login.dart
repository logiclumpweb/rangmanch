import 'dart:math';

import 'package:champcash/Auth/OTPScreen.dart';
import 'package:champcash/Auth/registration.dart';
import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/label_button.dart';
import 'package:champcash/shared/textfields.dart';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:path_provider/path_provider.dart';

import '../Apis/api.dart';
import '../DashBoardView.dart';
import '../Data/UserData.dart';
import 'OTPVerification.dart';
import '../Routes/AppRoutes.dart';
import '../shared/extras.dart';
import '../models/SigninModel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var editMobileController = TextEditingController();
  var editPasswordcontroller = TextEditingController();

  //Country? _selectedCountry;
  String flagurl = "https://cdn-icons-png.flaticon.com/128/330/330439.png",
      callingCode = "+91";

  var editTextcontroller = TextEditingController();

  String? videoPathVal, audioPathVal;

  @override
  void initState() {
    super.initState();
    initCountry();
  }

  void initCountry() async {
    //  final country = await getDefaultCountry(context);
    //  print(country.flag);
    setState(() {
      //   _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appPrimaryBlackColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(children: [
          appBarHeadingWidget(),
          Image.asset(
            "assets/logo.png",
            height: 150,
          ).paddingOnly(left: 70, right: 70, top: 50, bottom: 30),
          Text(
            "We will send you an One Time Password on this mobile number",
            textAlign: TextAlign.center,
            style: textStyleW600(
                fontSize: 15.5,
                color: ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.80)),
          ).paddingOnly(left: 40, right: 40, top: 0),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Phone number",
            style: textStyleW600(
                fontSize: 15, color: ColorConstants.APPPRIMARYWHITECOLOR),
          ).paddingOnly(top: 15.0, left: 38, right: 38),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 30, right: 38),
            child: SAMobTextField(
              hintText: "Enter Phone Number",
              controller: editMobileController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 30, left: 30),
            child: GradientButton1(
              //backgroundColor: Color(0xff564D8C),
              text: 'Send OTP',
              onPressed: () {
                if (validation()) {
                  verifyBottomSheet();
                  //   login();
                }
              },
            ),
          ),
        ]),
      ),
    );
  }

  void getFlagAPI(String countryCode) async {
    // Country? country = await getCountryByCountryCode(context, countryCode);
    print("H");
    //   print(country!.flag);
  }

  bool validation() {
    if (editMobileController.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter your mobile number");
      return false;
    }

    // if (editPasswordcontroller.text.trim().isEmpty) {
    // if (editPasswordcontroller.text.trim().isEmpty) {
    //   showErrorBottomSheet("Please enter password");
    //   return false;
    // }

    return true;
  }

  Future<void> clearAuthFields() async {
    editMobileController.clear();
    editPasswordcontroller.clear();
  }

  appBarHeadingWidget() {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: textStyleW600(
                    fontSize: 20, color: ColorConstants.APPPRIMARYWHITECOLOR),
              ),
              Text(
                "Hello, welcome back!",
                style: textStyleW500(
                    fontSize: 15,
                    color:
                        ColorConstants.APPPRIMARYWHITECOLOR.withOpacity(0.60)),
              ),
            ],
          ),
        ),
        const Spacer(),
        const SizedBox(
          height: 20,
          width: 20,
          child: NetworkImageView(
              imgUrl: 'https://cdn-icons-png.flaticon.com/128/323/323303.png'),
        ),
        addPadding(15, 0)
      ],
    ).paddingOnly(left: 25, top: 10);
  }

  void verifyBottomSheet() {
    Get.bottomSheet(
        OTPScreen(
          mobNumber: editMobileController.value.text,
        ),
        isDismissible: false);
  }
}
