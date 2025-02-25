import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/promotedonecard.dart';

class ProcessProductPromotionPayment extends StatefulWidget {
  String amount = "";
  String days = "";
  String pidname = "";
  String adminemail = "";
  String prodname = "";
  ProcessProductPromotionPayment({Key? key,
  required this.amount,
  required this.days,
  required this.adminemail,
  required this.pidname,
  required this.prodname}) : super(key: key);

  @override
  _ProcessProductPromotionPaymentState createState() => _ProcessProductPromotionPaymentState();
}

class _ProcessProductPromotionPaymentState extends State<ProcessProductPromotionPayment> {

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

  Future pay()async{

    double adstats = double.parse(widget.amount) / double.parse(widget.days);

    currentdate();

    try{

      var promotionpayment = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorpromotionpayment.php'),
          body: {
            'adminemail':widget.adminemail,
            'amount':widget.amount,
            'days':widget.days,
            'itemid':widget.pidname,
            'adstats': adstats.toString(),
            'refno': trfid,
          }
      );

      var updateproducts = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorupdateproductads.php'),
          body: {
            'itemid':widget.pidname,
            'ads':adstats.toString()
          }
      );


      String notifymsg = widget.prodname+" advertisment has started";

      var notifyuser = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorsendnotification.php'),
          body: {
            'message': notifymsg,
            'info': widget.adminemail,
            'tag': 'product promotion',
            'refno': trfid
          }
      );


      if(promotionpayment.statusCode == 200){
        if(jsonDecode(promotionpayment.body) == "true"){
          if(updateproducts.statusCode == 200){
            if(jsonDecode(updateproducts.body) == "true"){
              if(notifyuser.statusCode == 200){
                if(jsonDecode(notifyuser.body) == "true"){

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PromotedoneCard();
                  }));

                }
                else{

                  print("failed to notify");

                }
              }
              else{

                print("Notify user issues ${notifyuser.statusCode}");

              }
            }
            else{

              print("promotion failed to start");

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Failed(trfid: trfid);
              }));

            }
          }
          else{

            print("Update product issues ${updateproducts.statusCode}");

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Failed(trfid: trfid);
            }));

          }
        }
        else{

          print("Payment failed");

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        print("payment issues ${promotionpayment.statusCode}");

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }
    catch(e){

      print("error is "+e.toString());

      var failedpromotionpayment = await http.post(
          Uri.https('vendorhive360.com','vendor/failedpromotedproductpayment.php'),
          body: {
            'refno':trfid,
            'pidname':widget.pidname
          }
      );

      if(failedpromotionpayment.statusCode == 200){
        if(jsonDecode(failedpromotionpayment.body)=="true"){

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
        else{

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }

  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pay();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
          )
      ),
    );
  }
}
