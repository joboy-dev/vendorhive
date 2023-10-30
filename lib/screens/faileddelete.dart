import 'package:flutter/material.dart';

class FailedDelete extends StatefulWidget {
  const FailedDelete({Key? key}) : super(key: key);

  @override
  _FailedDeleteState createState() => _FailedDeleteState();
}

class _FailedDeleteState extends State<FailedDelete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height/3,
                      child: Image.asset("assets/failed.png",),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(2))
                      ),
                      child: Text("Go back and retry",style: TextStyle(
                          color: Color.fromRGBO(246, 123, 55, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width/23
                      ),),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text('Vendorhive360',style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold
                        ),),
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
}
