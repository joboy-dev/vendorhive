import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/success.dart';

class BusinessChangeFullname extends StatefulWidget {
  String email = "";
  String idname = "";
  BusinessChangeFullname({Key? key,
  required this.email,
  required this.idname}) : super(key: key);

  @override
  _BusinessChangeFullnameState createState() => _BusinessChangeFullnameState();
}

class _BusinessChangeFullnameState extends State<BusinessChangeFullname> {

  int _selectedpage = 0;
  TextEditingController _password = new TextEditingController();
  TextEditingController _newname = new TextEditingController();

  Future changename()async{

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

      //response code
      print(checkpassword.statusCode);
      //api response
      print(jsonDecode(checkpassword.body));

      if(checkpassword.statusCode == 200){
        if(jsonDecode(checkpassword.body)['status'] == 'login'){

          var updatefullname = await http.post(
              Uri.https('adeoropelumi.com','vendor/vendorchangefullname.php'),
              body: {
                'email' : widget.email,
                'fullname' : replacing(_newname.text)
              }
          );

          if(updatefullname.statusCode == 200){
            if(jsonDecode(updatefullname.body) == "true"){

              setState(() {
                _selectedpage = 0;
                _newname.clear();
                _password.clear();
              });

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Success();
              }));

            }
            else{

              setState(() {
                _selectedpage = 0;
                _newname.clear();
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
              _newname.clear();
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
            _newname.clear();
            _password.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Wrong password'))
          );


        }
        else{

          setState(() {
            _selectedpage = 0;
            _newname.clear();
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
          _newname.clear();
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
        _newname.clear();
        _password.clear();
      });


      Navigator.push(context, MaterialPageRoute(builder: (context){
        return Failed(trfid: widget.idname);
      }));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      SafeArea(
        child: Container(
          child: Column(
            children: [
              //change fullname text + back button
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
                        child: Text("Change Fullname",style: TextStyle(
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

              //password fullname textfield + change full name button and image decoration
              Flexible(
                  child: ListView(
                    children: [
                      //present password textfield
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
                      //new full name textfield
                      Container(
                        child: TextField(
                          controller: _newname,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Enter New Full Name',
                              contentPadding: EdgeInsets.only(left: 10)
                          ),
                        ),
                      ),
                      //change full name button
                      GestureDetector(
                        onTap: (){
                          if(_password.text.isNotEmpty && _newname.text.isNotEmpty){
                            changename();
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
                            child: Text('Change Full Name',textAlign:TextAlign.center,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),),
                          ),
                        ),
                      ),
                      //vendorhive text
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text('Vendorhive 360',style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/30,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),),
                        ),
                      ),
                      //image decoration
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        height: MediaQuery.of(context).size.width/2,
                        width: MediaQuery.of(context).size.width/2,
                        child: Image.asset("assets/text-to-speech.png"),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      )
          :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
                fontSize: MediaQuery.of(context).size.width/29
            ),),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Center(
              child: Text('Vendorhive 360',style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/33,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold
              ),),
            ),
          )
        ],
      ),
    );
  }
  String replacing(String word) {
    word = word.replaceAll("'", "");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }
}
