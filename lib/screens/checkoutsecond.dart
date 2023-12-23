import 'dart:convert';
import 'dart:math';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/buyproduct.dart';
import 'package:vendorandroid/screens/cardcheckoutfinal.dart';
import 'package:vendorandroid/screens/cart.dart';
import 'package:vendorandroid/screens/checkoutthird.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';

class CheckoutSecond extends StatefulWidget {
  double totalamount = 0;
  double totalamountplusdelivery = 0;
  String fullname = "";
  String phonenumber = "";
  String streetaddress = "";
  String state = "";
  String idname = "";
  String useremail = "";
  double service_fee = 0;
  String username = "";

  CheckoutSecond({required this.username, required this.totalamount,required this.totalamountplusdelivery,
  required this.fullname, required this.phonenumber,required this.streetaddress,
  required this.state,required this.idname, required this.useremail, required this.service_fee});

  @override
  _CheckoutSecondState createState() => _CheckoutSecondState();
}


class _CheckoutSecondState extends State<CheckoutSecond> {

  String paymentmethod = "wallet";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int _selectedpage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      SafeArea(
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
                            color: Colors.black,
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
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin:EdgeInsets.only(left: 10,top: 10),
                  child: Text("Choose a payment method",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: Text("You will not be charged until you review this order on the next page",
                  style: TextStyle(
                    fontSize: 14,
                  ),),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 10,top: 5,bottom: 5),
                  child: Text("₦"+"${widget.totalamountplusdelivery}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                    ),),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      if(paymentmethod != "wallet"){
                        paymentmethod = "wallet";
                      }
                      print(paymentmethod);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        paymentmethod == "wallet" ?
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2.0),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2),
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black
                            ),
                          ),
                        )

                            :

                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 2.0)
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          child: Text("My Wallet",style: TextStyle(
                            fontSize: 14
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      if(paymentmethod != "card"){
                        paymentmethod = "card";
                      }
                      print(paymentmethod);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        paymentmethod == "card" ?
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2.0),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2),
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black
                            ),
                          ),
                        )

                        :

                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 2.0)
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          child: Text("Debit/Credit Card",style: TextStyle(
                            fontSize: 14
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(paymentmethod == "wallet"){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CheckoutThird(totalamount: widget.totalamount,totalamountplusdelivery: widget.totalamountplusdelivery,
                          fullname: widget.fullname,phonenumber: widget.phonenumber,streetaddress: widget.streetaddress,
                          state: widget.state,service_fee:widget.service_fee, paymentmethod: paymentmethod,idname: widget.idname,useremail: widget.useremail,username: widget.username,);
                      }));
                    }else if(paymentmethod == 'card'){
                      print("Proceed to card payment");
                      processpayment();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10,left: 10,right: 10,top: 30),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(paymentmethod == 'card'?"Pay":"Next",style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),),
                    ),
                  ),
                ),
              ],
            )
            )
          ],
        ),
      )
      :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  Container(
                    child: Text("Processing payment",style: TextStyle(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      fontWeight: FontWeight.bold,
                    ),),
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
            ),
          )
        ],
      ),
    );
  }

  String trfid = "";
  String initiaterefno = "";

  void currentdate(){
    print('Timestamp is gotten as refno');
    DateTime now = new DateTime.now();
    print(now.toString());
    timestamp(now.toString());
    trfid = timestamp(now.toString());
    print(trfid);
  }

  String timestamp(String str){
    str = str.replaceAll(":", "");
    str = str.replaceAll("-", "");
    str = str.replaceAll(".", "");
    str = str.replaceAll(" ", "");
    return str;
  }

  Future processpayment() async{

    setState(() {
      _selectedpage = 1;
    });

    String amt = widget.totalamountplusdelivery.toString().replaceAll(",", "");
    String amount = double.parse(amt).toStringAsFixed(2);
    double a = double.parse(amount);
    double b = a *100;
    String c = b.toStringAsFixed(0);

    try{

      var paystackpayment = await http.post(
          Uri.https('api.paystack.co','transaction/initialize'),
          body: {
            'amount':c,
            'email':widget.useremail
          },
          headers: {
            'Authorization':'bearer sk_live_399d6462aa7d870cd384139c48709ea9e1ac54f4'
          }
      );

      if(paystackpayment.statusCode == 200){

        print(jsonDecode(paystackpayment.body));
        print(jsonDecode(paystackpayment.body)['status']);
        print(jsonDecode(paystackpayment.body)['data']['authorization_url']);
        print(jsonDecode(paystackpayment.body)['data']['access_code']);
        print(jsonDecode(paystackpayment.body)['data']['reference']);

        String topupurl = jsonDecode(paystackpayment.body)['data']['authorization_url'];
        initiaterefno = jsonDecode(paystackpayment.body)['data']['reference'];

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>
                BuyProduct(
                  username: widget.username,
                  topuplink: topupurl,
                  refnumber: initiaterefno,
                  service_fee: widget.service_fee,
                  idname: widget.idname,
                  useremail: widget.useremail,
                  amount: widget.totalamountplusdelivery.toString().replaceAll(",", ""),
                  state: widget.state,
                  fullname: widget.fullname,
                  streetaddress: widget.streetaddress,
                  phone_number: widget.phonenumber,
                )
            )
        );

      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out"))
        );

      }

    }
    catch(e){

      setState(() {
        _selectedpage = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request timed out"))
      );

    }
  }

  Future pay() async{

    //timestamp
    currentdate();

    try{

        print('processing payment');

        setState(() {
          _selectedpage =1;
        });

        int itemnumber = 0;

        for(int o =0; o < cartitems.length; o++){

          print('payment is made');

          String trackid = "tk-"+trfid;

          final orders = await http.post(
              Uri.https('adeoropelumi.com','vendor/vendororderstatus.php'),
              body: {
                'idname':widget.idname,
                'orderprocessed':'',
                'ordershipped':'',
                'orderarrived':'',
                'deliverypayment':'',
                'productpayment':'',
                'productid':cartitems[o].prodid,
                'productname':cartitems[o].name,
                'prodimagename': cartitems[o].imagename,
                'useremail':widget.useremail,
                'amount':cartitems[o].amount.toString(),
                'trackid':trackid,
                'tkid':trfid,
                'adminemail': cartitems[o].adminemail,
                'customerlocation' : widget.state,
                'deliveryprice' : cartitems[o].deliveryprice.toString(),
                'quantity' : cartitems[o].quantity.toString()
              }
          );

          double finalprice = cartitems[o].deliveryprice + cartitems[o].amount;

          var savetransaction = await http.post(
              Uri.https('adeoropelumi.com','vendor/vendorsaveinbusinesswallet.php'),
              body: {
                'idname': widget.idname,
                'useremail': widget.useremail,
                'adminemail': cartitems[o].adminemail,
                'debit':'0',
                'credit': finalprice.toString(),
                'status': 'pending',
                'refno' : trfid,
                'description':cartitems[o].name+" purchased",
                'itemid': cartitems[o].prodid
              }
          );

          var notifyuser = await http.post(
              Uri.https('adeoropelumi.com', 'vendor/vendorsendnotification.php'),
              body: {
                'message': cartitems[o].name+" has being ordered",
                'info': cartitems[o].adminemail,
                'tag': 'product',
                'refno': trfid,
              }
          );

          if(orders.statusCode == 200){
            if(jsonDecode(orders.body)=='true'){
              if(savetransaction.statusCode == 200){
                if(jsonDecode(savetransaction.body)=="true"){
                  if(notifyuser.statusCode == 200){
                    if(jsonDecode(notifyuser.body)=='true'){

                      print("Transaction for "+cartitems[o].prodid+" is saved");

                      print(cartitems[o].name+" is a new order");

                      print("Before ${itemnumber}");

                      itemnumber++;

                      print("After ${itemnumber}");

                      if(o == (cartitems.length-1)){

                        setState(() {

                          cartitems.clear();

                        });

                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CardCheckoutFinal(useremail: widget.useremail,idname: widget.idname,username: widget.username,);
                        }));

                      }
                      else{

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed"))
                        );

                      }
                    }
                  }
                }
              }
            }
          }

        }

    }
    catch(e){
      print("Error says "+e.toString());
      print(trfid);

      print("reversing transactions...");

      var deletefailed = await http.post(
          Uri.https('adeoropelumi.com','vendor/deletewalletcheckout.php'),
          body: {
            'refno': trfid
          }
      );

      if(jsonDecode(deletefailed.body) == "true"){

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
  }
}
