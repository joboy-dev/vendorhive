import 'dart:convert';

import 'package:vendorandroid/screens/checkoutsecond.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class DeliveryPlan{
  String pidname = "";
  String deliveryplan = "";
  String deliveryprice = "";
  String deliverydays = "";

  DeliveryPlan({required this.pidname, required this.deliveryplan,
  required this.deliveryprice, required this.deliverydays});
}

class Checkout extends StatefulWidget {
  double totalamount = 0;
  double totalamountplusdelivery = 0;
  String idname = "";
  String useremail = "";
  double service_fee = 0;

  Checkout(
      {required this.totalamount,
      required this.totalamountplusdelivery,
      required this.service_fee,
      required this.idname,
      required this.useremail});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String options = "Lagos";
  String drop = "";

  TextEditingController _fname = new TextEditingController();
  TextEditingController _phonenumber = new TextEditingController();
  TextEditingController _street = new TextEditingController();

  List<DropdownMenuItem<String>> dropdownItems = [];
  List items = [];
  List<DeliveryPlan> deliveryItems = [];

  Future get_delivery_method() async{
    for(int i = 0; i < cartitems.length; i++){

      print("============");
      print(cartitems[i].prodid);
      print("============");

      var response = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorgetdeliveryplan.php'),
          body: {
            'pidname': cartitems[i].prodid,
          });

      deliveryItems.add(
          DeliveryPlan(
              pidname: cartitems[i].prodid,
              deliveryplan: "",
              deliveryprice: "",
              deliverydays: ""));

      print("============");
      print(response.statusCode);
      print("============");

      if(response.statusCode == 200){

        print("============");
        print(jsonDecode(response.body));
        print("============");

        setState(() {
          items = jsonDecode(response.body);
          drop = items[0]['price']+"==="+items[0]['days']+"==="+items[0]['plan'];
        });

        dropdownItems = List.generate(
          items.length,
              (index) => DropdownMenuItem(
            value: items[index]['price']+"==="+items[index]['days']+"==="+items[index]['plan'],
            child: Text(
              items[index]['plan'],
              style: TextStyle(fontSize: 17),
            ),
          ),
        );

      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.totalamount);
    print(widget.totalamountplusdelivery);
    get_delivery_method();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //app bar for checkout and back button
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, .5),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Checkout",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
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
              ),
            ),

            //shipment text -> payment text -> Review text
            Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
              decoration:
                  BoxDecoration(color: Color.fromRGBO(238, 252, 233, 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1 text
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width / 23,
                        )),
                    width: MediaQuery.of(context).size.width / 13,
                    height: MediaQuery.of(context).size.width / 13,
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 23,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  //shipment text
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 60,
                      ),
                      child: Text(
                        "Shipment",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 27,
                        ),
                      ),
                    ),
                  ),

                  // -> text
                  Container(
                    child: Text(
                      "->  ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width / 23,
                        )),
                    width: MediaQuery.of(context).size.width / 13,
                    height: MediaQuery.of(context).size.width / 13,
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 23,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 60,
                      ),
                      child: Text(
                        "Payment",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 27,
                        ),
                      ),
                    ),
                  ),

                  // -> text
                  Container(
                    child: Text(
                      "->  ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),

                  // 3 text
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width / 23,
                        )),
                    width: MediaQuery.of(context).size.width / 13,
                    height: MediaQuery.of(context).size.width / 13,
                    child: Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 23,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  //Review text
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 60,
                    ),
                    child: Text(
                      "Review",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 27,
                      ),
                    ),
                  )),
                ],
              ),
            ),

            Flexible(
              child: CustomScrollView(
                  slivers:[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context,index){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // enter your shipping address text
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    "Enter your shiping address",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                  ),
                                ),

                                //enter full name text
                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                    child: Text(
                                      "Enter Full Name",
                                      style: TextStyle(fontSize: 14),
                                    )),

                                //full name text field
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: TextField(
                                      controller: _fname,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: .5),
                                              borderRadius: BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: .5),
                                              borderRadius: BorderRadius.circular(10)))),
                                ),

                                //phone number text
                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                    child: Text(
                                      "Phone number",
                                      style: TextStyle(fontSize: 14),
                                    )),

                                //phone number text field
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: TextField(
                                      controller: _phonenumber,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: .5),
                                              borderRadius: BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: .5),
                                              borderRadius: BorderRadius.circular(10)))),
                                ),

                                //street address text
                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                    child: Text(
                                      "Street Address",
                                      style: TextStyle(fontSize: 14),
                                    )),

                                //street address textfield
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: TextField(
                                      controller: _street,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: .5),
                                              borderRadius: BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: .5),
                                              borderRadius: BorderRadius.circular(10)))),
                                ),

                                //State text
                                Container(
                                    margin: EdgeInsets.only(
                                      left: 10,
                                      top: 10,
                                    ),
                                    child: Text(
                                      "State",
                                      style: TextStyle(fontSize: 14),
                                    )),

                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        //background color of dropdown button
                                        border: Border.all(color: Colors.grey, width: 1),
                                        //border of dropdown button
                                        borderRadius: BorderRadius.circular(
                                            10), //border raiuds of dropdown button
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 20, right: 20),
                                          child: DropdownButton(
                                            value: options,
                                            //add states in the dropdown
                                            items: [
                                              // 1st state Abia
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Abia",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Abia",
                                              ),
                                              //2nd state Adamawa
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Adamawa",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Adamawa",
                                              ),
                                              //3rd state Akwa Ibom
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Akwa Ibom",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Akwa Ibom",
                                              ),
                                              //4th state Anambra
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Anambra",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Anambra",
                                              ),
                                              //5th state Bauchi
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Bauchi",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Bauchi",
                                              ),
                                              //6th state Bayelsa
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Bayelsa",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Bayelsa",
                                              ),
                                              //7th state Benue
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Benue",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Benue",
                                              ),
                                              //8th state Borno
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Borno",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Borno",
                                              ),
                                              //9th state Cross River
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Cross River",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Cross River",
                                              ),
                                              //10th state Delta
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Delta",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Delta",
                                              ),
                                              //11th state Ebonyi
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Ebonyi",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Ebonyi",
                                              ),
                                              //12th state Edo
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Edo",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Edo",
                                              ),
                                              //13th state Ekiti
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Ekiti",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Ekiti",
                                              ),
                                              //14th state Enugu
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Enugu",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Enugu",
                                              ),
                                              //15th state Gombe
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Gombe",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Gombe",
                                              ),
                                              //16th state Imo
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Imo",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Imo",
                                              ),
                                              //17th state Jigawa
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Jigawa",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Jigawa",
                                              ),
                                              //18th state Kaduna
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Kaduna",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Kaduna",
                                              ),
                                              //19th state Kano
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Kano",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Kano",
                                              ),
                                              //20th state Katsina
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Katsina",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Katsina",
                                              ),
                                              //21th state Kebbi
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Kebbi",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Kebbi",
                                              ),
                                              //22th state kogi
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Kogi",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Kogi",
                                              ),
                                              //23th state Kwara
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Kwara",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Kwara",
                                              ),
                                              //24th state Lagos
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Lagos",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Lagos",
                                              ),
                                              //25th state Nasarawa
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Nasarawa",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Nasarawa",
                                              ),
                                              //26th state Niger
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Niger",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Niger",
                                              ),
                                              //27th  state Ogun
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Ogun",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Ogun",
                                              ),
                                              //28th state Ondo
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Ondo",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Ondo",
                                              ),
                                              //29th state Osun
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Osun",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Osun",
                                              ),
                                              //30th state Oyo
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Oyo",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Oyo",
                                              ),
                                              //31st state Plateau
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Plateau",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Plateau",
                                              ),
                                              //32nd state Rivers
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Rivers",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Rivers",
                                              ),
                                              //33rd state Sokoto
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Sokoto",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Sokoto",
                                              ),
                                              //34th state Taraba
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Taraba",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Taraba",
                                              ),
                                              //35th state Yobe
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Yobe",
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                value: "Yobe",
                                              ),
                                              //36th state Zamfara
                                              DropdownMenuItem(
                                                  child: Text(
                                                    "Zamfara",
                                                    style: TextStyle(fontSize: 17),
                                                  ),
                                                  value: "Zamfara"),
                                            ],
                                            onChanged: (value) {
                                              //get value when changed
                                              setState(() {
                                                options = value!;
                                              });
                                              print("You have selected $value");
                                            },
                                            icon: Padding(
                                              //Icon at tail, arrow bottom is default icon
                                                padding: EdgeInsets.only(left: 20),
                                                child: Icon(Icons.arrow_drop_down)),
                                            iconEnabledColor: Colors.white,
                                            //Icon color
                                            style: TextStyle(
                                              //te
                                                color: Colors.white, //Font color
                                                fontSize: 20 //font size on dropdown button
                                            ),

                                            dropdownColor: Colors.grey,
                                            //dropdown background color
                                            underline: Container(),
                                            //remove underline
                                            isExpanded: true, //make true to make width 100%
                                          ))),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    if (_fname.text.isEmpty ||
                                        _phonenumber.text.isEmpty ||
                                        _street.text.isEmpty) {
                                      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                                        content: Text('Fill all fields'),
                                      ));
                                    } else {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return CheckoutSecond(
                                              totalamount: widget.totalamount,
                                              totalamountplusdelivery:
                                              widget.totalamountplusdelivery,
                                              fullname: _fname.text,
                                              phonenumber: _phonenumber.text,
                                              streetaddress: _street.text,
                                              state: options,
                                              idname: widget.idname,
                                              useremail: widget.useremail,
                                              service_fee: widget.service_fee,
                                            );
                                          }));
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: 10, left: 10, right: 10, top: 20),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(246, 123, 55, 1),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        childCount: 1,
                      ),
                    ),
                  ]
              ),
            ),

          ],
        ),
      ),
    );
  }
}
