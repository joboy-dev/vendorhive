import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';


class ContactSupport extends StatefulWidget {
  String mail = "";
  String idname = "";
  ContactSupport({required this.mail, required this.idname});

  @override
  _ContactSupportState createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {

  int _selectedpage = 0 ;
  String drop = "Unable to Top-up Wallet";
  bool sendinghelp = false;
  bool conplainsent = false;

  TextEditingController _message = new TextEditingController();

  String trfid = "";

  void currentdate(){
    print('Timestamp is gotten as refno');
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

  //modify sent message
  String replacing(String word) {
    word = word.replaceAll("'", "{(L!I_0)}");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  String modify(String word) {
    word = word.replaceAll("{(L!I_0)}", "'");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  Future sendhelp() async{

    currentdate();

    print("Contacting support");

    setState(() {

      _selectedpage =1;
      sendinghelp = true;
      conplainsent = false;

    });

    try{

      var contactsupport = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorcontactsupport.php'),
          body: {
            'issue': drop,
            'frommail': widget.mail,
            'message': replacing(_message.text),
            'idname': widget.idname,
            'refno': trfid
          }
      );

      if(contactsupport.statusCode == 200){
        if(jsonDecode(contactsupport.body)=='true'){

          print('Complain is sent');

          setState(() {
            sendinghelp = false;
            conplainsent = true;
            _message.clear();
            _selectedpage = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("We have received your complain and will get back to you shortly"))
          );

        }
        else{

          setState(() {
            sendinghelp = false;
            conplainsent = true;
            _message.clear();
            _selectedpage = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Request timed out, Try again"))
          );

        }
      }
      else{

        setState(() {
          sendinghelp = false;
          conplainsent = true;
          _message.clear();
          _selectedpage = 0;
        });

        print("Contacting support issues ${contactsupport.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out, Try again"))
        );

      }

    }
    catch(e){

      print("error is "+e.toString());

      var failedsupport = await http.post(
        Uri.https('adeoropelumi.com','vendor/failedsupport.php'),
        body: {
          'refno':trfid
        }
      );

      if(failedsupport.statusCode == 200){
        if(jsonDecode(failedsupport.body)=="true"){

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.idname);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _selectedpage ==0?
      SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text("Contact Support",style: TextStyle(
                    fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.width/20,
                ),),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20,left: 10,right: 10),
              child: Text("Do you have any complain? Fill the below and we will get back to you. We also apologise for any inconvinece this might have caused you.",
                textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
              ),),
            ),

            Container(
              margin: EdgeInsets.only(left: 10,top: 40,bottom: 10,right: 10),
              child: Text("Select Issue",style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/25
              ),),
            ),

            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:Colors.grey, //background color of dropdown button
                    border: Border.all(color: Colors.grey, width:1), //border of dropdown button
                    borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                  ),

                  child:Padding(
                      padding: EdgeInsets.only(left:20, right:20),
                      child:DropdownButton(
                        value: drop,

                        items: [ //add items in the dropdown

                          DropdownMenuItem(
                            child: Text("Unable to Top-up Wallet",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/22
                            ),),
                            value: "Unable to Top-up Wallet",
                          ),
                          DropdownMenuItem(
                              child: Text("Report Vendor",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/22
                              ),),
                              value: "Report Vendor"
                          ),
                          DropdownMenuItem(
                            child: Text("Unsatified with Vendor service",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/22
                            ),),
                            value: "Unsatified with Vendor service",
                          )

                        ],

                        onChanged: (value){ //get value when changed
                          setState(() {
                            drop = value!;
                          });
                          print("You have selected $value");
                        },

                        icon: Padding( //Icon at tail, arrow bottom is default icon
                            padding: EdgeInsets.only(left:10),
                            child:Icon(Icons.arrow_drop_down)
                        ),

                        iconEnabledColor: Colors.white, //Icon color
                        style: TextStyle(  //te
                            color: Colors.white, //Font color
                            fontSize: MediaQuery.of(context).size.width/22
                        ),

                        dropdownColor: Colors.grey, //dropdown background color
                        underline: Container(), //remove underline
                        isExpanded: true, //make true to make width 100%
                      )
                  )
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
              child: Text("Message",style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/25
              ),),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: TextField(
                controller: _message,
                maxLines: null,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: .5
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: .5
                        )
                    )
                ),
              ),
            ),

            conplainsent?
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 15,top: 20),
              child: Center(
                child: Text('We have received your complain and will get back to you shortly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/27,
                    color: Colors.brown
                  ),),
              ),
            )
            :
            GestureDetector(
              onTap: (){

                if(sendinghelp == false){
                  if(_message.text.isNotEmpty){

                    sendhelp();

                  }
                  else{

                    print("Fill all fields");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fill all fields"))
                    );

                  }
                }
                else if(sendinghelp == true){

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("We are already contacting support"))
                  );

                }

              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(14, 44, 3, 1)
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(14, 44, 3, 1)
                ),
                padding: EdgeInsets.only(top: 15,bottom: 15),
                child: Center(child: sendinghelp?
                    Text('loading...',style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: MediaQuery.of(context).size.width/24,
                      color: Colors.white
                    ),)
                    :Text("Send Message",style: TextStyle(
                    color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width/24,
                ),)),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,bottom: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(246, 123, 55, 1)
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(246, 123, 55, 1)
                ),
                padding: EdgeInsets.only(top: 15,bottom: 15),
                child: Center(
                      child: Text("Go Back",style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width/24,
                    ),)
                ),
              ),
            ),

            Container(
              child: Center(
                child: Text('Vendorhive 360',style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: MediaQuery.of(context).size.width/26,
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
                    child: Text("Processing request",style: TextStyle(
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
