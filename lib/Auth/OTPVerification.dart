// import 'dart:async';
// import 'dart:collection';
// import 'dart:ffi';
// import 'dart:io';
//
// import 'package:champcash/Data/UserData.dart';
// import 'package:champcash/shared/extras.dart';
// import 'package:champcash/Auth/registration.dart';
// import 'package:champcash/tab/HomeView.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../Apis/api.dart';
// import '../DashBoardView.dart';
// import '../Routes/AppRoutes.dart';
// import '../models/loginModel.dart';
//
// class OTPScreen extends StatefulWidget {
//   final String? Uname, Mobile, Refral, Email, password, Gender;
//   OTPScreen(
//       {Key? key,
//       required this.Uname,
//       required this.Email,
//       required this.Mobile,
//       required this.Refral,
//       required this.password,
//       required this.Gender})
//       : super(key: key);
//
//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen> {
//   int timeLeft = 45;
//   String verificationId1 = "";
//
//   Timer? timer;
//   String OTPTitle = "Resend OTP in";
//   bool isPressed = false;
//   String? firebaseToken;
//   final OTP = "";
//   final isVisibilityOTPUI = true;
//   String getOtp = "";
//
//   @override
//   void initState() {
//     super.initState();
//     resendOTP();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         children: [
//           addPadding(0, 10),
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0, top: 10),
//                 child: Image.asset(
//                   "assets/back.png",
//                   width: 20,
//                 ),
//               ),
//               SizedBox(
//                 width: 100,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       "OTP Verification",
//                       style: TextStyle(fontSize: 16),
//                       textAlign: TextAlign.center,
//                     )),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Image.asset(
//               "assets/otpicon.png",
//               height: 300,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   " ${"Enter OTP code sent to your  \n  number ${userLoginModel!.data.mobile}"} ",
//                   style: TextStyle(fontSize: 16),
//                   textAlign: TextAlign.center,
//                 )),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15.0),
//             child: OtpTextField(
//               numberOfFields: 6,
//               borderColor: Color(0xFFFDE56D),
//               focusedBorderColor: Color(0xffFE9B0E),
//               //set to true to show as box or false to show as dash
//               showFieldAsBox: true,
//               //runs when a code is typed in
//               onCodeChanged: (String code) {
//                 //handle validation or checks here
//               },
//               //runs when every textfield is filled
//               onSubmit: (String verificationCode) {
//                 this.setState(() {
//                   getOtp = verificationCode;
//                 });
//               }, // end onSubmit
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 30.0, top: 40, left: 30),
//             child: SizedBox(
//                 width: double.infinity,
//                 height: 58,
//                 child: ElevatedButton(
//                     onPressed: () {
//                       if (getOtp.trim().isNotEmpty) {
//                         VeriFyApi(getOtp);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xffFE9B0E),
//                       side: BorderSide(color: Color(0xff000000), width: 0.5),
//                     ),
//                     child: const Text(
//                       "VERIFY",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                     ))),
//           ),
//           GestureDetector(
//             onTap: isPressed
//                 ? null
//                 : () {
//                     isPressed = true;
//                     needOTPAPIs();
//                   },
//             child: SizedBox(
//               child: RichText(
//                   text: TextSpan(
//                       text: OTPTitle,
//                       style: GoogleFonts.inter(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xffA4A4A4)),
//                       children: [
//                     TextSpan(
//                         text: /*OTPTitle=="Resend OTP in"?*/
//                             formatTime(timeLeft) /*:"RESEND OTP"*/,
//                         style: GoogleFonts.inter(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             color: ColorConstants.APPPRIMARYCOLOR1)),
//                   ])),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
//
//   void resendTimerCounter() async {
//     setState(() {
//       timeLeft = 45;
//       timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         timeLeft -= 1;
//
//         if (timeLeft <= 0) {
//           print(timeLeft);
//           isPressed = false;
//           OTPTitle = "Didn't receive the OTP ? ";
//           timer?.cancel();
//         } else {
//           print(timeLeft);
//           OTPTitle = "Resend OTP in ";
//         }
//       });
//     });
//   }
//
//   String formatTime(int time) {
//     int min = time ~/ 60;
//     int sec = time - min * 60;
//     String fTime = '${min < 10 ? '0' : ''}$min:${sec < 10 ? '0' : ''}$sec';
//     return fTime;
//   }
//
//   void needOTPAPIs() {
//     setState(() {
//       resendTimerCounter();
//       resendOTP();
//     });
//   }
//
//   void resendOTP() {
//     var hashMap = {
//       "user_id": userLoginModel?.data.userId.toString(),
//     };
//     print(hashMap);
//     ResendOTPApi(hashMap).then((value) {
//       if (value.status) {
//         Fluttertoast.showToast(msg: value.message);
//         resendTimerCounter();
//       } else {
//         EasyLoading.dismiss();
//         showErrorBottomSheet(value.message.toString());
//       }
//     });
//   }
//
//   void VeriFyApi(String verificationCode) {
//     var hashMap = {
//       "user_id": userLoginModel?.data.userId.toString(),
//       "otp": verificationCode,
//     };
//     print(hashMap);
//     VerifyOTPApi(hashMap).then((value) {
//       if (value.status) {
//         // Get.to(Dashboard());
//
//         Get.offAndToNamed(Routes.S_A_DASHBOARD);
//
//         if (userArtistModel != null) {
//           EasyLoading.dismiss();
//           setLoginModelDetail(userArtistModel!).whenComplete(() {
//             isUpdateProfileStatus(value.status.toString()).whenComplete(() {
//               getLoginModelDetail().then((value) {
//                 print("cdhbdhhdbhfbd");
//
//                 toastMessage(value!.message);
//
//                 //Get.to(Dashboard());
//               });
//             });
//           });
//         }
//       } else {
//         EasyLoading.dismiss();
//         showErrorBottomSheet(value.message.toString());
//       }
//     });
//   }
// }
