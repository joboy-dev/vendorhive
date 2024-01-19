import 'dart:convert';

import 'package:vendorandroid/screens/productadded.dart';
import 'package:vendorandroid/screens/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  String idname = "";
  String pidname = "";
  String usermail = "";
  String packagename = "";
  String usertype = "";
  Product({required this.idname, required this.pidname, required this.usermail, required this.packagename,required this.usertype});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String option = "Pay on Delivery";
  String appstatus = "Vendorhive360";

  void deliverydetails(){
    print(widget.idname);
    print(widget.pidname);
    print(widget.usermail);
  }

  Future adddelivery() async {

    deliverydetails();

    setState(() {
      appstatus = "loading...";
    });

   try{
     final addproductdelivery = await http.post(Uri.https('vendorhive360.com','vendor/vendoraddproductdelivery.php'),body: {
       'idname':widget.idname,
       'pidname': widget.pidname,
       'useremail' : widget.usermail,
       'deliveryoption': option
     });

     if(addproductdelivery.statusCode == 200){
       if(jsonDecode(addproductdelivery.body)=="delivery is registered"){
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
           return  ProductAdded(idname: widget.idname, username: widget.usermail,useremail: widget.usermail,packagename: widget.packagename,usertype: widget.usertype,);
         }), (r){
           return false;
         });
       }
     }
   }catch(e){
     print(e);
   }

    setState(() {
      appstatus = "Vendorhive360";
    });
  }

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Add Products",
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
            Container(
              margin: EdgeInsets.only(left: 10,top: 20),
              child: Text("Delivery Options"),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 20),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:Colors.grey, //background color of dropdown button
                    border: Border.all(color: Colors.grey, width:1), //border of dropdown button
                    borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                    // boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                    //   BoxShadow(
                    //       // color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                    //       // blurRadius: 5
                    //   ) //blur radius of shadow
                    // ]
                  ),

                  child:Padding(
                      padding: EdgeInsets.only(left:20, right:20),
                      child:DropdownButton(
                        value: option,
                        items: [ //add items in the dropdown
                          DropdownMenuItem(
                            child: Text("Pay on Delivery",style: TextStyle(
                                fontSize: 17
                            ),),
                            value: "Pay on Delivery",
                          ),
                          DropdownMenuItem(
                              child: Text("Pay Online",style: TextStyle(
                                  fontSize: 17
                              ),),
                              value: "Pay Online"
                          ),


                        ],
                        onChanged: (value){ //get value when changed
                          setState(() {
                            option = value!;
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
            Spacer(),
            GestureDetector(
              onTap: (){
                adddelivery();
                // Navigator.push(context, MaterialPageRoute(builder: (context){
                //   return Service();
                // }));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10,0),
                padding: EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 123, 55, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("NEXT",style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),)),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(appstatus,style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
