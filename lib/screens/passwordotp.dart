import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/resetpassword.dart';


class PasswordOtp extends StatefulWidget {
  String email = "";
  PasswordOtp({Key? key,
  required this.email}) : super(key: key);

  @override
  _PasswordOtpState createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {

  int _selectpage = 0;
  String error = "";
  TextEditingController _otp = new TextEditingController();

  Future processotp() async{

    setState(() {
      _selectpage = 1;
    });

    var processotp = await http.post(
      Uri.https('vendorhive360.com','vendor/processforgetpassword.php'),
      body:{
        'email':widget.email,
        'otp':_otp.text
      }
    );

    if(processotp.statusCode == 200){
      if(jsonDecode(processotp.body) == "true"){

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ResetPassword(email: widget.email);
        }));

      }
      else if(jsonDecode(processotp.body) == "error"){

        setState(() {
          error = "Request timed out";
          _selectpage = 0;
        });

      }
      else if(jsonDecode(processotp.body) == "false"){

        setState(() {
          error = "Wrong OTP";
          _selectpage = 0;
        });

      }
      else{

        setState(() {
          error = "Request timed out";
          _selectpage = 0;
        });

      }
    }
    else{

      setState(() {
        error = "Request timed out";
        _selectpage = 0;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Scaffold(
          body: _selectpage == 0 ?
          GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
                    width: MediaQuery.of(context).size.width/3,
                    height: MediaQuery.of(context).size.width/3,
                    child: Image.asset("assets/forgot-password.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 20,left: 10,right: 10),
                  child: Text("Vendorhive360 has sent your otp to "+widget.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26
                    ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: TextField(
                    controller: _otp,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Enter otp",
                        hintStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/26,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(_otp.text.isNotEmpty){
                      processotp();
                    }
                    else{

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Fill all fields"))
                      );

                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(
                          color: Colors.black
                      ),
                    ),
                    child: Center(
                      child: Text("Reset Password",style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/24
                      ),),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text("Vendorhive360",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/28,
                            fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        ),),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(error,style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26,
                        color: Colors.red
                    ),),
                  ),
                )
              ],
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
                        child: Text("Processing",style: TextStyle(
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
      ),
    );
  }
}
