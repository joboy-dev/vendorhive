import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/introduce.dart';

class OTPBusiness extends StatefulWidget {
  String idname = "";
  String email = "";
  OTPBusiness({Key? key, required this.idname,
    required this.email}) : super(key: key);

  @override
  _OTPBusinessState createState() => _OTPBusinessState();
}

class _OTPBusinessState extends State<OTPBusiness> {

  int _selectedpage = 0;

  TextEditingController _otp = new TextEditingController();

  Future otpprocessing() async{

    setState(() {
      _selectedpage = 1;
    });
    try{
      final verifyotp = await http.post(
          Uri.https('adeoropelumi.com','vendor/verified.php'),
          body: {
            'idname':widget.idname,
            'email':widget.email
          }
      );

      if(verifyotp.statusCode == 200){
        if(jsonDecode(verifyotp.body)=="true"){

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Introduce(id: widget.idname,useremail: widget.email,);
          }));

        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: widget.idname);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: widget.idname);
        }));

      }
    }
    catch(e){

      final failedotp = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedotp.php'),
          body: {
            'email':widget.email
          }
      );

      if(failedotp.statusCode == 200){
        if(jsonDecode(failedotp.body) == "true"){

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: widget.idname);
          }));

        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: widget.idname);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: widget.idname);
        }));

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: SafeArea(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.width/3,
                  child: Center(
                    child: Image.asset("assets/otp.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 20,left: 10,right: 10),
                  child: Text("Vendorhive has sent your otp to "+widget.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26
                    ),),
                ),
                Container(
                  child: TextField(
                    controller: _otp,
                    decoration: InputDecoration(
                      label: Text('OTP'),

                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    if(_otp.text.isNotEmpty){
                      otpprocessing();
                    }
                    else{

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter OTP to proceed"))
                      );

                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Proceed",style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/22,
                        fontWeight: FontWeight.w500
                    ),)),
                  ),
                ),
              ],
            ),
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
                    child: Image.asset("assets/processing.png",color: Color.fromRGBO(14, 44, 3, 1),),
                  ),
                  Container(
                    child: Text("Processing",style: TextStyle(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text('Vendorhive 360',style: TextStyle(
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
    );
  }
}
