import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'successfulproductreject.dart';

class Viewadminorder extends StatefulWidget {
  String productname = "";
  String productid = "";
  String productimage = "";
  String productprice = "";
  String deliveryprice = "";
  String location = "";
  String adminemail = "";
  String useremail = "";
  String tkid = "";
  String customername = "";
  String customernumber = "";
  String customerlocation = "";
  String customerstate = "";
  String quantity = "";
  String trackid = "";
  String date = "";
  String time = "";
  String deliveryplan = "";
  String deliveryday = "";

  Viewadminorder({
    required this.deliveryplan,
    required this.deliveryday,
    required this.date,
    required this.time,
    required this.trackid,
    required this.quantity,
    required this.customername,
    required this.customernumber,
    required this.customerlocation,
    required this.customerstate,
    required this.productname,
    required this.productid,
    required this.productimage,
    required this.productprice,
    required this.deliveryprice,
    required this.location,
    required this.adminemail,
    required this.useremail,
    required this.tkid
  });

  @override
  _ViewadminorderState createState() => _ViewadminorderState();
}

class _ViewadminorderState extends State<Viewadminorder> {

  int _selectedpage = 0;
  bool shipped = false;
  bool delivered = false;
  bool reject = false;
  int shippedpin = 0;
  int deliveredpin = 0;
  int rejectpin = 0;
  bool enableshipping = false;
  bool enabledelivery = false;
  bool loading = false;
  bool loadingdeli = false;
  String appstat = "Vendorhive360";

  ScrollController _controller = ScrollController();

  TextEditingController _shippedpin = TextEditingController();
  TextEditingController _deliveredpin = TextEditingController();
  TextEditingController _rejectpin = TextEditingController();
  TextEditingController _reject_reason = TextEditingController();

  Future productstats() async{

    setState(() {
      appstat = "loading...";
    });

    var productstatus = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorshipped.php'),
        body: {
          'productid':widget.tkid,
          'adminemail':widget.adminemail,
          'useremail':widget.useremail
        }
    );

    if(productstatus.statusCode == 200){
      print(jsonDecode(productstatus.body)[0]['ordershipped']);
      if(jsonDecode(productstatus.body)[0]['ordershipped'] == 'undone' &&
          jsonDecode(productstatus.body)[0]['orderarrived'] == 'undone'){

        setState(() {
          enableshipping = true;
          enabledelivery = false;
          loading = true;
          loadingdeli = false;
          appstat = "Vendorhive360";
        });

      }
      else{

        setState(() {
          loading = false;
          enableshipping = false;
          enabledelivery = false;
        });

        print(jsonDecode(productstatus.body)[0]['orderarrived']);
        if(jsonDecode(productstatus.body)[0]['orderarrived'] == 'undone' &&
            jsonDecode(productstatus.body)[0]['ordershipped'] == 'done'){

          setState(() {
            loading = true;
            enabledelivery = true;
            loadingdeli = false;
            appstat = "Vendorhive360";
          });

        }
        else{

          setState(() {
            loading = true;
            enabledelivery = false;
            loadingdeli = true;
            appstat = "Vendorhive360";
          });

        }
      }
    }
  }

  Future updateshippedorder() async {
    print("Update order to shipped");
    setState(() {
      _selectedpage = 1;
    });

    var updateshiporder = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorupdateshipped.php'),
        body: {
          'productid':widget.productid,
          'adminemail':widget.adminemail,
          'useremail':widget.useremail,
          'tkid' : widget.tkid
        }
    );

    if(updateshiporder.statusCode == 200){
      if(jsonDecode(updateshiporder.body)=='true'){

        setState(() {
          _selectedpage = 0;
          loading = true;
          shipped = false;
          enableshipping = false;
          loading = true;
          enabledelivery = true;
          loadingdeli = false;
        });

        print("Shipped order is registered");

      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        print("Shipped order is not registered");

      }
    }
  }

  Future updatearrivedorder() async {
    print("Update order to arrived");
    setState(() {
      _selectedpage = 1;
    });

    var updatearrive = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorupdatearrived.php'),
        body: {
          'productid':widget.productid,
          'useremail':widget.useremail,
          'adminemail': widget.adminemail,
          'tkid' : widget.tkid
        }
    );

    if(updatearrive.statusCode == 200){
      if(jsonDecode(updatearrive.body)=='true'){
        setState(() {
          _selectedpage = 0;
          delivered = false;
          enabledelivery = false;
          loadingdeli = true;
          loading = true;
        });
        print("Product has arrived at destination");
      }
      else{
        setState(() {
          _selectedpage = 0;
        });
        print("Product has not arrived at destination");
      }
    }
    else{
      setState(() {
        _selectedpage = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Issues'))
      );
    }
  }

  Future reject_order() async{
    print("Reject Order");

    setState(() {
      _selectedpage = 1;
    });

    var order_reject = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorgetidname.php'),
        body: {
          'useremail' : widget.useremail
        }
    );

    print(jsonDecode(order_reject.body));
    if(order_reject.statusCode == 200 && jsonDecode(order_reject.body) != "false"){

      // a refund is to be done for product price
      var credit_custwallet_amount = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorcustupdatewallet.php'),
          body: {
            'idname': jsonDecode(order_reject.body).toString(),
            'email':widget.useremail,
            'debit': "0",
            'credit': widget.productprice,
            'desc':'RVS Product amount',
            'refno': widget.tkid,
          }
      );

      // a refund is to be done for product price
      var credit_custwallet_delivery = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorcustupdatewallet.php'),
          body: {
            'idname': jsonDecode(order_reject.body).toString(),
            'email':widget.useremail,
            'debit': "0",
            'credit': widget.deliveryprice,
            'desc':'RVS Delivery amount',
            'refno': widget.tkid,
          }
      );

      //a record of the rejection should be done
      var record_reject = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorreject.php'),
          body: {
            'productid': widget.productid,
            'productname': widget.productname,
            'productprice': widget.productprice,
            'deliveryprice': widget.deliveryprice,
            'deliverplan': widget.deliveryplan,
            'deliveryday': widget.deliveryday,
            'customernumber': widget.customernumber,
            'customerlocation': widget.customerlocation,
            'customerstate': widget.customerstate,
            'customername': widget.customername,
            'customeremail': widget.useremail,
            'vendoremail': widget.adminemail,
            'quantity': widget.quantity,
            'trackid': widget.trackid,
            'reason' : _reject_reason.text
          }
      );

      //delete the product from orders
      var delete_ordered = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorrejectorder.php'),
          body:{
            'pidname' : widget.productid,
            'tkid' : widget.tkid,
            'useremail' : widget.useremail,
            'adminemail' : widget.adminemail,
          }
      );

      //notify user
      var notifyuser = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorsendnotification.php'),
          body: {
            'message': widget.productname+" has being rejected",
            'info': widget.useremail,
            'tag': 'Product',
            'quantity' : widget.quantity,
            'refno': widget.tkid
          }
      );

      if(jsonDecode(delete_ordered.body) == "true" &&
      jsonDecode(record_reject.body) == "true" &&
      jsonDecode(credit_custwallet_delivery.body) == "true" &&
      jsonDecode(credit_custwallet_amount.body) == "true"){

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SuccessReject();
        }));

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product is rejected")));
      }
      else{
        setState(() {
          _selectedpage = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out")));
      }


      // WidgetsBinding.instance
      //     .addPostFrameCallback((_){
      //   _scrollDown();
      // });
    }
  }

  // Scroll down
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productstats();
    print(widget.tkid);
    print(widget.customername);
    print(widget.customernumber);
    print(widget.customerlocation);
    print(widget.customerstate);
    print(widget.adminemail);
    print(widget.useremail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollDown,
        child: Icon(Icons.arrow_drop_down_circle_rounded),
      ),
      body: _selectedpage == 0 ?
      Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SafeArea(
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
                        child: Text("Order Status",style: TextStyle(
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
                  )
              ),

              Flexible(
                  child: ListView(
                  controller: _controller,
                  children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height/30,
                  ),

                  //Image
                  Container(
                    height: MediaQuery.of(context).size.height/4,
                    child: Center(child: FadeInImage(
                      image: NetworkImage(
                        "https://adeoropelumi.com/vendor/productimage/"+widget.productimage,
                      ),
                      placeholder: AssetImage(
                          "assets/image.png"),
                      imageErrorBuilder:
                          (context, error,
                          stackTrace) {
                        return Image.asset(
                            'assets/error.png',
                            fit: BoxFit
                                .fitWidth);
                      },
                      fit: BoxFit.fitWidth,
                    )
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("Customer Name: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(widget.customername,
                            style: TextStyle(
                              fontSize: 14,
                            ),textAlign: TextAlign.end,),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Customer Phonenumber: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.customernumber,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Customer Address: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.customerlocation,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Customer State: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.customerstate,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Quantity: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.quantity,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Delivery Plan: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.deliveryplan,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Days of delivery: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.deliveryday,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Product Id: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.trackid,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Date & Time: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(widget.date+" & "+widget.time,
                                style: TextStyle(
                                  fontSize: 14,
                                ),textAlign: TextAlign.end,),
                            ),
                          )
                        ],
                      ),
                    ),

                  //inform
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text("Inform the customer about he/her product "),
                      ),
                    ),

                  enableshipping ?
                  GestureDetector(
                    onTap: () {
                      if(shipped == false){
                        var rng = Random();
                        shippedpin = rng.nextInt(9999);
                        setState(() {
                          shipped = true;
                        });
                        WidgetsBinding.instance
                            .addPostFrameCallback((_){
                          _scrollDown();
                        });
                      }else if(shipped == true){
                        setState(() {
                          shipped = false;
                        });
                      }

                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(14, 44, 3, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Order is shipped",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),)),
                    ),
                  )
                  :Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(178, 190, 181, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child:
                      loading ?
                      Text("Customer is notified of shipped order",
                        textAlign: TextAlign.center,style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),)
                          :
                          Icon(Icons.more_horiz)
                      ),
                    ),

                  shipped ?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text("Shipped pin is ${shippedpin}"),
                    ),
                  )
                  :Container(),

                  shipped ?
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: _shippedpin,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter shipped pin',
                        enabledBorder: OutlineInputBorder(

                        ),
                        focusedBorder: OutlineInputBorder(

                        )
                      ),
                    ),
                  )
                  :Container(),

                  shipped ?
                  GestureDetector(
                    onTap: () {
                      if(_shippedpin.text == shippedpin.toString()){
                        print("Correct pin");
                        updateshippedorder();
                      }else{
                        print("wrong pin");
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text('wrong pin'),
                            ));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Click here to confirm shipment",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),textAlign: TextAlign.center,)),
                    ),
                  )
                  :Container(),

                  enabledelivery ?
                  GestureDetector(
                    onTap: (){
                      if(delivered == false){
                        var rng = Random();
                        deliveredpin = rng.nextInt(9999);
                        setState(() {
                          delivered = true;
                        });
                        WidgetsBinding.instance
                            .addPostFrameCallback((_){
                          _scrollDown();
                        });
                      }else if(delivered == true){
                        setState(() {
                          delivered = false;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(14, 44, 3, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Order is delivered",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),)),
                    ),
                  )
                  :Container(

                    margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    padding: EdgeInsets.symmetric(vertical: 18),

                    decoration: BoxDecoration(
                        color: Color.fromRGBO(178, 190, 181, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),

                    child: Center(
                        child: loadingdeli ?
                    Text("Customer is notified of delivered order",
                      textAlign: TextAlign.center,style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),)
                    :Icon(Icons.more_horiz)

                    ),
                  ),

                  delivered ?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text("Delivery pin is ${deliveredpin}"),
                    ),
                  )
                  :Container(),

                  delivered ?
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: _deliveredpin,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter delivery pin',
                          enabledBorder: OutlineInputBorder(

                          ),
                          focusedBorder: OutlineInputBorder(

                          )
                      ),
                    ),
                  )
                  :Container(),

                  delivered ?
                  GestureDetector(
                    onTap: () {
                      if(_deliveredpin.text == deliveredpin.toString()){
                        print("Correct pin");
                        updatearrivedorder();

                      }else{
                        print("wrong pin");
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text('wrong pin'),
                            ));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Click here to confirm delivery",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),)),
                    ),
                  )
                  :Container(),

                  reject ?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text("Reject pin is ${rejectpin}"),
                    ),
                  )
                  :Container(),

                  reject ?
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: _rejectpin,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter reject pin',
                          enabledBorder: OutlineInputBorder(

                          ),
                          focusedBorder: OutlineInputBorder(

                          )
                      ),
                    ),
                  )
                  :Container(),

                  reject ?
                  const SizedBox(
                    height: 10,
                  )
                  : Container(),

                  reject ?
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _reject_reason,
                      decoration: InputDecoration(
                        hintText: "Enter reason for rejecting",
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder()
                      ),
                    ),
                  )
                  : Container(),

                  reject ?
                  const SizedBox(
                    height: 10,
                  )
                  : Container(),

                  reject ?
                  GestureDetector(
                    onTap: () {
                      if(_rejectpin.text.isEmpty || _reject_reason.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Fill all rejection fileds"))
                        );
                      }else{
                        if(_rejectpin.text == rejectpin.toString()){
                          print("Correct pin");
                          reject_order();
                        }
                        else{
                          print("wrong pin");
                          ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text('Wrong pin'),
                              ));
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 4, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Click here to reject",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),)),
                    ),
                  )
                  :Container(),

                  enableshipping == false && enabledelivery == false ?
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child:
                    Icon(Icons.more_horiz)
                    ),
                  )
                  :GestureDetector(
                    onTap: () {
                      if(reject == false){
                        var rng = Random();
                        rejectpin = rng.nextInt(9999);
                        setState(() {
                          reject = true;
                        });
                        WidgetsBinding.instance
                            .addPostFrameCallback((_){
                          _scrollDown();
                        });
                      }else if(reject == true){
                        setState(() {
                          reject = false;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(246, 123, 55, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Reject Order",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),)),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 10,top: 10),
                    child: Center(
                      child: Text(appstat,style: TextStyle(
                          fontStyle: FontStyle.italic
                      ),),
                    ),
                  )
                ],
              )),
            ],
          ),
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
                    child: Text("Processing",style: TextStyle(
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
}
