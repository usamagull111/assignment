import 'dart:io';

import 'package:assignment/components/send_fcm.dart';
import 'package:assignment/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemDetailsProvider with ChangeNotifier {
  File? image;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  final picker = ImagePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isLoading = false; // Added to track loading state

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

  Future<void> updateProduct(BuildContext context, GlobalKey<FormState> key, bool isMounted, String documentId) async {
    if (key.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      String? imageUrl = await uploadImageAndGetUrl();
      if (imageUrl != null) {
        ProductModel productModel = ProductModel(
          id: documentId,
          productName: name.text,
          productPrice: price.text,
          imageUrl: imageUrl
        );

        var documentReference = firestore.collection("ProductAdded").doc(documentId);
        await documentReference.update(productModel.toJson()).then((value) async {
          await sendFCMNotification(productModel.productName, context);
          if (isMounted) {
            isLoading = false;
            notifyListeners();
          }
        }).catchError((error) {
          if (isMounted) {
            isLoading = false;
            notifyListeners();
          }
        });
      } else {
        isLoading = false;
        notifyListeners();
        // Pass context here if needed, or handle error differently
      }
    }
  }

  @override
  void dispose() {
    name.dispose();
    price.dispose();
    super.dispose();
  }
  Future<void> sendFCMNotification(String? productName, BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      
      await FirebaseFirestore.instance.collection('ProductUpdatedNotifications').add({
        'token': token,
        
        'productName': productName,
        'message': 'Product $productName Updated Successfully',
        'time': DateTime.now().toIso8601String(),
      });
       await sendMessageToFCM(token, 'Added', 'Product $productName Updated Successfully');
       Navigator.pop(context);
      // Listen to the incoming FCM messages
      
    }
  }
}