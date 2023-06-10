import 'package:bachat_cards/screens/bottom_nav_bar_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoucherCardNew extends StatefulWidget {
  const VoucherCardNew({Key? key}) : super(key: key);

  @override
  State<VoucherCardNew> createState() => _VoucherCardNewState();
}

class _VoucherCardNewState extends State<VoucherCardNew> {
  List<Map<String, dynamic>> _allVouchers = [
    {
      "Voucher code": 1203,
      "Voucher Pin": "311322",
      "Order": "MBM0001",
      "image": 'assets/images/qr.png'
    },
    {
      "Voucher code": 1204,
      "Voucher Pin": "33122",
      "Order": "MB00391",
      "image": 'assets/images/qr.png'
    },
    {
      "Voucher code": 1205,
      "Voucher Pin": "332342",
      "Order": "MB33001",
      "image": 'assets/images/qr.png'
    },
    {
      "Voucher code": 1201,
      "Voucher Pin": "339122",
      "Order": "MB223001",
      "image": 'assets/images/qr.png'
    }
  ];

  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff7C64FF), Color(0xff130078)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    "assets/images/profile.png",
                    height: 50,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ],
                  color: Colors.white),
              width: width,
              height: height*0.8,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _allVouchers.length,
                itemBuilder: (context, index) => Container(
                  height: 180,
                  child: Card(
                    key: ValueKey(_allVouchers[index]["Voucher code"]),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListTile(
                      leading: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Voucher Code",
                                style: TextStyle(color: Color(0xffE97639))),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _allVouchers[index]["Voucher code"].toString(),
                              style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700),
                            ),
                          ),

                          Align(

                            alignment: Alignment.centerLeft,
                            child: Text("Order",
                                style: TextStyle(color: Color(0xffE97639))),
                          ),
                          Align(

                            alignment: Alignment.centerLeft,
                            child: Text(_allVouchers[index]["Order"],
                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700)),
                          ),
                          Align(

                            alignment: Alignment.centerLeft,
                            child: Text("View Balance",
                                style: TextStyle(color: Color(0xff428BC1))),
                          ),
                        ],
                      ),
                      subtitle: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            'assets/images/qr.png',
                            height:90,
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
