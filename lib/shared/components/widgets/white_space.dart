import 'package:flutter/material.dart';

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({
    Key? key,
    required this.isHorizontal,
  }) : super(key: key);

  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    //device size
    final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: isHorizontal ? 0 : deviceSize.height * 0.015,
      width: isHorizontal ? deviceSize.width * 0.02 : 0,
    );
  }
}
