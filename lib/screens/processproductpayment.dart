import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/cardcheckoutfinal.dart';
import 'package:vendorandroid/screens/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/failed.dart';

class ProcessProductPayment extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String state = "";
  String fullname = "";
  String streetaddress = "";
  double service_fee = 0;
  String phonenumber = "";
  String username = "";

  ProcessProductPayment({Key? key,
    required this.username,
  required this.idname,
  required this.useremail,
  required this.state,
  required this.fullname,
  required this.streetaddress,
  required this.service_fee, required this.phonenumber}) : super(key: key);

  @override
  _ProcessProductPaymentState createState() => _ProcessProductPaymentState();
}

class _ProcessProductPaymentState extends State<ProcessProductPayment> {

  String trfid = "";

  void currentdate(){
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

  Future pay() async{

    //timestamp
    currentdate();

    try{

      print('processing payment');

      // var vendor_five_percent = await http.post(
      //     Uri.https('vendorhive360.com','vendor/vendorfivepercent.php'),
      //     body: {
      //       'idname': widget.idname,
      //       'email' : widget.useremail,
      //       'percent' : widget.service_fee.toString(),
      //       'refno' : trfid,
      //       'type' : 'product'
      //     }
      // );

      for(int o =0; o < cartitems.length; o++){

        print('payment is ongoing');

        String trackid = "tk-"+trfid;

        //amount with quantity
        double amount_with_quantity = cartitems[o].amount * cartitems[o].quantity;

        final orders = await http.post(
            Uri.https('vendorhive360.com','vendor/vendororderstatus.php'),
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
            Uri.https('vendorhive360.com','vendor/vendorsaveinbusinesswallet.php'),
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
            Uri.https('vendorhive360.com', 'vendor/vendorsendnotification.php'),
            body: {
              'message': cartitems[o].name+" has being ordered",
              'info': cartitems[o].adminemail,
              'tag': 'Product',
              'quantity' : cartitems[o].quantity.toString(),
              'refno': trfid,
            }
        );

        if(orders.statusCode == 200){
          if(jsonDecode(orders.body)=='true'){
            if(savetransaction.statusCode == 200){
              if(jsonDecode(savetransaction.body)=="true"){
                if(notifyuser.statusCode == 200){
                  if(jsonDecode(notifyuser.body)=='true'){

                    print("Transaction for "+cartitems[o].prodid+" is saved");

                    print(cartitems[o].name+" is a new order");

                    if(o == (cartitems.length-1)){

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CardCheckoutFinal(useremail: widget.useremail,idname: widget.idname,username: widget.username,);
                      }));

                    }
                    else{

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
    catch(e){

      print("Error says "+e.toString());
      print(trfid);

      print("reversing transactions...");

      var deletefailed = await http.post(
          Uri.https('vendorhive360.com','vendor/deletewalletcheckout.php'),
          body: {
            'refno': trfid
          }
      );

      if(jsonDecode(deletefailed.body) == "true"){

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
  }

  @override
  initState(){
    super.initState();
    pay();
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Column(
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
                          fontSize: MediaQuery.of(context).size.width/26
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text('Vendorhive360',
                          style: TextStyle(
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
      ),
    );
  }
}
