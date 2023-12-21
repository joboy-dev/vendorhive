import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/successpackage.dart';

class ProcessPackagePayment extends StatefulWidget {
  String email = "";
  String package = "";
  ProcessPackagePayment({Key? key,
  required this.email,
  required this.package}) : super(key: key);

  @override
  _ProcessPackagePaymentState createState() => _ProcessPackagePaymentState();
}

class _ProcessPackagePaymentState extends State<ProcessPackagePayment> {

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

    //timestamp
    currentdate();

    try{

      var recordpackage = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorpackagerecord.php'),
          body: {
            'email':widget.email,
            'package':widget.package,
            'refno': trfid
          }
      );

      var upgradepackage = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorupdatepackage.php'),
          body: {
            'email':widget.email,
            'package':widget.package
          }
      );

      //notify user
      var notifyuser = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorsendnotification.php'),
          body: {
            'message': "You are now on "+widget.package+" package",
            'info': widget.email,
            'tag': 'Package',
            'quantity' : "1 package",
            'refno': trfid
          }
      );

      if(upgradepackage.statusCode == 200){
        if(jsonDecode(upgradepackage.body) == 'true'){
          print('User is upgraded to '+widget.package);

          if(recordpackage.statusCode == 200){
            if(jsonDecode(recordpackage.body) == 'true'){


              final SharedPreferences pref = await SharedPreferences.getInstance();

              await pref.setString('packagename', widget.package);

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return SuccessPackage();
              }));

              print('package is recorded');

            }
            else{


              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Failed(trfid: trfid);
              }));

              print('failed recording pacakage');

            }
          }
          else{

            print('Network issue while recording package');

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Failed(trfid: trfid);
            }));

          }
        }
        else{
          print('Failed while updating package');


          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        print('Network issue while updating package');

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
    catch(e){

      var failedpackagepayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedpackagepayment.php'),
          body: {
            'email':widget.email,
            'refno':trfid
          }
      );

      if(failedpackagepayment.statusCode == 200){
        if(jsonDecode(failedpackagepayment.body) == "true"){


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
