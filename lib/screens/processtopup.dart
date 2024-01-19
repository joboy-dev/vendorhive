import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/successtoputp.dart';

class Processtopup extends StatefulWidget {
  String idname = "";
  String email = "";
  String amount = "";
  String description = "";
  Processtopup({Key? key,
  required this.idname,
  required this.email,
  required this.amount,
  required this.description}) : super(key: key);

  @override
  _ProcesstopupState createState() => _ProcesstopupState();
}

class _ProcesstopupState extends State<Processtopup> {
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

  Future processingpayment() async {

    currentdate();

    try{

      var creditcustwallet = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorcustupdatewallet.php'),
          body: {
            'idname':widget.idname,
            'email':widget.email,
            'debit':'0',
            'credit':widget.amount.replaceAll(",", ""),
            'desc':widget.description,
            'refno':trfid,
          }
      );

      var notifyuser = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorsendnotification.php'),
          body: {
            'message': "₦"+widget.amount+" was credited into your account",
            'info': widget.email,
            'tag': 'Top-Up',
            'quantity' : "1",
            'refno': trfid,
          }
      );

      if(creditcustwallet.statusCode == 200){

        print(jsonDecode(creditcustwallet.body));

        if(jsonDecode(creditcustwallet.body) == 'true'){

          print('Wallet credited');

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SuccessTopup();
          }));

        }
        else{

          print('Failed to credit wallet');

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        print('Network Issues');

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }
    catch(e){

      print("Failed"+e.toString());

      var failedtopup = await http.post(
          Uri.https('vendorhive360.com','vendor/failedtopup.php'),
          body: {
            'refno':trfid
          }
      );

      if(failedtopup.statusCode == 200){
        if(jsonDecode(failedtopup.body) == "true"){

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
    processingpayment();
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
