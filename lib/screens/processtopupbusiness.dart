import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/successtoputp.dart';

class ProcessTopupBusiness extends StatefulWidget {
  String idname = "";
  String email = "";
  String amount = "";
  String description = "";
  ProcessTopupBusiness({Key? key,
  required this.idname,
  required this.email,
  required this.amount,
  required this.description}) : super(key: key);

  @override
  _ProcessTopupBusinessState createState() => _ProcessTopupBusinessState();
}

class _ProcessTopupBusinessState extends State<ProcessTopupBusiness> {

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

  Future topupfor()async{

    currentdate();

    String itemid = "tp "+trfid;

    try{

      var savetransaction = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorsaveinbusinesswallet.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.email,
            'adminemail': widget.email,
            'debit':'0',
            'credit': widget.amount.replaceAll(',', ''),
            'status': 'completed',
            'refno' : trfid,
            'description': widget.description,
            'itemid': itemid
          }
      );

      if(savetransaction.statusCode == 200){
        print(jsonDecode(savetransaction.body));
        if(jsonDecode(savetransaction.body) == 'true'){


          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SuccessTopup();
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
    catch(e){

      print("Failed"+e.toString());

      var failedtopup = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedbusinesstopup.php'),
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
  initState(){
    super.initState();
    topupfor();
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
