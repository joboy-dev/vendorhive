import 'package:flutter/material.dart';

class SuccessfullPayment extends StatefulWidget {
  const SuccessfullPayment({Key? key}) : super(key: key);

  @override
  _SuccessfullPaymentState createState() => _SuccessfullPaymentState();
}

class _SuccessfullPaymentState extends State<SuccessfullPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Center(child: Text("Vendorhive 360",style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
                    child: Text("Back",style: TextStyle(
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
