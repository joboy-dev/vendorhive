import 'package:vendorandroid/screens/login.dart';
import 'package:flutter/material.dart';

class SuccessSignup extends StatefulWidget {
  const SuccessSignup({Key? key}) : super(key: key);

  @override
  _SuccessSignupState createState() => _SuccessSignupState();
}

class _SuccessSignupState extends State<SuccessSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                child: Center(child: Text("Vendorhive360",style: TextStyle(
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
              Spacer(),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                    return  Login();
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
                    child: Text("Welcome",style: TextStyle(
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
