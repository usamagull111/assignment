import 'dart:io';

import 'package:assignment/components/common_widgets.dart';
import 'package:assignment/components/send_fcm.dart';
import 'package:assignment/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageDetailsProvider with ChangeNotifier {
  File? image;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  final picker = ImagePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isLoading = false;

  Future<void> getImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<String?> uploadImageAndGetUrl() async {
    if (image != null) {
      var fileExtension = image!.path.split('.').last;
      var fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      var firebaseStorageRef = storage.ref().child('product_images/$fileName');
      await firebaseStorageRef.putFile(image!);
      String imageUrl = await firebaseStorageRef.getDownloadURL();
      return imageUrl;
    }
    return null;
  }

  Future<void> addProduct(BuildContext context, GlobalKey<FormState> key, bool isMounted) async {
    if (key.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      String? imageUrl = await uploadImageAndGetUrl();
      if (imageUrl != null) {
        var dateOfTime = DateTime.now().microsecondsSinceEpoch.toString();
        ProductModel productModel = ProductModel(
          id: "$dateOfTime${currentUser!.uid}",
          productName: name.text,
          productPrice: price.text,
          imageUrl: imageUrl
        );

        await firestore.collection("ProductAdded").doc(productModel.id)
            .set(productModel.toJson()).then((value) async {
              
                await sendFCMNotification(context, productModel.productName);
                isLoading = false;
                notifyListeners();
                Navigator.pop(context);
              
        }).onError((error, stackTrace) {
          if (isMounted) {
            isLoading = false;
            notifyListeners();
            customSnackBar(context: context, message: "Error ${error.toString()}");
          }
        });
      } else {
        if (isMounted) {
          isLoading = false;
          notifyListeners();
          customSnackBar(context: context, message: "Failed to upload image");
        }
      }
    }
  }

  @override
  void dispose() {
    name.dispose();
    price.dispose();
    super.dispose();
  }
  Future<void> sendFCMNotification(BuildContext context,String? productName) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      
      await FirebaseFirestore.instance.collection('ProductAddedNotification').add({
        'token': token,
        'productName': productName,
        'message': 'Product $productName Added Successfully',
        'time': DateTime.now().toIso8601String(),
      });
       await sendMessageToFCM(token, 'Added', 'Product Added Successfully');
      // Listen to the incoming FCM messages
      
    }
  }
}