import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/businessselectpackagepayment.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/selectpackagepayment.dart';

class BusinessPackage extends StatefulWidget {
  String email = "";
  String idname = "";
  BusinessPackage({Key? key,
    required this.email,
    required this.idname}) : super(key: key);

  @override
  _BusinessPackageState createState() => _BusinessPackageState();
}

class _BusinessPackageState extends State<BusinessPackage> {

  String drop = "Alpha";
  int _selectedpage = 0;

  String trfid = "";
  String finalbalance = "";
  int itemnumbers = 0;

  String amount = "";

  void currentdate(){
    print('Timestamp is gotten as refno');
    DateTime now = new DateTime.now();
    print(now.toString());
    timestamp(now.toString());
    trfid = timestamp(now.toString());
    print(trfid);
  }

  String timestamp(String str){
    str = str.replaceAll(":", "");
    str = str.replaceAll("-", "");
    str = str.replaceAll(".", "");
    str = str.replaceAll(" ", "");
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage ==0 ?
      SafeArea(
        child: ListView(
          children: [
            //Packages Title
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text("Packages",style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/20,
                    fontWeight: FontWeight.w500
                ),),
              ),
            ),

            //packages subtitle
            Container(
              margin: EdgeInsets.only(left: 15,right: 15,top: 20),
              child: Text("Choose a package to enjoy extra upload of services and products for your customers to generate more sales.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/25,
                ),),
            ),

            //Omega package - 2500
            Container(
              margin: EdgeInsets.only(top: 40,left: 10),
              child: Row(
                children: [
                  Container(
                    height:MediaQuery.of(context).size.width/6,
                    child: Image.asset("assets/businessomega.png",),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("OMEGA PACKAGE - ₦2,500",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/23,
                                fontWeight: FontWeight.w500
                            ),),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5,top: 2),
                              child: Text("\u2022 Upload 10 more services",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("\u2022 Upload 10 more products plus short videos.",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("\u2022 One Year",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            //Beta package - 5000
            Container(
              margin: EdgeInsets.only(top: 20,left: 10),
              child: Row(
                children: [
                  Container(
                    height:MediaQuery.of(context).size.width/6,
                    child: Image.asset("assets/businessbeta.png",),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("BETA PACKAGE - ₦5,000",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/23,
                                fontWeight: FontWeight.w500
                            ),),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5,top: 2),
                              child: Text("\u2022 Upload 15 more services",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("\u2022 Upload 15 more products plus short videos.",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("\u2022 One Year",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            //Alpha package - 10000
            Container(
              margin: EdgeInsets.only(top: 20,left: 10),
              child: Row(
                children: [
                  Container(
                    height:MediaQuery.of(context).size.width/6,
                    child: Image.asset("assets/businessalpha.png"),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("ALPHA PACKAGE - ₦10,000",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/23,
                                fontWeight: FontWeight.w500
                            ),),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5,top: 2),
                              child: Text("\u2022 Upload 20 more services",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("\u2022 Upload 30 more products plus short videos.",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("\u2022 One Year",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27
                              ),)
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 10,top: 60),
              child: Text("Select Package",style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/25
              ),),
            ),

            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:Colors.grey, //background color of dropdown button
                    border: Border.all(color: Colors.grey, width:1), //border of dropdown button
                    borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                  ),

                  child:Padding(
                      padding: EdgeInsets.only(left:20, right:20),
                      child:DropdownButton(
                        value: drop,
                        items: [ //add items in the dropdown
                          DropdownMenuItem(
                            child: Text("Alpha Pacakage - ₦10,000",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/22
                            ),),
                            value: "Alpha",
                          ),
                          DropdownMenuItem(
                              child: Text("Beta Pacakage - ₦5,000",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/22
                              ),),
                              value: "Beta"
                          ),
                          DropdownMenuItem(
                            child: Text("Omega Pacakage - ₦2,500",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/22
                            ),),
                            value: "Omega",
                          )

                        ],
                        onChanged: (value){ //get value when changed
                          setState(() {
                            drop = value!;
                          });
                          print("You have selected $value");
                        },
                        icon: Padding( //Icon at tail, arrow bottom is default icon
                            padding: EdgeInsets.only(left:20),
                            child:Icon(Icons.arrow_drop_down)
                        ),
                        iconEnabledColor: Colors.white, //Icon color
                        style: TextStyle(  //te
                            color: Colors.white, //Font color
                            fontSize: 20 //font size on dropdown button
                        ),

                        dropdownColor: Colors.grey, //dropdown background color
                        underline: Container(), //remove underline
                        isExpanded: true, //make true to make width 100%
                      )
                  )
              ),
            ),

            GestureDetector(
              onTap: (){
                if(drop == 'Alpha'){
                  amount = "10000";
                  // amount = "100";
                }else if(drop == "Beta"){
                  amount = "5000";
                  // amount = "100";
                }else if(drop == "Omega"){
                  amount = "2500";
                  // amount = "100";
                }

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return BusinessSelectPackagePayment(idname: widget.idname,
                      email: widget.email,
                      amount: amount,
                      package: drop);
                }));
              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(14, 44, 3, 1)
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(14, 44, 3, 1)
                ),
                padding: EdgeInsets.only(top: 15,bottom: 15),
                child: Center(child: Text("Purchase Package",style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width/22
                ),)),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 123, 55, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                padding: EdgeInsets.only(top: 13,bottom: 13),
                child: Center(
                    child: Text("Go Back",style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/22,
                        fontWeight: FontWeight.bold
                    ),)
                ),
              ),
            ),
          ],
        ),
      )
          :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    child: Image.asset("assets/processing.png",color: Color.fromRGBO(14, 44, 3, 1),),
                  ),
                  Container(
                    child: Text("Processing payment",style: TextStyle(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width/24
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text('Vendorhive360',style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
