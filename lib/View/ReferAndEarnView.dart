import 'package:champcash/Data/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import '../shared/extras.dart';
import '../Apis/urls.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({Key? key}) : super(key: key);

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
      appBar: appBarUI(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(height: 100, child: Image.asset(invitevector)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: headingText(
                title: "How does it work?",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: ColorConstants.APPPRIMARYWHITECOLOR),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: headingText(
                title: "Refer and Earn Rewards",
                fontSize: 18,
                color: ColorConstants.APPPRIMARYWHITECOLOR,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: headingFullText(
                title:
                    "Send a referral link to your friends via SMS  / Email/ Whatsapp",
                fontSize: 16,
                color: ColorConstants.APPPRIMARYWHITECOLOR,
                fontWeight: FontWeight.w600,
                align: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 200,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConstants.APPPRIMARYWHITECOLOR,
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(2, 3),
                        blurRadius: 4,
                        color: Colors.grey.withOpacity(0.8))
                  ]),
              child: GestureDetector(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(
                      text: userLoginModel!.data.usedReferalCode));
                  toastMessage("Referral Copied");
                  // copied successfully
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Icon(Icons.copy),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: headingText(
                          title: userLoginModel!.data.usedReferalCode,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 40, left: 30),
            child: GradientButton1(text: 'Invite', onPressed: (){
              Share.share(
                  'https://play.google.com/store/apps/details?id=com.app.rangmanch',
                  subject:
                  'Hi Install this app and earn guaranteed rewards');
            },)
          ),
        ],
      ),
    );
  }

  appBarUI() {
    return AppBar(
      backgroundColor: ColorConstants.APPPRIMARYCOLOR,
      title: headingText(title: "Refer And Earn", fontSize: 16),
    );
  }
}
