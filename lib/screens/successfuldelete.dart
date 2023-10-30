import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/login.dart';

class SuccessDelete extends StatefulWidget {
  const SuccessDelete({Key? key}) : super(key: key);

  @override
  _SuccessDeleteState createState() => _SuccessDeleteState();
}

class _SuccessDeleteState extends State<SuccessDelete> {

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade100,
                    Colors.green.shade100
                  ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
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
                          height: MediaQuery.of(context).size.height/3,
                          child: Image.asset("assets/successs.png",),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Your account has being deleted",style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center,)
                      ),
                      GestureDetector(
                        onTap: () async {
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
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Text("Click here to go back",style: TextStyle(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width/23
                          ),),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text('Vendorhive360',style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold
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
      ),
    );
  }
}
