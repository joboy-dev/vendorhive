import 'dart:convert';
import 'dart:math';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';
import 'package:vendorandroid/screens/cart.dart';
import 'package:vendorandroid/screens/checkoutfinal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';

class CheckoutFourth extends StatefulWidget {
  double totalamount = 0;
  double totalamountplusdelivery = 0;
  String fullname = "";
  String phonenumber = "";
  String streetaddress = "";
  String state = "";
  String paymentmethod = "";
  String idname = "";
  String useremail = "";
  double service_fee = 0;
  String username = "";

  CheckoutFourth({required this.username, required this.totalamount, required this.totalamountplusdelivery,
    required this.fullname, required this.phonenumber, required this.streetaddress,
    required this.state, required this.paymentmethod,
  required this.idname, required this.useremail, required this.service_fee});

  @override
  _CheckoutFourthState createState() => _CheckoutFourthState();
}

class _CheckoutFourthState extends State<CheckoutFourth> {

  TextEditingController pin1 = new TextEditingController();
  TextEditingController pin2 = new TextEditingController();
  TextEditingController pin3 = new TextEditingController();
  TextEditingController pin4 = new TextEditingController();

  int _selectedpage = 0;
  String trfid = "";
  String finalbalance = "";
  int itemnumbers = 0;

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

  String replacing(String word) {
    word = word.replaceAll("'", "");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  Future processpayment() async{

    print(cartitems.length);

    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();

    try{

      final procespayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorpinprocess.php'),
          body: {
            'idname':widget.idname,
            'useremail':widget.useremail,
            'pin':pin1.text+pin2.text+pin3.text+pin4.text
          }
      );

      var getbalance = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorcustbalance.php'),
          body: {
            'custemail':widget.useremail,
          }
      );

      if(getbalance.statusCode == 200){

        setState(() {
          finalbalance = jsonDecode(getbalance.body);
        });

        print("Wallet balance is "+finalbalance);

        if(procespayment.statusCode == 200){

          if(jsonDecode(procespayment.body)=='true'){

            if(double.parse(finalbalance) >= widget.totalamountplusdelivery){

              var debitcustwallet = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorcustupdatewallet.php'),
                  body: {
                    'idname':widget.idname,
                    'email':widget.useremail,
                    'debit':widget.totalamountplusdelivery.toString(),
                    'credit':'0',
                    'desc':'bought goods',
                    'refno':trfid,
                  }
              );

              // var vendor_five_percent = await http.post(
              //   Uri.https('adeoropelumi.com','vendor/vendorfivepercent.php'),
              //   body: {
              //     'idname': widget.idname,
              //     'email' : widget.useremail,
              //     'percent' : widget.service_fee.toString(),
              //     'refno' : trfid,
              //     'type' : 'product'
              //   }
              // );

              if(debitcustwallet.statusCode == 200){

                print(jsonDecode(debitcustwallet.body));
                print('Wallet debited');

                for(int o =0; o < cartitems.length; o++){

                  String trackid = "tk-"+trfid;

                  //amount with quantity
                  double amount_with_quantity = cartitems[o].amount * cartitems[o].quantity;

                  final orders = await http.post(
                      Uri.https('adeoropelumi.com','vendor/vendororderstatus.php'),
                      body: {
                        'idname':widget.idname,
                        'orderprocessed':'',
                        'ordershipped':'',
                        'orderarrived':'',
                        'deliverypayment':'',
                        'productpayment':'',
                        'productid':cartitems[o].prodid,
                        'productname':cartitems[o].name,
                        'prodimagename': cartitems[o].imagename,
                        'useremail':widget.useremail,
                        'amount': amount_with_quantity.toString(),
                        'trackid':trackid,
                        'tkid':trfid,
                        'adminemail': cartitems[o].adminemail,
                        'customerlocation' : replacing(widget.streetaddress),
                        'deliveryprice' : cartitems[o].deliveryprice.toString(),
                        'quantity' : cartitems[o].quantity.toString(),
                        'deliveryplan': cartitems[o].deliveryplan,
                        'deliveryday' : cartitems[o].deliverydays,
                        'customername' : replacing(widget.fullname),
                        'customernumber' : widget.phonenumber,
                        'customerstate' : widget.state,
                      }
                  );

                  double finalprice = cartitems[o].deliveryprice + amount_with_quantity;

                  var savetransaction = await http.post(
                      Uri.https('adeoropelumi.com','vendor/vendorsaveinbusinesswallet.php'),
                      body: {
                        'idname': widget.idname,
                        'useremail': widget.useremail,
                        'adminemail': cartitems[o].adminemail,
                        'debit':'0',
                        'credit': finalprice.toString(),
                        'status': 'pending',
                        'refno' : trfid,
                        'description':cartitems[o].name+" purchased",
                        'itemid': cartitems[o].prodid
                      }
                  );

                  var notifyuser = await http.post(
                      Uri.https('adeoropelumi.com', 'vendor/vendorsendnotification.php'),
                      body: {
                        'message': cartitems[o].name+" has being ordered",
                        'info': cartitems[o].adminemail,
                        'tag': 'Product',
                        'quantity' : cartitems[o].quantity.toString(),
                        'refno':trfid
                      }
                  );

                  if(orders.statusCode == 200){
                    if(jsonDecode(orders.body)=='true'){
                      if(notifyuser.statusCode == 200){
                        if(jsonDecode(notifyuser.body)=='true'){
                          if(savetransaction.statusCode == 200){
                            if(jsonDecode(savetransaction.body)=="true"){

                              print("Transaction for "+cartitems[o].prodid+" is saved");
                              print('before ${itemnumbers}');
                              itemnumbers++;
                              print('After ${itemnumbers}');
                              print(cartitems[o].name+" is a new order");

                              if(o == (cartitems.length-1)){

                                setState(() {
                                  _selectedpage = 0;
                                  pin1.clear();
                                  pin2.clear();
                                  pin3.clear();
                                  pin4.clear();
                                });

                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return CheckoutFinal(useremail: widget.useremail,idname: widget.idname,username: widget.username,);
                                }));
                              }
                              else{
                                setState(() {
                                  _selectedpage = 0;
                                  pin1.clear();
                                  pin2.clear();
                                  pin3.clear();
                                  pin4.clear();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Failed"))
                                );
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }

              }
              else{

                print("debit cust wallet issues ${debitcustwallet.statusCode}");

                setState(() {
                  _selectedpage = 0;
                });

              }
            }
            else{

              setState(() {
                _selectedpage = 0;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Insufficeint balance'))
              );
            }
          }
          else{

            setState(() {
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text('Wrong pin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                ));

          }
        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(
                content: Text('Network error'),
              ));
        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        print("get balance issues ${getbalance.statusCode}");

      }
    }
    catch(e){

      print("Error says "+e.toString());
      print(trfid);

      print("reversing transactions...");

      var deletefailed = await http.post(
          Uri.https('adeoropelumi.com','vendor/deletewalletcheckout.php'),
          body: {
            'refno': trfid
          }
      );

      if(jsonDecode(deletefailed.body) == "true"){

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }

  }

  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              //checkout text back button
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, .5),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //checkout text
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    //back button
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
              //shipment , payment , Review text
              Container(
                padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 252, 233, 1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/23,)
                          ),
                          width: MediaQuery.of(context).size.width/13,
                          height: MediaQuery.of(context).size.width/13,
                          child: Center(
                            child: Text("1",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/23,
                                color: Colors.white
                            ),),
                          ),
                        )
                    ),
                    Expanded(child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/60,),
                      child: Text("Shipment",style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/27,
                      ),),
                    ),),
                    Container(
                      child: Text("->  ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),),
                    ),
                    Container(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/23,)
                          ),
                          width: MediaQuery.of(context).size.width/13,
                          height: MediaQuery.of(context).size.width/13,
                          child: Center(
                            child: Text("2",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/23,
                                color: Colors.white
                            ),),
                          ),
                        )
                    ),
                    Expanded(child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/60,),
                      child: Text("Payment",style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/27,
                      ),),
                    ),),
                    Container(
                      child: Text("->  ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),),
                    ),
                    Container(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/23,)
                          ),
                          width: MediaQuery.of(context).size.width/13,
                          height: MediaQuery.of(context).size.width/13,
                          child: Center(
                            child: Text("3",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/23,
                                color: Colors.white
                            ),),
                          ),
                        )
                    ),
                    Expanded(child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/60,),
                      child: Text("Review",style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/27,
                      ),),
                    )),
                  ],
                ),
              ),

              Flexible(
                  child: ListView(
                padding: EdgeInsets.zero,
                children:[
                  Container(
                    margin: EdgeInsets.only(left: 10,top: 10),
                    child: Text("Please confirm and submit your order",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/18,
                          fontWeight: FontWeight.w500
                      ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Text("By clicking submit order, you agree to Vendor Hive 360’s Terms of Use and Privacy Policy",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/27,
                      ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                    padding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text("Payment",style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/25,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              )
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: Text("Amount",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/25,
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.w500
                                    ),),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: Icon(Icons.account_balance_wallet_rounded,
                                        size: MediaQuery.of(context).size.width/12,
                                        color: Color.fromRGBO(5, 102, 8, 1),),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text("My Wallet",style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/25,
                                      ),),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Text("₦"+"${widget.totalamountplusdelivery}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/25,
                                  ),),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(238, 252, 233, 1)
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text("Enter Pin",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/23,
                              fontWeight: FontWeight.w500
                            ),),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(child: Text("Please enter your PIN to pay for your order",style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/25,
                          ),)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children:[
                                    Container(
                                        height: MediaQuery.of(context).size.width/8,
                                        width: MediaQuery.of(context).size.width/8,
                                        child: TextFormField(
                                          controller: pin1,
                                          onChanged: (value){
                                            if(value.length == 1){
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          // onSaved: (pin1){},
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(bottom: 0),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(100)
                                              )
                                          ),
                                          // style: Theme.of(context).textTheme.titleLarge,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/14,
                                              fontWeight: FontWeight.w500
                                          ),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                        )
                                    ),
                                    Container(
                                        height: MediaQuery.of(context).size.width/8,
                                        width: MediaQuery.of(context).size.width/8,

                                        child: TextFormField(
                                          controller: pin2,
                                          onChanged: (value){
                                            if(value.length == 1){
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          // onSaved: (pin2){},
                                          // decoration: InputDecoration(hintText: "0"),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(100)
                                              )
                                          ),
                                          // style: Theme.of(context).textTheme.titleLarge,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/14,
                                              fontWeight: FontWeight.w500
                                          ),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                        )
                                    ),
                                    Container(
                                        height: MediaQuery.of(context).size.width/8,
                                        width: MediaQuery.of(context).size.width/8,
                                        child: TextFormField(
                                          controller: pin3,
                                          onChanged: (value){
                                            if(value.length == 1){
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          // onSaved: (pin1){},
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100)
                                            )
                                          ),
                                          // style: Theme.of(context).textTheme.titleLarge,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/14,
                                              fontWeight: FontWeight.w500
                                          ),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                        )
                                    ),
                                    Container(
                                        height: MediaQuery.of(context).size.width/8,
                                        width: MediaQuery.of(context).size.width/8,
                                        child: TextFormField(
                                          controller: pin4,
                                          onChanged: (value){
                                            if(value.length == 1){
                                              FocusScope.of(context).nextFocus();
                                            }
                                          },
                                          // onSaved: (pin1){},
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 0),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(100)
                                              )
                                          ),
                                          // style: Theme.of(context).textTheme.titleLarge,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width/14,
                                            fontWeight: FontWeight.w500
                                          ),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1),
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                        )
                                    ),
                                  ]
                              )
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            if(pin1.text.isNotEmpty && pin2.text.isNotEmpty
                            && pin3.text.isNotEmpty && pin4.text.isNotEmpty){
                              processpayment();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Enter Complete pin'))
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(246, 123, 55, 1),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            margin: EdgeInsets.only(top: 40,bottom: 40,left: 10,right: 10),
                            child: Center(child: Text("Submit Order",style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width/22,
                              fontWeight: FontWeight.w500
                            ),)),
                          ),
                        )
                      ],
                    ),
                  ),
                ]
              )
              )

            ],
          ),
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
                  Container(
                    child: Text("Processing payment",style: TextStyle(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text('Vendorhive360',style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
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
