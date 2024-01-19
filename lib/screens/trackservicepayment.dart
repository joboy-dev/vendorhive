import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/rateproduct.dart';
import 'package:vendorandroid/screens/rateservice.dart';

class TrackServicePayment extends StatefulWidget {
  String idname = "";
  String sidname = "";
  String servicename = "";
  String adminemail = "";
  String useremail = "";
  String amount = "";
  String date = "";
  String time = "";
  String refno = "";
  String description  = "";
  String status = "";
  String refund = "";
  TrackServicePayment({
    required this.idname,
    required this.sidname,
  required this.servicename,
  required this.adminemail,
  required this.useremail,
  required this.amount,
  required this.date,
  required this.time,
  required this.status,
  required this.description,
  required this.refno,
  required this.refund});

  @override
  _TrackServicePaymentState createState() => _TrackServicePaymentState();
}

class _TrackServicePaymentState extends State<TrackServicePayment> {

  Future releasepayment() async{
    print("service payment release is processing");

    var updatebusinesswallet = await http.post(Uri.https('vendorhive360.com','vendor/vendorupdatebusinesswallet.php'),body: {
      'pidname':widget.sidname,
      'useremail':widget.useremail,
      'adminemail':widget.adminemail
    });

    var updateservicepayment = await http.post(Uri.https('vendorhive360.com','vendor/vendorupdateservicepayment.php'),body: {
      'sidname':widget.sidname,
      'useremail':widget.useremail,
      'adminemail':widget.adminemail
    });

    if(updatebusinesswallet.statusCode == 200){
      print("business api reached");
      if(jsonDecode(updatebusinesswallet.body)=='true'){
        print("business api returned value");
        if(updateservicepayment.statusCode == 200){
          if(jsonDecode(updateservicepayment.body)=='true'){
            Navigator.of(context).pop();
            print('Service payment is released');
            setState(() {
              widget.status = 'complete';
            });
          }
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 712));
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: [

              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, .5),
                ),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Track Payment",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Flexible(
                  child: ListView(
                children: [

                  Container(
                    padding: EdgeInsets.only(bottom: 10,top: 10),
                    child: Center(
                      child: Text('Date of Payment',style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text(widget.date,style: TextStyle(
                        fontSize: 14
                      ),),
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                    padding: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(80, 200, 120, .5)
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: Text("Amount: ",style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text("₦"+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Container(
                                child: Text("Service Name: ",style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(widget.servicename),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Container(
                                child: Text("Description: ",style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(widget.description),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Container(
                                child: Text("Time: ",style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(widget.time),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Container(
                                child: Text("Beneficary: ",style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(widget.adminemail),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      if(widget.status == 'complete'){
                        print("Processing refund");
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return RateService(adminemail: widget.adminemail,
                          sidname: widget.sidname,
                          servicename: widget.servicename,
                          useremail: widget.useremail,
                          serviceimage: '',);
                        }));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 30,bottom: 20).r,
                      padding: EdgeInsets.symmetric(vertical: 20).r,
                      decoration: BoxDecoration(
                        // color: dpreleased == 'undone' ?Color.fromRGBO(211, 211, 211, 1) :
                        // Color.fromRGBO(14, 44, 3, 1),
                          color: widget.refund == 'no'?
                          Color.fromRGBO(246, 123, 55, 1):
                          Color.fromRGBO(211, 211, 211, 1),
                          borderRadius: BorderRadius.circular(10).w
                      ),
                      child: Center(
                        child: Text(widget.refund == 'no'?
                        "Rate Service":
                        "Rated",style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp
                        ),),
                      ),
                    ),
                  ),

                ],
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}
