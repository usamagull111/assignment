import 'package:assignment/components/colors.dart';
import 'package:assignment/components/common_widgets.dart';
import 'package:assignment/views/dialogs/image_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget addProductsButton({required BuildContext context}) {
  return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const ImageDetailsDialog();
                    },
                  );
                },
                child: customContainer(
                  margin: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 80.h,
                  color: grey,
                  child: customColumn(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      customText(title: "Add Store"),
                    ],
                  ),
                ),
              );
}