import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../shared/extras.dart';



class ImageView extends StatelessWidget {
  final String photoUrl;
  const ImageView({Key? key,required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: photoUrl,
      shimmerBaseColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.2),
      shimmerHighlightColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.5),
      shimmerBackColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.7),
      errorWidget: SizedBox(
        child: Image.asset("assets/placeholder.png"),
      ),
    );
  }
}


class ImageViewCovered extends StatelessWidget {
  final String photoUrl;
  const ImageViewCovered({Key? key,required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: photoUrl,
      boxFit: BoxFit.cover,
      shimmerBaseColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.2),
      shimmerHighlightColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.5),
      shimmerBackColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.7),
      errorWidget:Image.asset("assets/placeholder.png"),
    );
  }
}

class ImageViewFitHeight extends StatelessWidget {
  final String photoUrl;
  const ImageViewFitHeight({Key? key,required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: photoUrl,
      boxFit: BoxFit.fitHeight,
      shimmerBaseColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.2),
      shimmerHighlightColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.5),
      shimmerBackColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.7),
      errorWidget: Image.asset("assets/placeholder.png"),
    );
  }
}
class ImageViewFill extends StatelessWidget {
  final String photoUrl;
  const ImageViewFill({Key? key,required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: photoUrl,
      boxFit: BoxFit.fill,
      shimmerBaseColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.2),
      shimmerHighlightColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.5),
      shimmerBackColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.7),
      errorWidget: Image.asset("assets/placeholder.png"),
    );
  }
}
class ImageViewFillWithColor extends StatelessWidget {
  final String photoUrl;
  const ImageViewFillWithColor({Key? key,required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: photoUrl,
      boxFit: BoxFit.fill,
      shimmerBaseColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.2),
      shimmerHighlightColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.5),
      shimmerBackColor: ColorConstants.APPPRIMARYGREYCOLOR.withOpacity(0.7),
      errorWidget: Image.asset("assets/placeholder.png"),
    );
  }
}