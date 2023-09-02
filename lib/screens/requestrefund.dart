import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/success.dart';

class RequestRefund extends StatefulWidget {
  String idname = "";
  String email = "";
  String amount = "";
  String refno = "";

  RequestRefund({Key? key,
    required this.idname,
    required this.email,
    required this.amount,
    required this.refno
  }) : super(key: key);

  @override
  _RequestRefundState createState() => _RequestRefundState();
}

enum Fruit {
  apple,
  banana,
  lemon,
  grapes
}

class _RequestRefundState extends State<RequestRefund> {
  Fruit? _fruit = Fruit.apple;
  int _selectedpage = 0;
  String reason = "Product did not match description";
  String trfid = "";

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

  Future requestrefund() async{

    currentdate();

    setState(() {
      _selectedpage = 1;
    });

    try{

      var refundrequest = await http.post(
          Uri.https('adeoropelumi.com','vendor/requestrefund.php'),
          body: {
            'idname':widget.idname,
            'email':widget.email,
            'reason': reason,
            'refno':widget.refno,
            'amount': widget.amount,
          }
      );

      if(refundrequest.statusCode == 200){
        if(jsonDecode(refundrequest.body) == "true"){

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Success();
          }));

        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: widget.idname);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: widget.idname);
        }));

      }

    }
    catch(e){

      setState(() {
        _selectedpage = 0;
      });

      var failedrefund = await http.post(
        Uri.https('adeoropelumi.com','vendor/failedrefund.php'),
        body: {
          'idname': widget.idname
        }
      );

      if(failedrefund.statusCode == 200){
        if(jsonDecode(failedrefund.body) == "true"){

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: widget.idname);
          }));

        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: widget.idname);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: widget.idname);
        }));

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0?
      SafeArea(
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
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Request for Refund",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        )
                    ),
                  )
                ],
              ),
            ),
            Flexible(
                child: ListView(
              padding: EdgeInsets.zero,
              children: [

                Container(
                  margin: EdgeInsets.only(top: 20,left: 10),
                  child: Text("Why are you requesting for refund",style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/20,
                    fontWeight: FontWeight.w500
                  ),),
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Radio<Fruit>(
                        fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.black),
                        value: Fruit.apple,
                        groupValue: _fruit,
                        onChanged: (Fruit? value) {
                          setState(() {
                            _fruit = value;
                            reason = "Product did not match description";
                          });
                         print("Product did not match description");
                        },
                      ),

                      Expanded(
                        child: Container(
                          child: Text("Product did not match description",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/26
                          ),),
                        ),
                      )

                    ],
                  ),
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Radio<Fruit>(
                        fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.black),
                        value: Fruit.banana,
                        groupValue: _fruit,
                        onChanged: (Fruit? value) {
                          setState(() {
                            _fruit = value;
                            reason = "Order did not arrive on time";
                          });
                          print("Order did not arrive on time");
                        },
                      ),

                      Expanded(
                        child: Container(
                          child: Text("Order did not arrive on time",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/26
                          ),),
                        ),
                      )

                    ],
                  ),
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<Fruit>(
                        fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.black),
                        value: Fruit.lemon,
                        groupValue: _fruit,
                        onChanged: (Fruit? value) {
                          setState(() {
                            _fruit = value;
                            reason = "Vendor did not deliver";
                          });
                          print("Vendor did not deliver");
                        },
                      ),
                      Expanded(
                        child: Container(
                          child: Text("Vendor did not deliver",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/26
                          ),),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Radio<Fruit>(
                        fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.black),
                        value: Fruit.grapes,
                        groupValue: _fruit,
                        onChanged: (Fruit? value) {
                          setState(() {
                            _fruit = value;
                            reason = "Other";
                          });
                          print("Other");
                        },
                      ),

                      Expanded(
                        child: Container(
                          child: Text("Other",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/26
                          ),),
                        ),
                      )

                    ],
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    requestrefund();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Create Request",style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                    ),)),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(14, 44, 3, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Go Back",style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                    ),)),
                  ),
                ),

                Container(
                  child: Center(
                    child: Text("Vendorhive",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/26,
                      fontStyle: FontStyle.italic
                    ),),
                  ),
                )

              ],
            )),
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
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  // CircularProgressIndicator(
                  //   color: Colors.orange,
                  // ),
                  Container(
                    child: Text("Processing refund",style: TextStyle(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text('Vendorhive 360',style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
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
