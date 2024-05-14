
// ignore_for_file: must_be_immutable

import 'package:assignment/components/common_widgets.dart';
import 'package:assignment/models/carousal_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarousalDesign extends StatelessWidget {
  CarousalDesign({super.key});

FirebaseFirestore fireStore = FirebaseFirestore.instance;

      Stream getCarousalData(){
        return fireStore.collection('carousal').snapshots();
      }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.28,
      child: 
          StreamBuilder(stream: getCarousalData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasData){
              return customSizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.225,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                child: CarouselSlider.builder(
                  itemCount: snapshot.data!.docs.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    pauseAutoPlayOnTouch: true,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    CarousalModel carousal = CarousalModel.fromJson(snapshot.data!.docs[index].data());
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(image: NetworkImage(carousal.images.toString())),
                    );
                  },
                ),
              ),
            );
          
            }else{
              return Center(child: customText(title: "No Fetch Data"));
            }
            
          },
          ),
      
      );
  }
}