import 'package:champcash/shared/SAImageView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'extras.dart';

class SATextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  bool? enabled = true;
  SATextField(
      {Key? key, required this.hintText, this.controller, this.enabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextFormField(
        style: textStyleW600(
            fontSize: 14, color: ColorConstants.APPPRIMARYWHITECOLOR),
        enabled: enabled,
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: textStyleW600(
                fontSize: 14, color: ColorConstants.APPPRIMARYWHITECOLOR),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color:
                        ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.15))),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.15)),
            ),
            contentPadding: EdgeInsets.only(top: 0, left: 5),
            filled: true,
            fillColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.15)),
      ),
    );
  }
}

class SATextField1 extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  int? maxLength = 100;
  SATextField1(
      {Key? key, required this.hintText, this.controller, this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: TextFormField(
        style: GoogleFonts.inter(
            color: ColorConstants.APPPRIMARYBLACKCOLOR,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        controller: controller,
        textInputAction: TextInputAction.next,
        maxLength: maxLength,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffece7e7))),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffe9e9ea)),
            ),
            contentPadding: const EdgeInsets.only(bottom: 8, left: 0, top: 20),
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
                color: Color(0xffA4A4A4),
                fontSize: 13,
                fontWeight: FontWeight.w400),
            filled: true,
            fillColor: ColorConstants.APPPRIMARYWHITECOLOR),
      ),
    );
  }
}

class SASquareTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  SASquareTextField({Key? key, required this.hintText, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xffCBCBCB))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xffCBCBCB))),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xffCBCBCB)),
            ),
            contentPadding: const EdgeInsets.only(top: 0, left: 10),
            label: headingText(title: hintText),
            labelStyle: GoogleFonts.inter(
                color: ColorConstants.APPPRIMARYBLACKCOLOR,
                fontSize: 13,
                fontWeight: FontWeight.w400),
            filled: true,
            fillColor: ColorConstants.APPPRIMARYWHITECOLOR),
      ),
    );
  }
}

class SAMobTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const SAMobTextField({Key? key, required this.hintText, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        style: textStyleW600(
            fontSize: 14, color: ColorConstants.appPrimaryWhiteColor),
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide:
                  BorderSide(color: Color(0xffdadada).withOpacity(0.12))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide:
                  BorderSide(color: Color(0xffdadada).withOpacity(0.12))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Color(0xffdadada).withOpacity(0.12)),
          ),
          prefixText: "( +91 )",
          suffixIcon: SACellRoundContainer(
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  height: 10,
                  width: 10,
                  child: Icon(
                    Icons.check,
                    color: ColorConstants.APPPRIMARYBLACKCOLOR,
                    size: 11,
                  ),
                  radius: 40,
                  borderWidth: 0,
                  borderWidthColor: Colors.transparent)
              .paddingAll(15),
          prefixIcon: SizedBox(
              height: 10,
              width: 10,
              child: const NetworkImageView(
                      imgUrl:
                          'https://cdn-icons-png.flaticon.com/128/323/323303.png')
                  .paddingAll(12)),
          hintText: hintText,
          hintStyle: textStyleW600(
              fontSize: 14, color: ColorConstants.appPrimaryWhiteColor),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          filled: true,
          fillColor: ColorConstants.appPrimaryBlackColor,
        ),
      ),
    );
  }
}
