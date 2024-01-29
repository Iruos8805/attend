import 'package:flutter/material.dart';
import 'package:samplew/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed:() {},
          icon: const Icon(
            Icons.dashboard_rounded,
            color: kpurple,
          ),),
        IconButton(
          onPressed: () {} , 
          icon: const Icon(
            Icons.settings_outlined,
            color: kpurple,
          ),),
    ],);
  }
}