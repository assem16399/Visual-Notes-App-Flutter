import 'package:flutter/material.dart';

class BackgroundImageContainer extends StatelessWidget {
  const BackgroundImageContainer(
      {Key? key, required this.image, this.child, this.fit = BoxFit.cover, this.width, this.height})
      : super(key: key);

  final String image;
  final Widget? child;
  final BoxFit fit;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: height ?? deviceSize.height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: fit,
          image: AssetImage(image),
          colorFilter: ColorFilter.mode(Colors.transparent.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: child,
    );
  }
}
