import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/viewearnings.dart';

class Refers extends StatefulWidget {
  String idname = "";
  String email = "";
  Refers({Key? key, required this.idname,
  required this.email}) : super(key: key);

  @override
  _RefersState createState() => _RefersState();
}

class _RefersState extends State<Refers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text("Refer and Earn",style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/20,
                    fontWeight: FontWeight.w500
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 10,right: 10),
              child: Text("Now is the time to refer any of your friend and Earn. Let them paste your refer code while your friend sign up and you earn. Yay!!!",textAlign: TextAlign.center, style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                // fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
              ),),
            ),
            Container(
              margin: EdgeInsets.only(top: 30,bottom: 30),
              height: MediaQuery.of(context).size.width/1.5,
              child: Image.asset("assets/meet.png",),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 252, 233, 1),
                borderRadius: BorderRadius.circular(20)
              ),
              margin: EdgeInsets.only(left: 20,right: 20),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(20),
                padding: EdgeInsets.only(bottom: 10,top: 10),
                color: Colors.black26,
                child: ClipRRect(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                        onLongPress:(){
                          Clipboard.setData(ClipboardData(text: widget.idname));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Copied to Clipboard"),
                          ));
                        },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(widget.idname,style: TextStyle(
                              color: Colors.black26,
                              fontSize: MediaQuery.of(context).size.width/21,
                            ),),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onLongPress: (){
                          Clipboard.setData(ClipboardData(text: widget.idname));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Copied to Clipboard"),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(14, 44, 3, 1),
                            borderRadius: BorderRadius.circular(22)
                          ),
                          padding: EdgeInsets.only(top: 15,right: 15,left: 15,bottom: 15),
                          margin: EdgeInsets.only(right: 10,left: 5),
                          child: Icon(Icons.file_copy,color: Colors.white,
                          size: MediaQuery.of(context).size.width/20,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ViewEarnings(idname: widget.idname, email: widget.email);
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(14, 44, 3, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                padding: EdgeInsets.only(top: 15,bottom: 15),
                child: Center(
                    child: Text("View Earnings",textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width/22,
                      fontWeight: FontWeight.bold
                    ),)
                ),
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
                margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                padding: EdgeInsets.only(top: 15,bottom: 15),
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
      ),
    );
  }
}
