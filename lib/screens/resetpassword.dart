import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/successpassword.dart';

class ResetPassword extends StatefulWidget {
  String email = "";
  ResetPassword({Key? key,
  required this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  String error = "";
  int _selectedPage = 0;

  TextEditingController _newpassword = new TextEditingController();
  TextEditingController _confirmpassword = new TextEditingController();

  Future passwordreset()async{

    setState(() {
      _selectedPage = 1;
    });

    var passwordreset = await http.post(
      Uri.https('adeoropelumi.com','vendor/resetpassword.php'),
      body: {
        'password': _newpassword.text,
        'email' : widget.email
      }
    );

    if(passwordreset.statusCode == 200){
      if(jsonDecode(passwordreset.body) == "true"){
        setState(() {
          _selectedPage = 0;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SuccessPassword();
        }));
      }
      else{

        setState(() {
          _selectedPage = 0;
          error = "Request timed out";
        });

      }
    }
    else{

      setState(() {
        _selectedPage = 0;
        error = "Request timed out";
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _selectedPage == 0 ?
        ListView(
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
              child: Text("Reset Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/26
                ),),
            ),

            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: TextField(
                controller: _newpassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "New Password",
                  hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/26,
                    fontWeight: FontWeight.w500
                  )
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
              child: TextField(
                controller: _confirmpassword,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26,
                        fontWeight: FontWeight.w500
                    )
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                if(_newpassword.text.isNotEmpty && _confirmpassword.text.isNotEmpty){
                  if(_newpassword.text == _confirmpassword.text){
                    passwordreset();
                  }
                  else{

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Passwords do no match"))
                    );

                  }
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
