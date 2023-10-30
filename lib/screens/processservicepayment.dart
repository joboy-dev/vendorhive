import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/success.dart';
import 'package:vendorandroid/screens/successservice.dart';


class ProcessServicePayment extends StatefulWidget {
  String idname = "";
  String sidname = "";
  String useremail = "";
  String adminemail = "";
  String servicename = "";
  String amount = "";
  String desc = "";
  ProcessServicePayment({Key? key,
  required this.idname,
  required this.sidname,
  required this.useremail,
  required this.adminemail,
  required this.servicename,
  required this.amount,
  required this.desc}) : super(key: key);

  @override
  _ProcessServicePaymentState createState() => _ProcessServicePaymentState();
}

class _ProcessServicePaymentState extends State<ProcessServicePayment> {

  String trfid = "";

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

  Future processpayment() async{

    //timestamp
    currentdate();

    print('service payment saved');

    try{

      var savepayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorservicepayment.php'),
          body: {
            'idname': widget.idname,
            'sidname': widget.sidname,
            'useremail':widget.useremail,
            'adminemail': widget.adminemail,
            'servicename':widget.servicename,
            'amount':widget.amount,
            'refNo':trfid,
            'description':widget.desc,
            'status':'complete',
            'refund':'no'
          }
      );

      String itemid = "sv-"+trfid;
      String d = "paid for "+widget.servicename;

      var savetransaction = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorsaveinbusinesswallet.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.useremail,
            'adminemail': widget.adminemail,
            'debit':'0',
            'credit': widget.amount.replaceAll(',', ''),
            'status': 'completed',
            'refno' : trfid,
            'description': d,
            'itemid': itemid
          }
      );

      if(savepayment.statusCode == 200){
        if(jsonDecode(savepayment.body) == 'true'){

          print('service payment saved');

          if(savetransaction.statusCode == 200){

            if(jsonDecode(savetransaction.body)=='true'){

              print('Service is paid for');


              Navigator.push(context, MaterialPageRoute(builder: (context){
                return SuccessService();
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
    catch(e){

      print("error is "+e.toString());

      var failedservicepayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedservicepayment.php'),
          body: {
            "refno":trfid
          }
      );

      if(failedservicepayment.statusCode == 200){
        if(jsonDecode(failedservicepayment.body) == "true"){


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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processpayment();
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
