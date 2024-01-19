import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Transactions extends StatefulWidget {
  String idname = "";
  String adminemail = "";
  Transactions({required this.idname,required this.adminemail});

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List rawpayment = [];
  bool showpayments = false;

  Future transactions() async{

    var gettransactions = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorbusinesstransaction.php'),
        body: {
          'adminemail': widget.adminemail
        }
    );

    if(gettransactions.statusCode == 200){

      print(jsonDecode(gettransactions.body));

      rawpayment = jsonDecode(gettransactions.body);

      setState(() {
        showpayments = true;
      });

    }

  }

  @override
  initState(){
    super.initState();
    transactions();
  }

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
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Transaction History",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
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

            Flexible(
              child: showpayments ?
              rawpayment.length > 0?
              RefreshIndicator(
                onRefresh: transactions,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rawpayment.length,
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.only(bottom: 12.5),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: .7,
                                    color: Colors.grey
                                )
                            )
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              decoration:BoxDecoration(
                                  color: rawpayment[index]['debit'] != "0"
                                      ?Colors.black:
                                  Color.fromRGBO(2, 176, 9, 1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: rawpayment[index]['debit'] != "0"
                                  ?
                              Image.asset("assets/money-withdrawal.png",color: Colors.white,):
                              Image.asset("assets/topup.png",color: Colors.white,),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10,top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(rawpayment[index]['debit'] != "0"?
                                      "Withdrawal" : "Deposit",style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(rawpayment[index]['date']+" "+
                                          rawpayment[index]['time'],style: TextStyle(
                                          fontSize: 10
                                      ),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10,left: 10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(rawpayment[index]['debit'] != "0"?
                                    "-₦"+rawpayment[index]['debit'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
                                        : "₦"+rawpayment[index]['credit'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      color: rawpayment[index]['debit'] != "0"? Colors.red: Colors.green[900]
                                    ),),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              )
                :
              Container(
                child: Center(
                  child: Column(
                    children: [
                      Spacer(),
                      Image.asset("assets/empty.png",
                        width: MediaQuery.of(context).size.width/3,),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text("no transaction",style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/30,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              )
                  :
              Container(
                child: Center(
                  child: Column(
                    children: [
                      Spacer(),
                      // Image.asset("assets/loading.png",
                      //   width: MediaQuery.of(context).size.width/3,),
                      CircularProgressIndicator(
                        color: Colors.orange,
                        backgroundColor: Colors.green,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("loading.....",style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/30,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
