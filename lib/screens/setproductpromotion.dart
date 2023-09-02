import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/payforpromotion.dart';


class SetPromotion extends StatefulWidget {
  String idname = "";
  String pidname = "";
  String prodname = "";
  String prodimg = "";
  String adminemail = "";

  SetPromotion({required this.pidname,
  required this.prodname,
  required this.prodimg,
  required this.adminemail,
  required this.idname});

  @override
  _SetPromotionState createState() => _SetPromotionState();
}

class _SetPromotionState extends State<SetPromotion> {

  TextEditingController _amount = new TextEditingController();
  TextEditingController _days = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.pidname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: Column(
              children: [
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
                        child: Text("Promote product",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.arrow_back,color: Colors.white,)
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width/3,
                  child:  Center(
                    child: FadeInImage(
                      image: NetworkImage("https://adeoropelumi.com/vendor/productimage/"+widget.prodimg),
                      placeholder: AssetImage(
                          "assets/image.png"),
                      imageErrorBuilder:
                          (context, error, stackTrace) {
                        return Image.asset(
                            'assets/error.png',
                            fit: BoxFit.fitWidth);
                      },
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: Text('Set promotion for '+widget.prodname,
                    textAlign: TextAlign.center,style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                    ),)),
                ),

                Container(
                  child: Flexible(
                    child: ListView(
                      padding: EdgeInsets.only(top: 10),
                      children: [

                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child: Text('Amount',style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25
                          ),),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                          child: TextField(
                            controller: _amount,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              ThousandsFormatter(allowFraction: true)
                            ],
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .5,
                                      color: Colors.grey
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .5,
                                      color: Colors.grey
                                  )
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                          child: Text('Days',style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25
                          ),),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                          child: TextField(
                            controller: _days,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .5,
                                      color: Colors.grey
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .5,
                                      color: Colors.grey
                                  )
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){

                            if(_amount.text.isNotEmpty && _days.text.isNotEmpty){

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return PayForPromotion(
                                  idname: widget.idname,
                                  adminemail: widget.adminemail,
                                  prodimg: widget.prodimg,
                                  prodname: widget.prodname,
                                  pidname: widget.pidname,
                                  amount: _amount.text.replaceAll(',', ''),
                                  days: _days.text.replaceAll(',', ''),
                                );
                              }));

                            }
                            else{

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fill all fields'))
                              );

                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.orangeAccent
                                ),
                                color: Colors.green
                            ),
                            child: Center(child: Text('Pay',style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width/20,
                                fontWeight: FontWeight.bold
                            ),)),
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
      ),
    );
  }

}
