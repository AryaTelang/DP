import 'dart:io';

import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

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
              SizedBox(height: 30,),

              Image.asset('assets/images/pending.png',height: 100,width: 100,),
              SizedBox(height: 20,),
              Text(
                'Pending',
                style: poppinsBold20.copyWith(fontSize: 36),
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Payment Status",
                    style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                  SizedBox(width: width*0.35,),
                  Text("Pending",style: TextStyle(fontWeight: FontWeight.w700,color:Color(0xffF59E18) ),),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Order ID",
                    style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                  SizedBox(width: width*0.5,),
                  Text("Order ID",style: TextStyle(fontWeight: FontWeight.w700,color:Color(0xffF59E18) ),),
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
