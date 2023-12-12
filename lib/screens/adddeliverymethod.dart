import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddDeliveryMethod extends StatefulWidget {
  String adminemail = "";
  String pidname = "";
  String idname = "";
  String productname = "";

  AddDeliveryMethod(
      {required this.pidname,
      required this.productname,
      required this.adminemail,
      required this.idname,
      Key? key})
      : super(key: key);

  @override
  _AddDeliveryMethodState createState() => _AddDeliveryMethodState();
}

class _AddDeliveryMethodState extends State<AddDeliveryMethod> {

  bool loading = true;
  int done = 0;

  TextEditingController plan = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController days = TextEditingController();

  Future add_delivery_plan() async{

    setState(() {
      loading = false;
    });

    final response = await http.post(Uri.https('adeoropelumi.com','vendor/vendoradddeliverymethod.php'),body:{
      'idname':widget.idname,
      'pidname':widget.pidname,
      'email':widget.adminemail,
      'plan':plan.text,
      'amount':amount.text,
      'days':days.text,
    });

    if(response.statusCode == 200){
      if(jsonDecode(response.body) == "true"){
        setState(() {
          loading = true;
          done = 1;
          plan.clear();
          amount.clear();
          days.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("New delivery plan is added!"))
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading?
      done == 0 ?
      SafeArea(
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
                    //setting text
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          widget.productname + " Delivery Method",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    //back button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          )),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Delivery Plan",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: plan,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "E.g Within Abuja or inside Abeokuta",
                  hintStyle: TextStyle(
                    color: Colors.grey[300]
                  ),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Delivery Amount",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "E.g 3000 or 4000",
                  hintStyle: TextStyle(
                      color: Colors.grey[300]
                  ),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Delivery Days",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: days,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "E.g 3 or 14",
                  hintStyle: TextStyle(
                      color: Colors.grey[300]
                  ),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (){
                if(plan.text.isEmpty || amount.text.isEmpty || days.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fill days field"))
                  );
                }else{
                  add_delivery_plan();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 123, 55, 1),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text("Add Delivery Plan",style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text("Vendorhive360",style: TextStyle(
                  fontSize: 12
              ),),
            )
          ],
        ),
      )
          :
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.orange.shade100,
                  Colors.green.shade100
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap:(){

                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/3,
                        child: Image.asset("assets/successs.png",),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          done = 0;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text("Click here to go back",style: TextStyle(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width/23
                        ),),
                      ),
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
                    height: MediaQuery.of(context).size.height / 3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Processing",
                      style: TextStyle(
                          color: Color.fromRGBO(246, 123, 55, 1),
                          fontWeight: FontWeight.bold,
                          fontSize:
                          MediaQuery.of(context).size.width / 26),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        'Vendorhive360',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
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
