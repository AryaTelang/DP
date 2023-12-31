import 'dart:io';

import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FailScreen extends StatelessWidget {
  const FailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height,width,size;
    size=MediaQuery.of(context).size;
    height=size.height;
    width=size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Platform.isIOS ? AppBar() : null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              Image.asset('assets/images/failure.png',height: 100,width: 100,),
              SizedBox(height: 20,),
              Text(
                'Failure',
                style: poppinsBold20.copyWith(fontSize: 36),
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("KYC type",
                    style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                  SizedBox(width: width*0.45,),
                  Text("Minimum",style: TextStyle(fontWeight: FontWeight.w700),),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Reciever Email",
                    style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                  SizedBox(width: width*0.3,),
                  Text("Reciever Email",style: TextStyle(fontWeight: FontWeight.w700),),
                ],
              ),
              SizedBox(height: 10,),

              Row(

                children:
                [
                  SizedBox(width: 20,),
                  Text("Date",
                    style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                  SizedBox(width: width*0.6,),
                  Align(alignment:AlignmentDirectional.bottomEnd,child: Text("Date",style: TextStyle(fontWeight: FontWeight.w700),)),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Amount",
                    style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                  SizedBox(width: width*0.55,),
                  Text("Rs.7",style: TextStyle(fontWeight: FontWeight.w700),),
                ],
              ),

               SizedBox(
                height: height/3,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: width,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4147d5),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _spacer16() {
    return const SizedBox(
      height: 16,
    );
  }
}
