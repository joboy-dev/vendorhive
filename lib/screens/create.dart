import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/gestures.dart';
import 'package:vendorandroid/screens/login.dart';
import 'package:vendorandroid/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Create extends StatefulWidget {

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {

  int selectedPage = 0;

  String appstatus = "Vendorhive360";

  TextEditingController _fullname = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phonenumber = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmpassowrd = new TextEditingController();
  TextEditingController _referencecode = new TextEditingController();

  int number_of_referals = 0;
  List referals = [];

  Future validate_referal_code() async{
    setState(() {
      selectedPage = 1;
    });

    if(_referencecode.text.isEmpty){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return GetStarted(
              fullname: _fullname.text,
              email: _email.text,
              phonenumber: _phonenumber.text,
              password: _password.text,
              confirmpassword: _confirmpassowrd.text,
              referalcode: _referencecode.text,);
          }));
    }
    else{
      //check people you refered to add it
      var earn = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorviewearnings.php'),
          body: {
            'idname':_referencecode.text
          }
      );

      referals = jsonDecode(earn.body);
      number_of_referals = referals.length;

      if(number_of_referals < 5){

        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return GetStarted(
                fullname: _fullname.text,
                email: _email.text,
                phonenumber: _phonenumber.text,
                password: _password.text,
                confirmpassword: _confirmpassowrd.text,
                referalcode: _referencecode.text,);
            }));

      }
      else{

        setState(() {
          selectedPage = 0;
        });

        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text('Referal limit exceed!!, Try another referal code or proceed without referal'),
            ));

      }
    }
  }

  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return selectedPage == 0 ?
    Scaffold(
      body: GestureDetector(
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
                  child: Center(child: Text("Create an Account",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/20,
                    fontWeight: FontWeight.w500
                  ),)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: Text("Join Vendorhive360 and get good services and quality products. Thank me later",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/26
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,top: 30,bottom: 5),
                  child: Text("Enter Full Name"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _fullname,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: .5, color: Colors.black
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 5),
                  child: Text("Enter Email Address"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: .5, color: Colors.black
                            )
                        ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 5),
                  child: Text("Phone Number"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: TextField(
                    controller: _phonenumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 5),
                  child: Text("Password"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: TextField(
                    controller: _password,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              if(obscure == true){
                                obscure = false;
                              }else if(obscure == false){
                                obscure = true;
                              }
                            });
                          },
                          child: Container(child: Image.asset("assets/eye.png"))
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 5),
                  child: Text("Confirm Password"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: TextField(
                    controller: _confirmpassowrd,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              if(obscure == true){
                                obscure = false;
                              }else if(obscure == false){
                                obscure = true;
                              }
                            });
                          },
                          child: Container(child: Image.asset("assets/eye.png"))
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 5),
                  child: Text("Reference code (optional)"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _referencecode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5, color: Colors.black
                          )
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    if (_fullname.text.contains("'") ||
                        _fullname.text.contains(r'\') ) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                          Text("Full Name must not contain ' or \\ ")));
                    }
                    else {
                      if (_email.text.contains("'") ||
                          _email.text.contains(r'\')) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                            Text("Email must not contain ' or \\ ")));
                      }
                      else {
                        if (_password.text.contains("'") ||
                            _password.text.contains(r'\')) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                              Text("Password must not contain ' or \\ ")));
                        }
                        else {
                          if (_confirmpassowrd.text.contains("'") ||
                              _confirmpassowrd.text.contains(r'\')) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                Text("Confirm Password must not contain ' or \\ ")));
                          }
                          else {
                            if (_fullname.text.isNotEmpty && _email.text
                                .isNotEmpty &&
                                _phonenumber.text.isNotEmpty
                                && _password.text.isNotEmpty &&
                                _confirmpassowrd.text.isNotEmpty) {
                              if (_password.text == _confirmpassowrd.text) {
                                validate_referal_code();
                              }
                              else {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                    SnackBar(
                                      content: Text('Passwords do not match'),
                                    ));
                              }
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fill all Fields'))
                              );
                            }
                          }
                        }
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Create an Account",style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/22,
                      fontWeight: FontWeight.w500
                    ),)),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Log in',
                                style: TextStyle(
                                    color: Color.fromRGBO(14, 44, 3, 1),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return Login();
                                    }));
                                  })
                          ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    )
    :Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Signing in",
                      style: TextStyle(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        'Vendorhive360',
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
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
