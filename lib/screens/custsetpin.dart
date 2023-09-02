import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/custupdatepin.dart';

class CustSetPin extends StatefulWidget {
  String idname = "";
  String useremail = "";
  CustSetPin({Key? key,
  required this.useremail,
  required this.idname}) : super(key: key);

  @override
  _CustSetPinState createState() => _CustSetPinState();
}

class _CustSetPinState extends State<CustSetPin> {

  int _selectedpage = 0;
  bool exist = false;
  String entry = "Pin must be 4 digits";

  TextEditingController _pin = new TextEditingController();

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
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, .5),
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Set Pin",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                              child: Icon(Icons.arrow_back,color: Colors.black,),
                            )
                        ),
                      )
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    print("Pin must be 4 digits");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(entry))
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent
                    ),
                    child: Center(
                      child: Text(entry,style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/24,
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _pin,
                    keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                      ],
                    decoration: InputDecoration(
                      hintText: 'Enter pin',
                      contentPadding: EdgeInsets.only(left: 10)
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    if(_pin.text.isNotEmpty){
                      if(_pin.text.toString().length == 4){

                        setpin();

                      }
                      else{

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pin must be 4 digits'))
                        );

                      }
                    }
                    else{

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please Enter pin'))
                      );

                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orangeAccent),
                      color: Colors.green
                    ),
                    child: Center(
                      child: Text('Set Pin',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width/21
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

                exist ?
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        child: Center(
                          child: Text('You have registered a pin before. Do you want to change it',textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/26,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return CustUpdatePin(idname: widget.idname,
                                email: widget.useremail,);
                              }));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/23,
                                  horizontal: MediaQuery.of(context).size.width/12.5),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2,color: Colors.orange)
                              ),
                              child: Center(
                                child: Text('Yes',style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/26,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width/23,
                          ),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                exist = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/23,
                                  horizontal: MediaQuery.of(context).size.width/12.5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2)
                              ),
                              child: Center(
                                child: Text('No',style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/26,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
                    :
                Container(
                  margin: EdgeInsets.only(top: 40),
                  height: MediaQuery.of(context).size.width/2,
                  width: MediaQuery.of(context).size.width/2,
                  child: Image.asset("assets/passcode.png"),
                )
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
                          fontWeight: FontWeight.bold,
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

  Future setpin() async{

    setState(() {
      _selectedpage = 1;
    });

    print('processing pin');

    try{
      final procespayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorrecordcheckforpin.php'),
          body: {
            'email':widget.useremail,
          }
      );

      if(procespayment.statusCode == 200){
        print(jsonDecode(procespayment.body));
        if(jsonDecode(procespayment.body)=='true'){

          print('Pin has being created');

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You have set pin before'))
          );

          setState(() {
            entry = "You have set pin before";
            _selectedpage = 0;
            exist = true;
          });

        }
        else{

          var setnewpin = await http.post(
              Uri.https('adeoropelumi.com','vendor/vendorcustnewpin.php'),
              body: {
                'idname':widget.idname,
                'email':widget.useremail,
                'pin':_pin.text
              }
          );

          print(jsonDecode(setnewpin.body));
          if(jsonDecode(setnewpin.body)=='true'){

            setState(() {
              entry = "You have successfully set your pin.";
              _pin.clear();
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('You have successfully set your pin.'))
            );

          }
          else{

            setState(() {
              entry = "Error while setting pin";
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error while setting pin'))
            );

          }
        }
      }
      else{

        print('Network Issues');

        setState(() {
          entry = "Network Issue";
          _selectedpage = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Network Issue'))
        );

      }
    }
    catch(e){

      print("error is "+e.toString());

      setState(() {
        entry = "Request timed out";
        _selectedpage = 0;
        exist = true;
      });

    }
  }
}
