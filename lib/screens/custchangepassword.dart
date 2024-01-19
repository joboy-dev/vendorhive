import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustChangePassword extends StatefulWidget {
  String idname = "";
  String email = "";

  CustChangePassword({Key? key, required this.idname, required this.email})
      : super(key: key);

  @override
  _CustChangePasswordState createState() => _CustChangePasswordState();
}

class _CustChangePasswordState extends State<CustChangePassword> {
  bool press = false;
  int _selectedpage = 0;
  TextEditingController _oldpass = new TextEditingController();
  TextEditingController _newpass = new TextEditingController();

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
                      //change password app bar
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
                              child: Text(
                                "Change Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(217, 217, 217, 1),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      //warning text
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            "Ensure you don't forget your new password ",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 27),
                          ),
                        ),
                      ),
                      //old password textfield
                      Container(
                        child: TextField(
                          controller: _oldpass,
                          decoration: InputDecoration(
                              hintText: 'Enter Old Password',
                              contentPadding: EdgeInsets.only(left: 10)),
                        ),
                      ),
                      //new password textfield
                      Container(
                        child: TextField(
                          controller: _newpass,
                          decoration: InputDecoration(
                              hintText: 'Enter New Password',
                              contentPadding: EdgeInsets.only(left: 10)),
                        ),
                      ),
                      //change password button
                      GestureDetector(
                        onTap: () {
                          if (_newpass.text.contains("'") ||
                              _newpass.text.contains(r'\') ||
                              _oldpass.text.contains(r'\') ||
                              _oldpass.text.contains("'")) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Password must not contain ' or \\ ")));
                          } else {
                            if (_oldpass.text.isNotEmpty &&
                                _newpass.text.isNotEmpty) {
                              print("pressed change password");
                              if (press == false) {
                                setState(() {
                                  press = true;
                                });
                                updatepassword();
                              } else {}
                            } else {
                              print('Please fill all fields');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fill all fields')));
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.orangeAccent),
                              color: Colors.green),
                          child: Center(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 21),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            'Vendorhive360',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        height: MediaQuery.of(context).size.width / 2,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset("assets/mobile-password.png"),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Column(
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
                )
              ],
            ),
    );
  }

  Future updatepassword() async {
    setState(() {
      _selectedpage = 1;
    });

    var checkpassword = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorsignin.php'),
        body: {'useremail': widget.email, 'password': _oldpass.text});

    print(jsonDecode(checkpassword.body)['status']);
    print(jsonDecode(checkpassword.body));

    if (checkpassword.statusCode == 200) {
      if (jsonDecode(checkpassword.body)['status'] == 'login') {
        var passwordupdate = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorupdatepassword.php'),
            body: {
              'idname': widget.idname,
              'email': widget.email,
              'password': _newpass.text
            });

        print(widget.email);
        print(_newpass.text);
        print(jsonDecode(passwordupdate.body));

        if (passwordupdate.statusCode == 200) {
          if (jsonDecode(passwordupdate.body) == 'true') {
            setState(() {
              _oldpass.clear();
              _newpass.clear();
              _selectedpage = 0;
              press = false;
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Password is updated')));
          } else {
            setState(() {
              _oldpass.clear();
              _newpass.clear();
              _selectedpage = 0;
              press = false;
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Failed')));
          }
        } else {
          print("Password update issues ${passwordupdate.statusCode}");

          setState(() {
            _oldpass.clear();
            _newpass.clear();
            _selectedpage = 0;
            press = false;
          });
        }
      } else if (jsonDecode(checkpassword.body)['status'] == 'invalid') {
        setState(() {
          _oldpass.clear();
          _newpass.clear();
          _selectedpage = 0;
          press = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Old Password is wrong')));
      }
    } else {
      print("Check password issues ${checkpassword.statusCode}");

      setState(() {
        _oldpass.clear();
        _newpass.clear();
        _selectedpage = 0;
        press = false;
      });
    }
  }
}
