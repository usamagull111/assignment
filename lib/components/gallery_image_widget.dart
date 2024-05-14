import 'package:assignment/components/colors.dart';
import 'package:assignment/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalaryImageWidget extends StatelessWidget {
  const GalaryImageWidget({super.key, this.image, this.onTap});
  final Image? image;
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return customStack(alignment: Alignment.center, children: [
      customContainer(
        height: 150.h,
        width: 170.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          //color: Colors.amber
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(30), child: image),
      ),
      Positioned(
          top: 130.h,
          bottom: 0,
          left: 140.w,
          child: InkWell(
              onTap: onTap,
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 30,
                color: blue,
              )))
    ]);
  }
}