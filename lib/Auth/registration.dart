import 'package:champcash/Auth/OTPVerification.dart';
import 'package:champcash/Auth/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Apis/api.dart';
import '../Data/UserData.dart';
import '../shared/extras.dart';
import '../models/loginModel.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //Country? _selectedCountry;
  String flagurl = "https://cdn-icons-png.flaticon.com/128/330/330439.png",
      callingCode = "+91";

  var editNamecontroller = TextEditingController();
  var editEmailcontroller = TextEditingController();
  var editMobilecontroller = TextEditingController();
  var editPasswordcontroller = TextEditingController();
  var editReferralcontroller = TextEditingController();
  bool onSelectmale = false, onSelectfemale = false;
  String onSelectGendre = "";
  String Gendertype = "Male";

  @override
  void initState() {
    initCountry();
  }

  void initCountry() async {
    //final country = await getDefaultCountry(context);
   // print(country.flag);
    setState(() {
     // _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 30),
          child: Image.asset(
            "assets/logo.png",
            height: 100,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Sign Up",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20),
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0,
                        offset: Offset(5, 5),
                        spreadRadius: 2)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextField(
                  controller: editNamecontroller,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: "Enter Name",
                      contentPadding: EdgeInsets.all(10.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide.none)),
                  textAlign: TextAlign.start,
                  maxLines: 1,

                  // controller: _locationNameTextController,
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20),
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0,
                        offset: Offset(5, 5),
                        spreadRadius: 2)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextField(
                  controller: editEmailcontroller,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: "Enter Email ID",
                      contentPadding: EdgeInsets.all(10.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide.none)),
                  textAlign: TextAlign.start,
                  maxLines: 1,

                  // controller: _locationNameTextController,
                ),
              )),
        ),
        SizedBox(
          height: 68,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 15),
                child: GestureDetector(
                  onTap: () async {
                    // final country = await showCountryPickerSheet(context,
                    //     cancelWidget: SizedBox());
                    // if (country != null) {
                    //   setState(() {
                    //     _selectedCountry = country;
                    //     //flagurl = _selectedCountry!.flag;
                    //     callingCode = _selectedCountry!.callingCode;
                    //     print(_selectedCountry?.countryCode);
                    //   });
                    // }
                  },
                  child: Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15.0,
                                offset: Offset(5, 5),
                                spreadRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                        child: SizedBox(
                          height: 45,
                          child: Center(child: Text(callingCode)),
                        ),
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 35.0, top: 16),
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15.0,
                                offset: Offset(5, 5),
                                spreadRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: TextField(
                          controller: editMobilecontroller,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Enter Mobile Number",
                              contentPadding: EdgeInsets.all(10.0),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  borderSide: BorderSide.none)),
                          textAlign: TextAlign.start,
                          maxLines: 1,

                          // controller: _locationNameTextController,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20),
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0,
                        offset: Offset(5, 5),
                        spreadRadius: 2)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextField(
                  controller: editPasswordcontroller,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: "Enter Password",
                      contentPadding: EdgeInsets.all(10.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide.none)),
                  textAlign: TextAlign.start,
                  maxLines: 1,

                  // controller: _locationNameTextController,
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20),
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0,
                        offset: Offset(5, 5),
                        spreadRadius: 2)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: TextField(
                  controller: editReferralcontroller,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: "Referral Code (Optional)",
                      contentPadding: EdgeInsets.all(10.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide.none)),
                  textAlign: TextAlign.start,
                  maxLines: 1,

                  // controller: _locationNameTextController,
                ),
              )),
        ),
        /* Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    Gendertype = "Male";
                    onSelectGendre = "Male";
                    onSelectmale = true;
                    onSelectfemale = false;
                    print(Gendertype);
                  });

                  */
        /*   if (Gendertype == "Male") {
                    Image.asset(
                      "assets/maleicon.png",
                      width: 50,
                      color: ColorConstants.appPrimaryColor,
                    );
                  }*/
        /*
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Gendertype == "Male"
                          ? Colors.blue
                          : ColorConstants.APPPRIMARYCOLOR.withOpacity(0.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/maleicon.png",
                      width: 50,
                    ),
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 35.0, left: 35),
                child: Text("OR"),
              ),
              SizedBox(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    Gendertype = "Female";
                    onSelectGendre = "Female";
                    onSelectmale = false;
                    onSelectfemale = true;
                  });
                  //print(Gendertype);
                  */
        /*    Image.asset(
                    "assets/femaleicon.png",
                    width: 50,
                    color: ColorConstants.appPrimaryColor,
                  );*/
        /*
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Gendertype != "Male"
                          ? Colors.blue
                          : ColorConstants.APPPRIMARYCOLOR.withOpacity(0.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/femaleicon.png",
                      width: 50,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "By Signup you agree to our?",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              Text(
                "  T&C  ",
                style: TextStyle(color: Color(0xffFE9B0E), fontSize: 12),
              ),
              Text(
                "and",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              Text(
                " Privacy policy ",
                style: TextStyle(color: Color(0xffFE9B0E), fontSize: 12),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    if (validation()) {
                      getSignupApi();
                      /*Get.to(OTPScreen(Uname: editNamecontroller.text.trim(),
                        password:editPasswordcontroller.text.trim(),
                        Email: editEmailcontroller.text.trim(),
                        Refral: editReferralcontroller.text.trim(),
                        Mobile: editMobilecontroller.text.trim(),Gender: Gendertype,));*/
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffFE9B0E),
                    side: BorderSide(color: Color(0xff000000), width: 0.5),
                  ),
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account ?",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(Login());
                },
                child: Text(
                  " Login",
                  style: TextStyle(
                    color: Color(0xffFE9B0E),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    ));
  }

  bool validation() {
    if (editNamecontroller.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter Name.");
      return false;
    }

    if (editMobilecontroller.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter Name.");
      return false;
    }

    if (editEmailcontroller.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter Email Address.");
      return false;
    }

    if (!validEmail(editEmailcontroller.text.trim())) {
      showErrorBottomSheet(
          "Please enter an email address in the correct format, like ‘demo@gmail.com’.");
      return false;
    }

    if (editPasswordcontroller.text.trim().isEmpty) {
      showErrorBottomSheet("Please enter password.");
      return false;
    }

    /*if (editControllerPAssword.text.trim().length < 8) {
      showErrorBottomSheet("Password length must be between 8 to 15 characters long.");
      return false;
    }*/

    return true;
  }

  bool validEmail(emailAddress) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailAddress);
    return emailValid;
  }

  void getSignupApi() {
    SendOtp();
  }

  void SendOtp() {
    EasyLoading.show();
    var hashMap = {
      "mobile": editMobilecontroller.text.trim(),
      "name": editNamecontroller.text.trim(),
      "type": "Normal",
      "password": editPasswordcontroller.text.trim(),
      "gender": Gendertype,
      "email": editEmailcontroller.text.trim(),
      "used_referal_code": editReferralcontroller.text.trim(),
    };
    print(hashMap);

    SignUpApi(hashMap).then((value) {
      if (value.status) {
        Get.to(Login());
        toastMessage(value.message);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        showErrorBottomSheet(value.message.toString());
      }
    });
  }
}
