import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/successpin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPin extends StatefulWidget {
  String email = "";
  ResetPin({Key? key,
  required this.email}) : super(key: key);

  @override
  _ResetPinState createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {

  String error = "";
  int _selectedPage = 0;

  TextEditingController _newpin = new TextEditingController();
  TextEditingController _confirmpin = new TextEditingController();

  Future passwordreset()async{

    setState(() {
      _selectedPage = 1;
    });

    var passwordreset = await http.post(
        Uri.https('adeoropelumi.com','vendor/resetpin.php'),
        body: {
          'password': _newpin.text,
          'email' : widget.email
        }
    );

    if(passwordreset.statusCode == 200){
      if(jsonDecode(passwordreset.body) == "true"){

        setState(() {
          _selectedPage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SuccessPin();
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
                controller: _newpin,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                    hintText: "New Pin",
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
                controller: _confirmpin,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                    hintText: "Confirm Pin",
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26,
                        fontWeight: FontWeight.w500
                    )
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                if(_newpin.text.isNotEmpty && _confirmpin.text.isNotEmpty){
                  if(_newpin.text == _confirmpin.text){
                    if(_newpin.text.length < 4 && _confirmpin.text.length < 4){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Both Pin must be 4 digits"))
                      );
                    }
                    else{

                      passwordreset();

                    }
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
                  child: Text("Reset Pin",style: TextStyle(
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
    );
  }
}
