import 'package:flutter/material.dart';

class VendorTransactions extends StatefulWidget {
  const VendorTransactions({Key? key}) : super(key: key);

  @override
  _VendorTransactionsState createState() => _VendorTransactionsState();
}

class _VendorTransactionsState extends State<VendorTransactions> {
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
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Transaction History",style: TextStyle(
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
            Flexible(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
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
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/money-withdrawal.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Withdrawal",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("12:01 pm",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/money-withdrawal.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Withdrawal",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("10:04 am",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                                color: Color.fromRGBO(2, 176, 9, 1),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/topup.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Card deposit",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(2, 176, 9, 1),
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/money-withdrawal.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Withdrawal",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("10:04 am",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                                color: Color.fromRGBO(2, 176, 9, 1),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/transfer.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Bank Transfer",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(2, 176, 9, 1),
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/money-withdrawal.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Withdrawal",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("10:04 am",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/money-withdrawal.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Withdrawal",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("10:04 am",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                                color: Color.fromRGBO(2, 176, 9, 1),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child: Image.asset("assets/topup.png",color: Colors.white,),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Card deposit",style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                        fontSize: 10
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Text("-N30,000",style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(2, 176, 9, 1),
                                  ),),
                                ),
                              ],
                            ),
                          )
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
