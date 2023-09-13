import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/selectpayforservice.dart';
import 'package:vendorandroid/screens/successfulpayment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:pattern_formatter/pattern_formatter.dart';
// import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';

class PayforService extends StatefulWidget {
  String idname = "";
  String sidname = "";
  String useremail = "";
  String adminemail = "";
  String servicename  = "";
  PayforService({required this.idname,
  required this.sidname,
  required this.useremail,
  required this.adminemail,
  required this.servicename});

  @override
  _PayforServiceState createState() => _PayforServiceState();
}

class _PayforServiceState extends State<PayforService> {
  int _selectedpage = 0;
  TextEditingController _amount = new TextEditingController();
  TextEditingController _description = new TextEditingController();

  String replacing(String word) {
    word = word.replaceAll("'", "");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 712));
    return Scaffold(
      body: _selectedpage == 0 ?
      SafeArea(
        child: Column(
          children: [
            //pay with vendor email and back button
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, .5),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Pay " + widget.adminemail,style: TextStyle(
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

            //payment form
            Flexible(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    //amount text
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: Text("Amount",style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26
                      ),),
                    ),
                    //amount textfield
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: TextField(
                        controller: _amount,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          ThousandsFormatter(allowFraction: true)
                        ],
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(

                            ),
                            focusedBorder: OutlineInputBorder(

                            )
                        ),
                      ),
                    ),

                    //reason for payment text
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: Text("Reason for payment",style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/26
                      ),),
                    ),
                    //reason for payment textfield
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: TextField(
                        controller: _description,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder()
                        ),
                      ),
                    ),

                    //pay button
                    GestureDetector(
                      onTap: () {
                        print(_amount.text);
                        print(_amount.text.replaceAll(",", ''));
                        if(_amount.text.isEmpty || _description.text.isEmpty){
                          ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text('Fill all fields'),
                              ));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SelectPayforService(
                              idname: widget.idname,
                              useremail: widget.useremail,
                              adminemail: widget.adminemail,
                              amount: _amount.text.replaceAll(",", ''),
                            desc: replacing(_description.text),
                            sidname: widget.sidname,
                            servicename: widget.servicename,);
                          }));
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.orangeAccent
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green
                          ),
                          child: Center(
                            child: Text("Pay", style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/16,
                                color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),),
                          )
                      ),
                    )
                  ],
                )
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  Container(
                    child: Text("Processing payment", style: TextStyle(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      fontWeight: FontWeight.bold,

                    ),),
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
