import 'package:champcash/shared/SAImageView.dart';
import 'package:champcash/shared/extras.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GIFLaaderPage extends StatelessWidget {
  const GIFLaaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),),
          height: 80,
          width: 80,
          child: const AssetImageView(img: "assets/loadingGif.gif")),
    );
  }
}
