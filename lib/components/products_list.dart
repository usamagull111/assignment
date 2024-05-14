import 'package:assignment/components/colors.dart';
import 'package:assignment/components/common_widgets.dart';
import 'package:assignment/components/send_fcm.dart';
import 'package:assignment/views/dialogs/item_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:assignment/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ProductModel>>.value(
      value: FirebaseFirestore.instance
          .collection('ProductAdded')
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) =>
                  ProductModel.fromJson(doc.data()))
              .toList();
        } catch (e) {
          // Handle the exception by logging or displaying an error message
          debugPrint('Failed to parse product data: $e');
          return <ProductModel>[]; // Return an empty list on failure
        }
      }),
      initialData: const [],
      child: Consumer<List<ProductModel>>(
        builder: (context, products, child) {
          return Expanded(
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ItemDetailsDialog(
                            imageUrl: products[index].imageUrl,
                            id: products[index].id,
                            );
                      },
                    );
                                    },
                  child: Card(
                    child: customStack(
                      children: [
                        Image.network(products[index].imageUrl ?? '',
                            fit: BoxFit.fill),
                        Positioned(
                            top: 120.h,
                            child: customText(title: "Name: ${products[index].productName}")),
                        Positioned(
                            top: 135.h,
                            child: customText(title: 'Price: ${products[index].productPrice}\$')),
                        InkWell(
                            child: Positioned(
                                //top: 135.h,
                                left: 1000.w,
                                child: Icon(
                                  Icons.delete,
                                  color: red,
                                  size: 25.h,
                                )),
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('ProductAdded')
                                  .doc(products[index].id)
                                  .delete()
                                  .then((_) async {
                                debugPrint('Product successfully deleted');
                                await sendFCMNotification(
                                    context, products[index].productName);
                              }).catchError((error) {
                                debugPrint('Failed to delete product: $error');
                              });
                            })
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> sendFCMNotification(
      BuildContext context, String? productName) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('productDeletedNotifications').add({
        'token': token,
        'productName': productName,
        'message': 'Product deleted successfully',
        'time': DateTime.now().toIso8601String(),
      });
      await sendMessageToFCM(token, 'Deleted', 'Product deleted successfully');
    }
  }
}
