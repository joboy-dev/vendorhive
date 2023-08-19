import 'package:vendorandroid/screens/activeproductorders.dart';
import 'package:flutter/material.dart';

class CardCheckoutFinal extends StatefulWidget {
  String useremail = "";
  String idname = "";
  CardCheckoutFinal({required this.useremail,required this.idname});

  @override
  _CardCheckoutFinalState createState() => _CardCheckoutFinalState();
}

class _CardCheckoutFinalState extends State<CardCheckoutFinal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        )
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 252, 233, 1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/23,)
                        ),
                        width: MediaQuery.of(context).size.width/13,
                        height: MediaQuery.of(context).size.width/13,
                        child: Center(
                          child: Text("1",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/23,
                              color: Colors.white
                          ),),
                        ),
                      )
                  ),
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/60,),
                    child: Text("Shipment",style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/27,
                    ),),
                  ),),
                  Container(
                    child: Text("->  ",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
                  ),
                  Container(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/23,)
                        ),
                        width: MediaQuery.of(context).size.width/13,
                        height: MediaQuery.of(context).size.width/13,
                        child: Center(
                          child: Text("2",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/23,
                              color: Colors.white
                          ),),
                        ),
                      )
                  ),
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/60,),
                    child: Text("Payment",style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/27,
                    ),),
                  ),),
                  Container(
                    child: Text("->  ",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
                  ),
                  Container(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/23,)
                        ),
                        width: MediaQuery.of(context).size.width/13,
                        height: MediaQuery.of(context).size.width/13,
                        child: Center(
                          child: Text("3",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/23,
                              color: Colors.white
                          ),),
                        ),
                      )
                  ),
                  Expanded(child: Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/60,),
                    child: Text("Review",style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/27,
                    ),),
                  )),
                ],
              ),
            ),
            Flexible(
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/20,),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width:MediaQuery.of(context).size.width/2,
                            height: MediaQuery.of(context).size.width/2,
                            child: Center(child: Image.asset("assets/success.png")),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Success",style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Your payment has been received and you’ll get notifications for your order status.",textAlign: TextAlign.center,style: TextStyle(
                                  fontSize: 14
                              ),),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ActiveProductOrders(useremail:widget.useremail,idname: widget.idname,);
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              margin: EdgeInsets.only(left: 20,right: 20,top: 15),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text("Track order status",style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                ),),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              margin: EdgeInsets.only(left: 20,right: 20,top: 15),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text("Back",style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                ),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
