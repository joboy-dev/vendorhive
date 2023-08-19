import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/passwordotp.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  int _selectpage = 0;
  String error = "";
  TextEditingController _email = new TextEditingController();

  Future forgetpass()async{

    setState(() {
      _selectpage = 1;
    });

    String generateRandomString(int lengthOfString){
      final random = Random();
      const allChars='AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
      // below statement will generate a random string of length using the characters
      // and length provided to it
      final randomString = List.generate(lengthOfString,
              (index) => allChars[random.nextInt(allChars.length)]).join();
      return randomString;    // return the generated string
    }

    String otp = generateRandomString(6);

    var checkmail = await http.post(
      Uri.https('adeoropelumi.com','vendor/checkemail.php'),
      body:{
        'email':_email.text
      }
    );

    if(checkmail.statusCode == 200){
      if(jsonDecode(checkmail.body) == "true"){

        var saveotp = await http.post(
          Uri.https('adeoropelumi.com','vendor/saveotp.php'),
          body: {
            'email':_email.text,
            'otp':otp
          }
        );

        if(saveotp.statusCode == 200){
          if(jsonDecode(saveotp.body) == "true"){

            setState(() {
              _selectpage = 0;
              error = "";
            });

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return PasswordOtp(email: _email.text,);
            }));

          }
          else{

            setState(() {
              _selectpage = 0;
              error = "Request timed out";
            });

          }
        }
        else{

          setState(() {
            _selectpage = 0;
            error = "Request timed out";
          });

        }

      }else{

        setState(() {
          error = "Email does not exist";
          _selectpage = 0;
        });

      }
    }
    else{

      setState(() {
        _selectpage = 0;
        error = "Request timed out";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request timed out"))
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                margin: EdgeInsets.only(left: 10,right: 10),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter email",
                    hintStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/26,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(_email.text.isNotEmpty){
                    forgetpass();
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
                  child: Text("Vendorhive",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/28,
                      fontStyle: FontStyle.italic
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
                      child: Image.asset("assets/processing.png",color: Color.fromRGBO(14, 44, 3, 1),),
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
