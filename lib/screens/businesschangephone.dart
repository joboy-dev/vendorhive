import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/success.dart';

class BusinessChangePhone extends StatefulWidget {
  String email = "";
  String idname = "";
  BusinessChangePhone({Key? key,
  required this.email,
  required this.idname}) : super(key: key);

  @override
  _BusinessChangePhoneState createState() => _BusinessChangePhoneState();
}

class _BusinessChangePhoneState extends State<BusinessChangePhone> {

  int _selectedpage = 0;
  TextEditingController _password = new TextEditingController();
  TextEditingController _newphone = new TextEditingController();

  Future changephone()async{

    setState(() {
      _selectedpage = 1;
    });

    try{

      var checkpassword = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorsignin.php'),
          body: {
            'useremail':widget.email,
            'password':_password.text
          }
      );

      if(checkpassword.statusCode == 200){
        if(jsonDecode(checkpassword.body)['status'] == 'login'){

          print('Correct password');

          var updatephonenumber = await http.post(
              Uri.https('adeoropelumi.com','vendor/vendorupdatephonenumber.php'),
              body: {
                'email':widget.email,
                'phone':_newphone.text
              }
          );

          if(updatephonenumber.statusCode == 200){
            if(jsonDecode(updatephonenumber.body) == "true"){

              setState(() {
                _selectedpage = 0;
                _newphone.clear();
                _password.clear();
              });

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Success();
              }));

            }
            else{

              setState(() {
                _selectedpage = 0;
                _newphone.clear();
                _password.clear();
              });

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Failed(trfid: widget.idname);
              }));

            }
          }
          else{

            setState(() {
              _selectedpage = 0;
              _newphone.clear();
              _password.clear();
            });

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Failed(trfid: widget.idname);
            }));

          }

        }
        else if(jsonDecode(checkpassword.body)['status'] == 'invalid'){

          setState(() {
            _selectedpage = 0;
            _newphone.clear();
            _password.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Wrong password'))
          );

        }
        else{

          setState(() {
            _selectedpage = 0;
            _newphone.clear();
            _password.clear();
          });

          print("Check password issues ${checkpassword.statusCode}");

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: widget.idname);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
          _newphone.clear();
          _password.clear();
        });

        print("Check password issues ${checkpassword.statusCode}");

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: widget.idname);
        }));

      }

    }
    catch(e){

      setState(() {
        _selectedpage = 0;
        _newphone.clear();
        _password.clear();
      });

      Navigator.push(context, MaterialPageRoute(builder: (context){
        return Failed(trfid: widget.idname);
      }));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _selectedpage ==0 ?
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: SafeArea(
              child: Container(
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, .5),
                      ),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Change Phone Number",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: _password,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          contentPadding: EdgeInsets.only(left: 10)
                        ),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: _newphone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter New Phone Number',
                            contentPadding: EdgeInsets.only(left: 10)
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_password.text.isNotEmpty && _newphone.text.isNotEmpty){
                          changephone();
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fill all fields'))
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          color: Colors.green
                        ),
                        child: Center(
                          child: Text('Change Phone Number',textAlign:TextAlign.center,
                            style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text('Vendorhive 360',style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/30,
                            fontStyle: FontStyle.italic
                        ),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      height: MediaQuery.of(context).size.width/2,
                      width: MediaQuery.of(context).size.width/2,
                      child: Image.asset("assets/telephone.png"),
                    )
                  ],
                ),
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
                      child: SpinKitFadingCube(
                        color: Colors.orange,
                        size: 100,
                      ),
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
      ),
    );
  }
}
