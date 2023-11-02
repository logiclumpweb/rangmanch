import 'dart:async';

import 'package:champcash/Apis/api.dart';
import 'package:champcash/Auth/UpdateProfileDetailView.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/Routes/AppRoutes.dart';
import 'package:champcash/app/modules/SADashboard/views/AR.dart';
import 'package:champcash/models/SigninModel.dart';
import 'package:champcash/shared/extras.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatefulWidget {
  final String mobNumber;
  const OTPScreen({super.key, required this.mobNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final cont = Get.put<OTPScreenController>(OTPScreenController());
  @override
  void initState() {
    super.initState();
    cont.onInit1(widget.mobNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: ColorConstants.appPrimaryBlackColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  addPadding(15, 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 22,
                                color: ColorConstants.appPrimaryWhiteColor,
                              )),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 38.0),
                        child: headingText(
                            title: "OTP Verification",
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.appPrimaryWhiteColor),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, right: 20, left: 20, bottom: 15),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Enter OTP code sent to your mobile number ",
                            style: GoogleFonts.montserrat(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 15)),
                        TextSpan(
                            text: widget.mobNumber,
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 35),
                    child: OTPTextField(
                        controller: cont.editSubmitOTPCont.value,
                        otpFieldStyle: OtpFieldStyle(
                            borderColor: ColorConstants.APPPRIMARYWHITECOLOR,
                            enabledBorderColor:
                                ColorConstants.APPPRIMARYWHITECOLOR,
                            disabledBorderColor:
                                ColorConstants.APPPRIMARYWHITECOLOR),
                        length: 6,
                        width: double.infinity,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.underline,
                        outlineBorderRadius: 15,
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            color: ColorConstants.APPPRIMARYWHITECOLOR),
                        onCompleted: (pin) {
                          cont.submitOTPVal.value = pin;
                          print("OOTTTPP$pin");
                        }),
                  ),
                  addPadding(0, 10),
                  GestureDetector(
                    onTap: cont.isOnPressed.value
                        ? null
                        : () {
                            cont.isOnPressed.value = true;
                            cont.onInit1(widget.mobNumber);
                          },
                    child: SizedBox(
                      child: RichText(
                          text: TextSpan(
                              text: cont.OTPTitle.value,
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xffA4A4A4)),
                              children: [
                            TextSpan(
                                text: cont.OTPTitle.value.trim() ==
                                        "Resend OTP in"
                                    ? cont.formatTime(cont.timeLeft.value)
                                    : "Resend OTP",
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.APPPRIMARYCOLOR1)),
                          ])),
                    ),
                  ),
                  addPadding(0, 10),
                  GradientButton1(
                      text: "Verify & Proceed",
                      onPressed: () {
                        if (cont.submitOTPVal.value == "") {
                          return showErrorBottomSheet("Please enter OTP");
                        }
                        cont.verifyOTP();
                      }).paddingAll(15),
                  addPadding(25, 0),
                ],
              ),
            ),
          ],
        ));
  }
}

class OTPScreenController extends GetxController {
  String tooManyRequest =
      'We have blocked all requests from this device due to unusual activity. Try again later.';
  String inCorrectCountryAndNumber =
      "The format of the phone number provided is incorrect. Enter correct country code and correct phone number.";
  RxInt timeLeft = 45.obs;
  final verificationIdValue = "".obs,
      OTPTitle = "Resend OTP in".obs,
      mobNumberVal = "000".obs,
      isOnPressed = false.obs,
      myUserId = "0".obs,
      firebaseToken = "".obs;
  Timer? _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final editSubmitOTPCont = OtpFieldController().obs, submitOTPVal = "".obs;

  @override
  void onInit() {
    super.onInit();
    getFirebaseToken();
  }

  getFirebaseToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      firebaseToken.value = token!;
      print("Tokennn${token}");
    });
  }

  onInit1(String mobNumber) {
    mobNumberVal.value = mobNumber;
    submitOTPVal.value = "";
    resendTimerCounter();
    phoneAuthentication();
  }

  phoneAuthentication() {
    String number = "+91-$mobNumberVal";
    _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (user) {
          print('user => $user\n${user.smsCode}');
        },
        timeout: const Duration(seconds: 60),
        verificationFailed: (exception) {
          if (exception.code == "too-many-requests") {
            showErrorBottomSheet(tooManyRequest);
          } else if (exception.code == "invalid-phone-number") {
            showErrorBottomSheet(inCorrectCountryAndNumber);
          } else {
            showErrorBottomSheet(exception.message.toString());
          }
          print('exception => $exception');
        },
        codeSent: (verificationId, forceResendingToken) {
          verificationIdValue.value = verificationId;
          toastMessage("OTP sent");
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationIdValue.value = verificationId;
          print('exception => $verificationId');
        });
  }

  void resendTimerCounter() async {
    timeLeft.value = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft.value -= 1;
      if (timeLeft.value <= 0) {
        isOnPressed.value = false;
        OTPTitle.value = "If you didn't receive a code! ";
        _timer?.cancel();
      } else {
        OTPTitle.value = "Resend OTP in ";
      }
    });
  }

  void verifyOTP() async {
    print(submitOTPVal.value);
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIdValue.value,
          smsCode: submitOTPVal.value);
      final User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        login();
      }
    } catch (e) {
      showErrorBottomSheet("You have entered wrong OTP ");
    }
  }

  String formatTime(int time) {
    int min = time ~/ 60;
    int sec = time - min * 60;
    String fTime = '${min < 10 ? '0' : ''}$min:${sec < 10 ? '0' : ''}$sec';
    return fTime;
  }

  void login() {
    var hashMap = {
      "type": "Normal",
      "mobile": mobNumberVal.value.trim(),
      "password": "12345",
      "firebase_token": firebaseToken.value
    };
    print("LOGHHHHHH${hashMap}");
    LoginApi(hashMap).then((value) {
      if (value.status) {
        SigninModel model = value.data;
        userLoginModel = model;
        myUserId.value = userLoginModel!.data.userId.toString();
       if (model.data.mobileOtpVerify == "1") {
          if (userLoginModel != null) {
            toastMessage(value.message.toString());
            setUserInfo(model).whenComplete(() {
              // Get.to(const Dashboard());
              Get.offAndToNamed(Routes.S_A_DASHBOARD);
            });
          } else {
            toastMessage("Something went wrong");
          }
         } else {
           Get.offAll(
              UpdateProfileDetailView(type: "SetUp", Id: myUserId.value));
       }
      } else {
        showErrorBottomSheet(value.message.toString());
      }
    });
  }
}
