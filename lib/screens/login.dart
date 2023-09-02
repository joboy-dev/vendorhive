import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/create.dart';
import 'package:vendorandroid/screens/dashboard.dart';
import 'package:vendorandroid/screens/forgetpassword.dart';
import 'package:vendorandroid/screens/listing.dart';
import 'package:vendorandroid/screens/searchgridview.dart';
import 'package:vendorandroid/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/welcome.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _selectedpage = 0;
  String appstatus = "";
  bool obsure = true;
  String serveremail = "";
  String serverid = "";
  String serverusertype = "";
  String packagename = "";
  String finalbalance = "";
  String pendingbalance = "";
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  Future signin() async{

    setState(() {
      _selectedpage = 1;
    });

    print('processing login');
    vendoravailablebalance.clear();
    vendorpendingbalance.clear();

    try{

      setState(() {
        appstatus = 'loading..';
      });

      final response = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorsignin.php'),
          body: {
            'useremail': email.text,
            'password': pass.text
          }
      );

      final userdetails = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorgetuseremail.php'),
          body: {
            'useremail':email.text
          }
      );

      final getpackages = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorgetpackage.php'),
          body: {
            'useremail':email.text
          }
      );


      if(response.statusCode == 200){
        if(jsonDecode(response.body)['status']== "login"){
          if(userdetails.statusCode == 200){
            if(jsonDecode(userdetails.body)['status']){

              print("userdetails point");

              serveremail = jsonDecode(userdetails.body)['email'];

              serverid = jsonDecode(userdetails.body)['id'];

              serverusertype = jsonDecode(userdetails.body)['usertype'];

              if(getpackages.statusCode == 200){

                if(jsonDecode(getpackages.body)['status']){

                  print("package point");

                  packagename = jsonDecode(getpackages.body)['package'].toString();

                  print("Your package is "+packagename);

                  print("Usertype is "+serverusertype);

                  if(serverusertype == 'business'){

                    var getbalance = await http.post(
                        Uri.https('adeoropelumi.com','vendor/vendorbusinessavailablebalance.php'),
                        body: {
                          'adminemail':email.text
                        }
                    );

                    if(getbalance.statusCode == 200){

                      setState(() {

                        finalbalance = jsonDecode(getbalance.body);

                      });

                      print("final balance is "+finalbalance);

                      vendoravailablebalance.add(finalbalance);

                      var getpendingbalance = await http.post(
                          Uri.https('adeoropelumi.com','vendor/vendorbusinesspendingbalance.php'),
                          body: {
                            'adminemail':email.text
                          }
                      );

                      if(getpendingbalance.statusCode == 200){

                        setState(() {

                          pendingbalance = jsonDecode(getpendingbalance.body);

                        });

                        print("pending balance is "+pendingbalance);

                        vendorpendingbalance.add(pendingbalance);

                        final SharedPreferences pref = await SharedPreferences.getInstance();

                        await pref.setInt('counter', 1);

                        await pref.setString('idname', serverid);
                        await pref.setString('useremail', serveremail);
                        await pref.setString('packagename', packagename);
                        await pref.setString('usertype', serverusertype);
                        await pref.setString('finalbalance', finalbalance);
                        await pref.setString('pendingbalance', pendingbalance);

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                          return Dashboard(idname: serverid,
                            useremail: serveremail,
                            packagename: packagename,
                            usertype:serverusertype,
                            finalbalance: finalbalance,
                            pendingbalance: pendingbalance,);
                        }), (r){
                          return false;
                        });

                      }

                    }

                  }
                  else if(serverusertype == 'customer'){

                    var getbalance = await http.post(
                        Uri.https('adeoropelumi.com','vendor/vendorcustbalance.php'),
                        body: {
                          'custemail':email.text
                        }
                    );

                    if(getbalance.statusCode == 200){

                      setState(() {

                        finalbalance = jsonDecode(getbalance.body);

                      });

                      print("final balance is "+finalbalance);

                      final SharedPreferences prefs = await SharedPreferences.getInstance();

                      await prefs.setInt('counter', 2);

                      await prefs.setString('idname', serverid);
                      await prefs.setString('useremail', serveremail);
                      await prefs.setString('packagename', packagename);
                      await prefs.setString('usertype', serverusertype);
                      await prefs.setInt('pagenumber', 0);
                      await prefs.setString('finalbalance', finalbalance);

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                        return Welcome(idname: serverid,useremail: serveremail, packagename: packagename,
                          usertype: serverusertype,
                          pagenumber: 0,custwalletbalance: finalbalance,);
                      }), (r){
                        return false;
                      });

                    }
                    else{

                      print("Get Balance issues ${getbalance.statusCode}");

                    }
                  }
                  else{

                    setState(() {
                      _selectedpage = 0;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request timed out'))
                    );

                  }
                }
                else{

                  setState(() {
                    _selectedpage = 0;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request timed out'))
                  );

                }
              }
              else{
                setState(() {
                  _selectedpage = 0;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Request timed out'))
                );
              }
            }
            else{

              setState(() {
                _selectedpage = 0;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Request timed out'))
              );

            }
          }
          else{

            print("Get User details issues ${userdetails.statusCode}");

            setState(() {
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Request timed out'))
            );

          }
        }
        else if(jsonDecode(response.body)['status']== "invalid"){

          ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(
                content: Text('Wrong username or password'),
              ));

          setState(() {

            _selectedpage = 0;
            appstatus = '';

          });

        }
      }
      else{

        print("Network issue");

      }

    }
    catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request timed out, retry again"))
      );

      setState(() {

        _selectedpage = 0;
        appstatus = 'Request timed out, retry again';

      });

      print("error says :- "+e.toString());

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: ListView(
              children: [

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Text("Welcome",style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/12,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 30,left: 25,right: 25),
                  child: Text("Lorem ipsum dolor sit amet consectetur. Quam sed ac sed a leo ornare. Nunc ut odio felis.",
                    textAlign: TextAlign.center,style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/26
                    ),),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, top: 40,bottom: 5),
                  child: Text("Email",style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/26
                  ),),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                        width: .5, color: Colors.black), //<-- SEE HERE
                        ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: .5, color: Colors.black
                        )
                      )
                      )
                    ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, top: 10,bottom: 5),
                  child: Text("Password",style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/26
                  ),),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                      controller: pass,
                      obscureText: obsure,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                if(obsure == true){
                                  obsure = false;
                                }else if(obsure == false){
                                  obsure = true;
                                }

                              });
                            },
                              child: Container(child: Image.asset("assets/eye.png"))
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: .5, color: Colors.black), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5, color: Colors.black
                              )
                          )
                      ),

                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 9),
                  child: Center(child: Text(appstatus,style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14
                  ),)),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ForgetPassword();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Forgot Password?",style: TextStyle(
                            decoration: TextDecoration.underline,
                              fontSize: MediaQuery.of(context).size.width/26
                          ),),
                        )
                      ],
                    ),
                  ),
                ),

                //sign in
                GestureDetector(
                  onTap: (){
                    if(email.text != "" && pass.text != ""){
                      signin();
                    }
                    else{

                      ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text('Fill all your fields'),
                          ));

                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 40, 10, 5),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(14, 44, 3, 1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Sign In",style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width/20,
                      fontWeight: FontWeight.bold
                    ),)),
                  ),
                ),

                //create account
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Create();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Create an Account",style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/20,
                        fontWeight: FontWeight.bold
                    ),)),
                  ),
                ),

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
                    child: Text("Signing in",style: TextStyle(
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
