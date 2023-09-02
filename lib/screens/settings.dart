import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/custchangepassword.dart';
import 'package:vendorandroid/screens/custsetpin.dart';
import 'package:vendorandroid/screens/login.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  String idname = "";
  String email = "";
  Settings({Key? key,
  required this.idname,
  required this.email}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //setting app bar
            Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, .5),
                ),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    //setting text
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Setting",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),),
                    ),

                    //back button
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
                )
            ),

            Flexible(
                child:ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    //change password button
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CustChangePassword(idname: widget.idname,
                              email: widget.email);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: .5,
                                    color: Colors.grey
                                )
                            )
                        ),
                        padding: EdgeInsets.only(bottom: 20),
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [

                            Container(width: MediaQuery.of(context).size.width/8,
                              margin: EdgeInsets.only(top: 10,left: 10),
                              child: Image.asset("assets/padlock.png",color: Color.fromRGBO(246, 123, 55, 1),),
                            ),

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10,left: 15),
                                child: Text("Change Password",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/22.5,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    //set payment pin button
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CustSetPin(idname: widget.idname,
                            useremail: widget.email,);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: .5,
                                    color: Colors.grey
                                )
                            )
                        ),
                        padding: EdgeInsets.only(bottom: 20),
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              margin: EdgeInsets.only(top: 10,left: 10),
                              child: Image.asset("assets/card.png",
                                color: Color.fromRGBO(246, 123, 55, 1),),
                            ),
                            
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10,left: 15),
                                child: Text("Payment Pin",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/22.5,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    //sign out button
                    GestureDetector(
                      onTap: () async{

                        final SharedPreferences prefs = await SharedPreferences.getInstance();

                        await prefs.remove('counter');
                        await prefs.remove('idname');
                        await prefs.remove('useremail');
                        await prefs.remove('packagename');
                        await prefs.remove('usertype');
                        await prefs.remove('pagenumber');
                        await prefs.remove('finalbalance');
                        await prefs.remove('pendingbalance');

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                          return Login();
                        }), (r){
                          return false;
                        });

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: .5,
                                    color: Colors.grey
                                )
                            )
                        ),
                        padding: EdgeInsets.only(bottom: 20),
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              margin: EdgeInsets.only(top: 10,left: 10),
                              child: Image.asset("assets/logout.png",color: Color.fromRGBO(246, 123, 55, 1),),
                            ),

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10,left: 15),
                                child: Text("Sign Out",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/22.5,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
