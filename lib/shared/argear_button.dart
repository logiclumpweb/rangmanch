import 'package:flutter/material.dart';

class ARGearButton extends StatelessWidget {
  final Function()onTap;
  const ARGearButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 50, right: 0,
        child: GestureDetector(
          // // onTap: () => Get.toNamed(Routes.AR_GEAR),
          // padding: EdgeInsets.all(0),
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration:  BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
            ),
            child: const Icon(Icons.camera_alt, color: Colors.orange,),
          ),
        ));
  }
}
