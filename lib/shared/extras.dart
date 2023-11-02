import 'package:champcash/shared/GIFLoaderPage.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

Text headingLongText(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight}) =>
    Text(
      title,
      maxLines: 3,
      style: GoogleFonts.doppioOne(
          fontSize: fontSize, color: color, fontWeight: fontWeight),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );

Text headingText({
  required title,
  Color? color,
  double? fontSize,
  TextAlign? align,
  FontWeight? fontWeight,
}) =>
    Text(title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.doppioOne(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: align);

Text headingFullText({
  required title,
  Color? color,
  double? fontSize,
  TextAlign? align,
  FontWeight? fontWeight,
}) =>
    Text(title,
        style: GoogleFonts.inter(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: align);

Container SACellRoundContainer(
        {required Widget child,
        Color? color,
        double? width,
        double? height,
        required double radius,
        required double borderWidth,
        required Color borderWidthColor}) =>
    Container(
      child: child,
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius!),
          border: Border.all(width: borderWidth!, color: borderWidthColor!),
          boxShadow: const [
            BoxShadow(
              color: Color(0xff969696),
              blurRadius: 3,
              offset: Offset(1, 3),
            ),
          ]),
    );
Container SACellNSRoundContainer(
        {required Widget child,
        Color? color,
        double? width,
        double? height,
        required double radius,
        required double borderWidth,
        required Color borderWidthColor}) =>
    Container(
      child: child,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius!),
        border: Border.all(width: borderWidth!, color: borderWidthColor!),
      ),
    );

class ColorConstants {
  ColorConstants(_);
  static const Color appPrimaryColor = Color(0xffFE9B0E);
  static const Color applightPrimaryColor = Color(0xffeaf2ff);
  static const Color appPrimaryWhiteColor = Color(0xffffffff);
  static const Color appPrimaryBlackColor = Colors.black;
  static const Color appPrimarylightBlackColor = Color(0xff434343);
  static const Color appPrimarylightGreyColor = Color(0xff8D8D8D);
  static const Color appPrimaryGreenColor = Colors.green;
  static const Color appPrimaryBackgroundColor = Color(0xfff5f5f5);
  static var APPPRIMARYWHITECOLOR = Colors.white;
  static const Color APPPRIMARYCOLOR = Colors.black;
  static const Color APPPRIMARYCOLOR1 = Color(0xff3E57B4);
  static const APPPRIMARYBLACKCOLOR = Color(0xff000000);
  static const APPPRIMARYGREENCOLOR = Color(0xff5AB439);
  static const APPPRIMARYGREYCOLOR = Color(0xffD9D9D9);
}

toastMessage(String msg) => Fluttertoast.showToast(msg: msg);

class ImageViewCovered extends StatelessWidget {
  final String photoUrl;
  final BoxFit? fit;
  const ImageViewCovered(
      {Key? key, required this.photoUrl, this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: photoUrl,
      boxFit: fit!,
      shimmerBaseColor:
          ColorConstants.appPrimarylightBlackColor.withOpacity(0.2),
      shimmerHighlightColor:
          ColorConstants.appPrimarylightBlackColor.withOpacity(0.5),
      shimmerBackColor:
          ColorConstants.appPrimarylightBlackColor.withOpacity(0.7),
      errorWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 25,
          ),
          headingText(
              title: "No Image Found",
              fontWeight: FontWeight.w400,
              fontSize: 24)
        ],
      ),
    );
  }
}

Container NoRecord() => Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //    Image.asset("assets/loader.gif", color: ColorConstants.appPrimarylightBlackColor),
            const Icon(
              Icons.file_present,
              color: Colors.black38,
              size: 40,
            ),
            Container(
              margin: const EdgeInsets.all(4),
              height: 1,
              width: 120,
              color: ColorConstants.APPPRIMARYBLACKCOLOR,
            ),
            Container(
              margin: const EdgeInsets.all(4),
              height: 1,
              width: 100,
              color: ColorConstants.APPPRIMARYBLACKCOLOR,
            ),
            const Text('No_Records',
                style: TextStyle(color: ColorConstants.APPPRIMARYBLACKCOLOR))
          ],
        ),
      ),
    );

Container SACellUperRoundContainer(
        {required Widget child, Color? color, double? width, double? height}) =>
    Container(
        child: child,
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: ColorConstants.APPPRIMARYWHITECOLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(55), topRight: Radius.circular(55))));

Container SACellGradientContainer(
        {required Widget child, Color? color, double? width, double? height}) =>
    Container(
      child: child,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: ColorConstants.APPPRIMARYWHITECOLOR,
      ),
    );

Container SACellRoundContainer1(
        {required Widget child,
        Color? color,
        double? width,
        double? height,
        required double radius,
        required double borderWidth,
        required Color borderWidthColor}) =>
    Container(
      child: child,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius!),
        border: Border.all(width: borderWidth!, color: borderWidthColor!),
      ),
    );

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

addPadding(double width, double height) => SizedBox(
      width: width,
      height: height,
    );

showErrorBottomSheet(String title) {
  Get.bottomSheet(Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              addPadding(0, 10),
              Row(
                children: [
                  addPadding(20, 0),
                  const SizedBox(
                      width: 30,
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 25,
                      )),
                  addPadding(10, 0),
                  Expanded(
                      child: headingFullText(
                          title: "Oh! $title",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.white,
                          align: TextAlign.start)),
                  addPadding(50, 0),
                ],
              ),
              addPadding(0, 10),
            ],
          ),
        ),
      ],
    ),
  ));
}

class SABackButton extends StatelessWidget {
  final Function() onPressed;
  Color color = Colors.white;
  SABackButton({Key? key, required this.onPressed, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: 40,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: color,
          ),
        ),
      ),
    );
  }
}

class GradientButton1 extends StatelessWidget {
  final String text;
  final double height, width;
  final Function onPressed;
  const GradientButton1(
      {Key? key,
      required this.text,
      this.height = 52,
      this.width = double.infinity,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed as void Function()?,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  ColorConstants.appPrimaryColor,
                  ColorConstants.appPrimaryColor.withOpacity(0.95),
                  ColorConstants.appPrimaryColor.withOpacity(0.90),
                  // Color(0xff54b02f),
                  // Color(0xff00923f),
                  // Color(0xff007633)
                  // Color(0xffFE9B0E),
                  // Color(0xffEF840C),
                ])),
        child: Center(
          child: headingText(
              title: text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xffffffff)),
        ),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  final String text;
  final double height, width;
  final Function onPressed;
  final Color? backgroundColor;
  const CommonButton(
      {Key? key,
      required this.text,
      this.height = 52,
      this.width = double.infinity,
      required this.onPressed,
      this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed as void Function()?,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: headingText(
              title: text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xffffffff)),
        ),
      ),
    );
  }
}

class ProgressDialogManager extends StatelessWidget {
  const ProgressDialogManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: ColorConstants.APPPRIMARYWHITECOLOR),
        child: Row(
          children: [
            Expanded(child: Container()),
            const GIFLaaderPage(),
            Expanded(child: Container())
          ],
        ).paddingAll(2),
      ),
    );
  }
}

textStyleW600({double? fontSize, Color? color}) => GoogleFonts.urbanist(
    fontSize: fontSize, fontWeight: FontWeight.w600, color: color);
textStyleW700({double? fontSize, Color? color}) => GoogleFonts.urbanist(
    fontSize: fontSize, fontWeight: FontWeight.w700, color: color);

textStyleW500({double? fontSize, Color? color}) => GoogleFonts.urbanist(
    fontSize: fontSize, fontWeight: FontWeight.w500, color: color);

easyProgressDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) => const ProgressDialogManager(),
    barrierDismissible: false);

delay({required int duration, required Function() onTap}) =>
    Future.delayed(Duration(milliseconds: duration), onTap);

stopPressDialogUI() {
  Get.bottomSheet(
      Container(
        height: 10,
      ),
      isDismissible: false);
}
