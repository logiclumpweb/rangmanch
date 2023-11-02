import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AssetImageView extends StatelessWidget {
  final String img;
  final BoxFit? fit;
  final Color? color;
  const AssetImageView({super.key, this.color, this.fit, required this.img});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      img,
      color: color,
      fit: fit,
    );
  }
}

class NetworkImageView extends StatelessWidget {
  final String imgUrl;
  final BoxFit? fit;
  final Color? color;
  const NetworkImageView(
      {super.key, required this.imgUrl, this.fit, this.color});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      fit: fit,
      color: color,
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
