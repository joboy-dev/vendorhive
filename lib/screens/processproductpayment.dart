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
  ProcessProductPayment({Key? key,
  required this.idname,
  required this.useremail,
  required this.state,
  required this.fullname,
  required this.streetaddress}) : super(key: key);

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

      for(int o =0; o < cartitems.length; o++){

        print('payment is ongoing');

        String trackid = "tk-"+trfid;

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
              'amount':cartitems[o].amount.toString(),
              'trackid':trackid,
              'tkid':trfid,
              'adminemail': cartitems[o].adminemail,
              'customerlocation' : 'Name of individual:- '+replacing(widget.fullname)+" Address:- "+replacing(widget.streetaddress)+', '+widget.state+'.',
              'deliveryprice' : cartitems[o].deliveryprice.toString(),
              'quantity' : cartitems[o].quantity.toString()
            }
        );

        double finalprice = cartitems[o].deliveryprice + cartitems[o].amount;

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
              'tag': 'product',
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

                      setState(() {

                        cartitems.clear();

                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CardCheckoutFinal(useremail: widget.useremail,idname: widget.idname,);
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
          Uri.https('adeoropelumi.com','vendor/deletewalletcheckout.php'),
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
                        child: Text('Vendorhive 360',
                          style: TextStyle(
                              fontSize: 12,
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
      ),
    );
  }
}
