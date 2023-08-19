import 'package:flutter/material.dart';

class Productpromotedone extends StatefulWidget {
  const Productpromotedone({Key? key}) : super(key: key);

  @override
  _ProductpromotedoneState createState() => _ProductpromotedoneState();
}

class _ProductpromotedoneState extends State<Productpromotedone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                      child: Text('Vendorhive 360',style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/20,
                          fontStyle: FontStyle.italic
                      ),)
                  ),
                ),

                Spacer(),

                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Image.asset('assets/pro.png',),
                ),

                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text('Promotion is set',style: TextStyle(
                    fontStyle: FontStyle.italic
                  ),),
                ),

                Spacer(),

                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orangeAccent
                    ),
                    child: Center(
                        child:
                        Text('Back',style: TextStyle(
                      color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/18,
                          fontWeight: FontWeight.w500
                    ),
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
