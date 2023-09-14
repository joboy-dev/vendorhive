import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/dashboard.dart';
import 'package:vendorandroid/screens/listing.dart';
import 'package:flutter/material.dart';

class ServiceAdded extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String packagename = "";
  String usertype = "";
  ServiceAdded({
    required this.idname,
    required this.useremail,
    required this.packagename,
    required this.usertype
  });

  @override
  _ServiceAddedState createState() => _ServiceAddedState();
}

class _ServiceAddedState extends State<ServiceAdded> {

  String? finalbalance;
  String? pendingbalance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Center(child: Text("Vendorhive 360",style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold
                ),)),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Image.asset("assets/checked.png"),
              ),
              Container(
                child: Center(child: Text("New Service Added!",style: TextStyle(
                  // fontStyle: FontStyle.italic,
                    fontSize: 14
                ),)),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {

                  final SharedPreferences prefs = await SharedPreferences.getInstance();

                  finalbalance = prefs.getString('finalbalance');
                  pendingbalance = prefs.getString('pendingbalance');

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                    return  Dashboard(
                      idname: widget.idname,
                      useremail: widget.useremail,
                      packagename: widget.packagename,
                      usertype: widget.usertype,
                      finalbalance: finalbalance??"",
                      pendingbalance: pendingbalance??"",
                    );
                  }), (r){
                    return false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15,left: 20,right: 20),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.transparent
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(14, 44, 3, 1),
                  ),
                  child: Center(
                    child: Text("Dashboard",style: TextStyle(
                        fontSize: 17,
                        color: Colors.white
                    ),),
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
