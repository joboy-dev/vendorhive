import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/promotedonecard.dart';

class ProcessServicePromotionPayment extends StatefulWidget {
  String adminemail = "";
  String amount = "";
  String days = "";
  String sidname = "";
  String servicename = "";
  ProcessServicePromotionPayment({Key? key,
  required this.adminemail,
  required this.amount,
  required this.days,
  required this.sidname,
  required this.servicename}) : super(key: key);

  @override
  _ProcessServicePromotionPaymentState createState() => _ProcessServicePromotionPaymentState();
}

class _ProcessServicePromotionPaymentState extends State<ProcessServicePromotionPayment> {

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
            'itemid':widget.sidname,
            'adstats': adstats.toString(),
            'refno': trfid
          }
      );

      var updateproducts = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorupdateserviceads.php'),
          body: {
            'itemid':widget.sidname,
            'ads':adstats.toString()
          }
      );

      var notifyuser = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorsendnotification.php'),
          body: {
            'message': widget.servicename+" advertisment has started",
            'info': widget.adminemail,
            'tag': 'service promotion',
            'refno': trfid
          }
      );

      if(promotionpayment.statusCode == 200){
        print('User promotion payment is in progress');
        if(jsonDecode(promotionpayment.body)=='true'){
          print('User promotion is registereed');
          if(updateproducts.statusCode == 200){
            print('Admin Service promotion is in progress');
            if(jsonDecode(updateproducts.body)=='true'){
              if(notifyuser.statusCode == 200){
                print('User notification is in progress');
                if(jsonDecode(notifyuser.body)=='true'){

                  print('User is notified');
                  print('Admin Service promotion is done');


                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PromotedoneCard();
                  }));

                }
                else{


                  print("failed to notify");

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
            else{


              print("failed to update");

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Failed(trfid: trfid);
              }));

            }
          }
          else{


            print("update product issues ${updateproducts.statusCode}");

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

        print("Payment issues ${promotionpayment.statusCode}");

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }
    catch(e){

      print("error is "+e.toString());

      var failedpromotionpayment = await http.post(
          Uri.https('vendorhive360.com','vendor/failedpromotedservicepayment.php'),
          body: {
            'refno':trfid,
            'sidname':widget.sidname
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
    return SafeArea(
      child: WillPopScope(
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
      )
    );
  }
}
