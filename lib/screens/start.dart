import 'dart:convert';
import 'dart:math';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/introduce.dart';
import 'package:vendorandroid/screens/otp.dart';
import 'package:vendorandroid/screens/otpbusiness.dart';
import 'package:vendorandroid/screens/successsignup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetStarted extends StatefulWidget {
  String fullname = "";
  String email = "";
  String phonenumber = "";
  String password = "";
  String confirmpassword = "";
  String referalcode = "";

  GetStarted(
      {required this.fullname,
      required this.email,
      required this.phonenumber,
      required this.password,
      required this.confirmpassword,
      required this.referalcode});

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  bool selectcustomer = true;
  bool selectbusiness = true;
  String idname = "";
  String customerprocess = "";
  String businessprocess = "";
  String appstatus = "Vendorhive360";
  String trfid = "";
  int _selectedpage = 0;

  void printoutcontrollers() {
    print(widget.fullname);
    print(widget.email);
    print(widget.phonenumber);
    print(widget.password);
    print(widget.confirmpassword);
  }

  void currentdate() {
    DateTime now = new DateTime.now();
    print(now.toString());
    timestamp(now.toString());
    trfid = timestamp(now.toString());
    print(trfid);
  }

  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }

  String timestamp(String str) {
    str = str.replaceAll(":", "");
    str = str.replaceAll("-", "");
    str = str.replaceAll(".", "");
    str = str.replaceAll(" ", "");
    return str;
  }

  Future generateid() async {
    currentdate();

    setState(() {
      _selectedpage = 1;
      appstatus = "loading...";
    });

    if (selectcustomer == true && selectbusiness == true) {
      String otp = generateRandomString(6);

      try {
        customerprocess = "loading...";
        print(customerprocess);
        idname = "cs-" + widget.phonenumber + trfid;

        print("Customer is selected and id is " + idname);

        customerprocess = "id is gotten";
        print(customerprocess);

        final otpresponse = await http.post(
            Uri.https('vendorhive360.com', 'vendor/otp.php'),
            body: {'idname': idname, 'email': widget.email, 'otp': otp});

        print(jsonDecode(otpresponse.body));
        if (otpresponse.statusCode == 200) {
          if (jsonDecode(otpresponse.body) == "true") {
            print("User is signed up");
            customerprocess = "Done";
            print(customerprocess);

            setState(() {
              _selectedpage = 0;
              appstatus = "Vendorhive360";
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OTP(
                idname: idname,
                email: widget.email,
                fullname: widget.fullname,
                password: widget.password,
                confirmpassword: widget.confirmpassword,
                phonenumber: widget.phonenumber,
                referalcode: widget.referalcode,
              );
            }));
          } else {
            setState(() {
              _selectedpage = 0;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Failed(trfid: idname);
            }));
          }
        } else {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: idname);
          }));
        }
      } catch (e) {
        print("Error is " + e.toString());

        var failedsignup = await http.post(
            Uri.https('vendorhive360.com', 'vendor/failedsignup.php'),
            body: {'idname': idname});

        if (failedsignup.statusCode == 200) {
          if (jsonDecode(failedsignup.body) == "true") {
            setState(() {
              _selectedpage = 0;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Failed(trfid: idname);
            }));
          } else {
            setState(() {
              _selectedpage = 0;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Failed(trfid: idname);
            }));
          }
        } else {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: idname);
          }));
        }
      }
    } else if (selectcustomer == false && selectbusiness == false) {
      idname = "bs-" + widget.phonenumber + trfid;
      print("Business is selsected and id is " + idname);

      String otp = generateRandomString(6);

      try {
        customerprocess = "loading...";
        print(customerprocess);
        idname = "bs-" + widget.phonenumber + trfid;
        print("Business Customer is selected and id is " + idname);

        customerprocess = "id is gotten";
        print(customerprocess);

        final otpresponse = await http.post(
            Uri.https('vendorhive360.com', 'vendor/otp.php'),
            body: {'idname': idname, 'email': widget.email, 'otp': otp});

        print(jsonDecode(otpresponse.body));
        if (otpresponse.statusCode == 200) {
          if (jsonDecode(otpresponse.body) == "true") {
            print("User is signed up");
            customerprocess = "Done";
            print(customerprocess);

            setState(() {
              _selectedpage = 0;
              appstatus = "Vendorhive360";
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OTPBusiness(
                idname: idname,
                email: widget.email,
                fullname: widget.fullname,
                phonenumber: widget.phonenumber,
                password: widget.password,
                confirmpassword: widget.confirmpassword,
                referalcode: widget.referalcode,
              );
            }));
          } else {
            setState(() {
              _selectedpage = 0;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Failed(trfid: idname);
            }));
          }
        } else {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: idname);
          }));
        }
      } catch (e) {
        print("Error is " + e.toString());

        final failedotp = await http.post(
            Uri.https('vendorhive360.com', 'vendor/failedotp.php'),
            body: {'email': widget.email});

        if (failedotp.statusCode == 200) {
          if (jsonDecode(failedotp.body) == "true") {
            setState(() {
              _selectedpage = 0;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Failed(trfid: idname);
            }));
          } else {
            setState(() {
              _selectedpage = 0;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Failed(trfid: idname);
            }));
          }
        } else {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: idname);
          }));
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printoutcontrollers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _selectedpage == 0
            ? GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: SafeArea(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: Center(
                              child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 23,
                            ),
                          )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            "Start by choosing your role",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectcustomer = true;
                              selectbusiness = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: selectcustomer
                                    ? Color.fromRGBO(238, 252, 233, .6)
                                    : Color.fromRGBO(217, 217, 217, .2),
                                border: selectcustomer
                                    ? Border.all()
                                    : Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(5)),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 30),
                            padding: EdgeInsets.only(top: 30, bottom: 40),
                            child: Column(
                              children: [
                                Container(
                                    child: Center(
                                  child: Image.asset("assets/customer.png"),
                                )),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Center(child: Text("I am a customer",style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),)),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectbusiness = false;
                              selectcustomer = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectbusiness
                                  ? Color.fromRGBO(217, 217, 217, .2)
                                  : Color.fromRGBO(238, 252, 233, .6),
                              borderRadius: BorderRadius.circular(5),
                              border: selectbusiness
                                  ? Border.all(color: Colors.transparent)
                                  : Border.all(),
                            ),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 30),
                            padding: EdgeInsets.only(top: 30, bottom: 40),
                            child: Column(
                              children: [
                                Container(
                                    child: Center(
                                  child: Image.asset("assets/briefcase.png"),
                                )),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Center(child: Text("I am a Vendor",style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),)),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // ids();
                            generateid();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(246, 123, 55, 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "Next",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Center(
                            child: Text(
                              appstatus,
                              style: TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          "Processing",
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
              ));
  }
}
