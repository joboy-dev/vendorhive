import 'package:flutter/material.dart';

class SuccessTopup extends StatefulWidget {
  const SuccessTopup({Key? key}) : super(key: key);

  @override
  _SuccessTopupState createState() => _SuccessTopupState();
}

class _SuccessTopupState extends State<SuccessTopup> {

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
                child: Column(
                  children: [
                    GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/3,
                        child: Image.asset("assets/successs.png",),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
