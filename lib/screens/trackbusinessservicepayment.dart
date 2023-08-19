import 'package:flutter/material.dart';

class TrackBusinessServicePayment extends StatefulWidget {
  String idname = "";
  String sidname = "";
  String servicename = "";
  String adminemail = "";
  String useremail = "";
  String amount = "";
  String date = "";
  String time = "";
  String refno = "";
  String description  = "";
  String status = "";
  String refund = "";
  TrackBusinessServicePayment({Key? key,
    required this.idname,
    required this.sidname,
    required this.servicename,
    required this.adminemail,
    required this.useremail,
    required this.amount,
    required this.date,
    required this.time,
    required this.status,
    required this.description,
    required this.refno,
    required this.refund}) : super(key: key);

  @override
  _TrackBusinessServicePaymentState createState() => _TrackBusinessServicePaymentState();
}

class _TrackBusinessServicePaymentState extends State<TrackBusinessServicePayment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: SafeArea(
            child: Container(
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
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text("Payment Details",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Flexible(child: ListView(children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10,top: 10),
                      child: Center(
                        child: Text('Date of Payment',style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(widget.date,style: TextStyle(
                            fontSize: 14
                        ),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                      padding: EdgeInsets.only(top: 20,left: 5,right: 5,bottom: 20),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(80, 200, 120, .5)
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  child: Text("Amount: ",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text("₦"+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  child: Text("Service Name: ",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(widget.servicename),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  child: Text("Description: ",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(widget.description),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  child: Text("Time: ",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(widget.time),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  child: Text("Payment from: ",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(widget.useremail),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text('Vendorhive 360',style: TextStyle(
                          fontStyle: FontStyle.italic
                        ),),
                      ),
                    )
                  ],))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
