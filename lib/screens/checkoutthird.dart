import 'package:vendorandroid/screens/checkoutfourth.dart';
import 'package:flutter/material.dart';

class CheckoutThird extends StatefulWidget {
  double totalamount = 0;
  double totalamountplusdelivery = 0;
  String fullname = "";
  String phonenumber = "";
  String streetaddress = "";
  String state = "";
  String paymentmethod = "";
  String idname = "";
  String useremail = "";
  double service_fee = 0;

  CheckoutThird({required this.totalamount, required this.totalamountplusdelivery,
  required this.fullname, required this.phonenumber, required this.streetaddress,
  required this.state, required this.paymentmethod,
  required this.idname, required this.useremail, required this.service_fee});

  @override
  _CheckoutThirdState createState() => _CheckoutThirdState();
}

class _CheckoutThirdState extends State<CheckoutThird> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.totalamount);
    print(widget.totalamountplusdelivery);
    print(widget.fullname);
    print(widget.phonenumber);
    print(widget.state);
    print(widget.streetaddress);
    print(widget.paymentmethod);
    print(widget.idname);
    print(widget.useremail);
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
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    )
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
                    decoration: BoxDecoration(
                        color: Colors.black,
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
              padding: EdgeInsets.zero,
              children:[
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,right: 10),
                  child: Text("Please confirm and submit your order",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/18,
                    fontWeight: FontWeight.w500
                  ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: Text("By clicking submit order, you agree to Vendor Hive 360’s Terms of Use and Privacy Policy",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/27,
                  ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                  padding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text("Payment",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/25,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            )
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text("Amount",
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/25,
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.w500
                                  ),),
                              ),
                            )
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(Icons.account_balance_wallet_rounded,
                                      size: MediaQuery.of(context).size.width/12,
                                      color: Color.fromRGBO(5, 102, 8, 1),),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text("My Wallet",style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/25,
                                    ),),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Text("₦"+"${widget.totalamountplusdelivery}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/25,
                              ),),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
                  padding: EdgeInsets.only(top: 15, bottom: 15,left: 10,right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text("Shipping address",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/25,
                                    fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: Text("Details",style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/25,
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Full Name",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/27,
                              ),),
                            ),
                            Flexible(
                              child: Container(
                                child: Text(widget.fullname,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Street Address",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27,
                              ),),
                            ),
                            Flexible(
                              child: Container(
                                child: Text(widget.streetaddress,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/27,
                                      fontWeight: FontWeight.w500
                                  ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("State",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27,
                              ),),
                            ),
                            Flexible(
                              child: Container(
                                child: Text(widget.state,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/27,
                                    fontWeight: FontWeight.w500
                                  ),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(right: 10,left: 10,top: 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 252, 233, 1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:EdgeInsets.only(top: 10),
                        child: Text("Order summary",style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/25,
                          fontWeight: FontWeight.w500
                        ),),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Subtotal",
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/27,
                              ),),
                            ),
                            Expanded(
                              child: Container(
                                child: Text("₦"+"${widget.totalamount}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27,
                                ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Delivery",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/27,
                              ),),
                            ),
                            Expanded(
                              child: Container(
                                child: Text("₦"+"${widget.totalamountplusdelivery - (widget.totalamount+widget.service_fee)}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27,
                                ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Service Fee",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/27,
                              ),),
                            ),
                            Expanded(
                              child: Container(
                                child: Text("₦"+"${widget.service_fee}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/27,
                                  ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Total",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27,
                                fontWeight: FontWeight.w500
                              ),),
                            ),
                            Expanded(
                              child: Container(
                                child: Text("₦"+"${widget.totalamountplusdelivery}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/27,
                                  ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return CheckoutFourth(totalamount: widget.totalamount,
                            totalamountplusdelivery: widget.totalamountplusdelivery,
                            fullname: widget.fullname,
                            phonenumber: widget.phonenumber,
                            streetaddress: widget.streetaddress,
                            state: widget.state,
                            paymentmethod: widget.paymentmethod,
                            useremail: widget.useremail,
                            service_fee: widget.service_fee,
                            idname: widget.idname,);
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          margin: EdgeInsets.only(top: 20,bottom: 40),
                          child: Center(child: Text("Submit Order",style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width/22,
                            fontWeight: FontWeight.w500
                          ),)),
                        ),
                      )
                    ],
                  ),
                )
              ]
            )
            )
          ],
        ),
      ),
    );
  }
}
