import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/custchangepassword.dart';
import 'package:vendorandroid/screens/custsetpin.dart';
import 'package:vendorandroid/screens/login.dart';
import 'package:vendorandroid/screens/delete.dart';
import 'package:vendorandroid/screens/deletevendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'cart.dart';

class Settings extends StatefulWidget {
  String idname = "";
  String email = "";
  String usertype = "";

  Settings(
      {Key? key,
      required this.usertype,
      required this.idname,
      required this.email})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selectedIndex = 0;

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.usertype);
    print(widget.email);
    print(widget.idname);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _selectedIndex == 0?
      Scaffold(
        body: Column(
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
                      child: Text(
                        "Setting",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),

                    //back button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          )),
                    )
                  ],
                )),

            Flexible(
                child: ListView(
              padding: EdgeInsets.zero,
              children: [
                //change password button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CustChangePassword(
                          idname: widget.idname, email: widget.email);
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey))),
                    padding: EdgeInsets.only(bottom: 20),
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 8,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Image.asset(
                            "assets/padlock.png",
                            color: Color.fromRGBO(246, 123, 55, 1),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //set payment pin button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CustSetPin(
                        idname: widget.idname,
                        useremail: widget.email,
                      );
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey))),
                    padding: EdgeInsets.only(bottom: 20),
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 8,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Image.asset(
                            "assets/card.png",
                            color: Color.fromRGBO(246, 123, 55, 1),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Text(
                              "Payment Pin",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //delete button
                GestureDetector(
                  onTap: () {
                    widget.usertype == 'customer' ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return DeletePage(
                            idname: widget.idname,
                            email: widget.email,
                          );
                        })) : Navigator.push(context, MaterialPageRoute(builder: (context){
                        return DeleteVendor(
                          idname: widget.idname,
                          email: widget.email,
                        );
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey))),
                    padding: EdgeInsets.only(bottom: 20),
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 8,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Image.asset(
                            "assets/trash.png",
                            color: Color.fromRGBO(246, 123, 55, 1),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Text(
                              "Delete Account",
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width / 22.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //sign out button
                GestureDetector(
                  onTap: () async {

                    setState(() {
                      cartitems.clear();
                      _selectedIndex = 1;
                    });

                    await Future.delayed(Duration(seconds: 5));

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    await prefs.remove('counter');
                    await prefs.remove('idname');
                    await prefs.remove('useremail');
                    await prefs.remove('packagename');
                    await prefs.remove('usertype');
                    await prefs.remove('pagenumber');
                    await prefs.remove('finalbalance');
                    await prefs.remove('pendingbalance');

                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Login();
                    }), (r) {
                      return false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey))),
                    padding: EdgeInsets.only(bottom: 20),
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 8,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Image.asset(
                            "assets/logout.png",
                            color: Color.fromRGBO(246, 123, 55, 1),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Text(
                              "Sign Out",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      )
      :Scaffold(
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Column(
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
                        "Logging out",
                        style: TextStyle(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            fontWeight: FontWeight.bold,
                            fontSize:
                            MediaQuery.of(context).size.width / 26),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          'Vendorhive360',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
      ),
        ),
      )
    );
  }
}
