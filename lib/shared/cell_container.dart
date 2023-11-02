import 'package:flutter/material.dart';

import 'extras.dart';

Container NoRecordFoundView() => Container(
      child: Center(
        child: Image.asset("assets/norecord.png"),
      ),
    );

class PageNationLoaderPage extends StatelessWidget {
  const PageNationLoaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          addPadding(50, 0),
          SACellShadowContainer(
              height: 38,
              width: 38,
              radius: 50,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  color: Color(0xffFE9B0E),
                  strokeWidth: 3,
                ),
              )),
        ],
      ),
    );
  }
}

Container SACellShadowContainer({
  required Widget child,
  Color? color,
  double? width,
  double? height,
  required double radius,
}) =>
    Container(
      child: child,
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: Colors.grey.withOpacity(0.5))
        ],
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
    );
