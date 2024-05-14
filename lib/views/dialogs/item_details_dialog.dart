
import 'package:assignment/components/colors.dart';
import 'package:assignment/components/common_widgets.dart';
import 'package:assignment/components/custom_text_form_field.dart';
import 'package:assignment/components/gallery_image_widget.dart';
import 'package:assignment/views/providers/item_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class ItemDetailsDialog extends StatefulWidget {
 
  final String? imageUrl;
  final String? id;
  const ItemDetailsDialog({this.imageUrl, this.id, super.key});

  @override
  State<ItemDetailsDialog> createState() => _ItemDetailsDialogState();
}

class _ItemDetailsDialogState extends State<ItemDetailsDialog> {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemDetailsProvider(),
      child: Consumer<ItemDetailsProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              customDialog(
                child: Form(
                  key: key,
                  child: customSingleChildScrollView(
                    child: customContainer(
                      color: dialogBG,
                      height: 400.h,
                      width: 800.w,
                      child: customColumn(
                        children: [
                          customSizedBox(height: 10.h),
                          provider.image != null
                              ? GalaryImageWidget(
                                  image: Image.file(provider.image!, fit: BoxFit.fill),
                                  onTap: () async {
                                    await provider.getImage();
                                  },
                                )
                              : GalaryImageWidget(
                                  image: Image.network(widget.imageUrl ?? "https://icons.veryicon.com/png/o/application/designe-editing/add-image-1.png",
                                      fit: BoxFit.fill),
                                  onTap: () async {
                                    await provider.getImage();
                                  }),
                          customSizedBox(height: 60.h),
                          customRow(
                            children: [
                              customSizedBox(width: 30.w),
                              customText(
                                  title: 'Name: ',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              customSizedBox(width: 0.w),
                              customContainer(
                                width: 200.w,
                                child: CustomTextFormField(
                                  controller: provider.name,
                                  borderDecoration: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                  validator: (value) {
                                    final RegExp alphaRegex = RegExp(r'^[a-zA-Z]+$');
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter text';
                                    } else if (!alphaRegex.hasMatch(value)) {
                                      return 'Please enter alphabets only';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          customSizedBox(height: 30.h),
                          customRow(
                            children: [
                              customSizedBox(width: 30.w),
                              customText(
                                title: 'Price:\t\t',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              customSizedBox(width: 10.w),
                              customContainer(
                                height: 30.h,
                                width: 100.w,
                                child: CustomTextFormField(
                                  textInputType: TextInputType.number,
                                  controller: provider.price,
                                  borderDecoration: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                            ],
                          ),
                          customSizedBox(height: 30.h),
                          ElevatedButton(
                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(blueAccent)),
                              onPressed: () {
                                if (mounted) {
                                  provider.updateProduct(context, key, mounted, widget.id!);
                                }
                              },
                              child: const Text('Update Product')),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (provider.isLoading) // Show loading indicator when updating
                            const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
  
}


