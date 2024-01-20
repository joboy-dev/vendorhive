import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/vendor_admin_invoice.dart';

import 'successfulproductreject.dart';

class Viewadminorder extends StatefulWidget {
  String idname = "";
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
  final String timeordered;
  final String dateshipped;
  final String timeshipped;
  final String datearrived;
  final String timearrived;
  final String datedprelease;
  final String timedprelease;
  final String ordershipped;
  final String orderarrived;
  final String deliverypayment;
  final String productpayment;

  Viewadminorder(
      {required this.idname,
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
      required this.tkid,
      required this.timeordered,
      required this.dateshipped,
      required this.timeshipped,
      required this.datearrived,
      required this.timearrived,
      required this.datedprelease,
      required this.timedprelease,
      required this.ordershipped,
      required this.orderarrived,
      required this.deliverypayment,
      required this.productpayment});

  @override
  _ViewadminorderState createState() => _ViewadminorderState();
}

class _ViewadminorderState extends State<Viewadminorder> {
  bool checker = false;
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
  String productPayment = "";
  bool showtracks = true;
  String ordershipped = 'undone';
  String orderarrived = 'undone';
  String dpreleased = 'undone';
  String ppreleased = 'undone';
  String appstat = "Vendorhive360";

  ScrollController _controller = ScrollController();

  TextEditingController _shippedpin = TextEditingController();
  TextEditingController _deliveredpin = TextEditingController();
  TextEditingController _rejectpin = TextEditingController();
  TextEditingController _reject_reason = TextEditingController();

  Future productstats() async {
    setState(() {
      appstat = "loading...";
    });

    var productstatus = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorshipped.php'),
        body: {
          'productid': widget.tkid,
          'adminemail': widget.adminemail,
          'useremail': widget.useremail
        });

    setState(() {
      productPayment = jsonDecode(productstatus.body)[0]['productpayment'];
    });
    print("Product payment " + productPayment);

    if (productstatus.statusCode == 200) {
      print(jsonDecode(productstatus.body)[0]['ordershipped']);
      if (jsonDecode(productstatus.body)[0]['ordershipped'] == 'undone' &&
          jsonDecode(productstatus.body)[0]['orderarrived'] == 'undone') {
        setState(() {
          enableshipping = true;
          enabledelivery = false;
          loading = true;
          loadingdeli = false;
          appstat = "Vendorhive360";
          checker = true;
        });
      } else {
        setState(() {
          loading = false;
          enableshipping = false;
          enabledelivery = false;
          checker = true;
        });

        print(jsonDecode(productstatus.body)[0]['orderarrived']);
        if (jsonDecode(productstatus.body)[0]['orderarrived'] == 'undone' &&
            jsonDecode(productstatus.body)[0]['ordershipped'] == 'done') {
          setState(() {
            loading = true;
            enabledelivery = true;
            loadingdeli = false;
            appstat = "Vendorhive360";
            checker = true;
          });
        } else {
          setState(() {
            loading = true;
            enabledelivery = false;
            loadingdeli = true;
            appstat = "Vendorhive360";
            checker = true;
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
        Uri.https('vendorhive360.com', 'vendor/vendorupdateshipped.php'),
        body: {
          'productid': widget.productid,
          'adminemail': widget.adminemail,
          'useremail': widget.useremail,
          'tkid': widget.tkid
        });

    if (updateshiporder.statusCode == 200) {
      if (jsonDecode(updateshiporder.body) == 'true') {
        setState(() {
          _selectedpage = 0;
          loading = true;
          shipped = false;
          enableshipping = false;
          loading = true;
          enabledelivery = true;
          loadingdeli = false;
          ordershipped = "done";
        });

        print("Shipped order is registered");
      } else {
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
        Uri.https('vendorhive360.com', 'vendor/vendorupdatearrived.php'),
        body: {
          'productid': widget.productid,
          'useremail': widget.useremail,
          'adminemail': widget.adminemail,
          'tkid': widget.tkid
        });

    if (updatearrive.statusCode == 200) {
      if (jsonDecode(updatearrive.body) == 'true') {
        setState(() {
          _selectedpage = 0;
          delivered = false;
          enabledelivery = false;
          loadingdeli = true;
          loading = true;
          orderarrived = "done";
        });
        print("Product has arrived at destination");
      } else {
        setState(() {
          _selectedpage = 0;
        });
        print("Product has not arrived at destination");
      }
    } else {
      setState(() {
        _selectedpage = 0;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network Issues')));
    }
  }

  Future reject_order() async {
    print("Reject Order");

    setState(() {
      _selectedpage = 1;
    });

    var order_reject = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetidname.php'),
        body: {'useremail': widget.useremail});

    print(jsonDecode(order_reject.body));
    if (order_reject.statusCode == 200 &&
        jsonDecode(order_reject.body) != "false") {
      // a refund is to be done for product price
      var credit_custwallet_amount = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorcustupdatewallet.php'),
          body: {
            'idname': jsonDecode(order_reject.body).toString(),
            'email': widget.useremail,
            'debit': "0",
            'credit': widget.productprice,
            'desc': 'RVS Product amount',
            'refno': widget.tkid,
          });

      // a refund is to be done for product delivery price
      var credit_custwallet_delivery = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorcustupdatewallet.php'),
          body: {
            'idname': jsonDecode(order_reject.body).toString(),
            'email': widget.useremail,
            'debit': "0",
            'credit': widget.deliveryprice,
            'desc': 'RVS Delivery amount',
            'refno': widget.tkid,
          });

      //debit business wallet of amount
      var debit_amount = await http.post(
          Uri.https(
              'vendorhive360.com', 'vendor/vendorsaveinbusinesswallet.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.useremail,
            'adminemail': widget.adminemail,
            'debit': widget.productprice,
            'credit': '0',
            'status': 'pending',
            'refno': widget.tkid,
            'description': "Product Fee",
            'itemid': widget.productid
          });

      //debit business wallet of delivery fee
      var debit_delivery = await http.post(
          Uri.https(
              'vendorhive360.com', 'vendor/vendorsaveinbusinesswallet.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.useremail,
            'adminemail': widget.adminemail,
            'debit': widget.deliveryprice,
            'credit': '0',
            'status': 'pending',
            'refno': widget.tkid,
            'description': "Delivery Fee",
            'itemid': widget.productid
          });

      //a record of the rejection should be done
      var record_reject = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorreject.php'),
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
            'reason': _reject_reason.text
          });

      // //delete the product from orders
      // var delete_ordered = await http.post(
      //     Uri.https('vendorhive360.com', 'vendor/vendorrejectorder.php'),
      //     body: {
      //       'pidname': widget.productid,
      //       'tkid': widget.tkid,
      //       'useremail': widget.useremail,
      //       'adminemail': widget.adminemail,
      //     });

      //sets the product payment to reject in the vendororderstatus table
      var update_to_reject = await http.post(
          Uri.https('vendorhive360.com', 'vendor/accept_order.php'),
          body: {
            'tkid': widget.tkid,
            'customer_email': widget.useremail,
            'vendor_email': widget.adminemail,
            'status': 'reject',
            'pidname': widget.productid,
            'value': 'cancelled'
          });

      //notify user
      var notifyuser = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorsendnotification.php'),
          body: {
            'message': widget.productname + " has being rejected",
            'info': widget.useremail,
            'tag': 'Product Reject',
            'quantity': widget.quantity,
            'refno': widget.tkid
          });

      if (jsonDecode(update_to_reject.body) == "true" &&
          jsonDecode(credit_custwallet_delivery.body) == "true" &&
          jsonDecode(credit_custwallet_amount.body) == "true") {
        setState(() {
          productPayment = "reject";
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SuccessReject();
        }));

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Product is rejected")));
      } else {
        setState(() {
          _selectedpage = 0;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Request timed out")));
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

  //accept order
  Future<void> acceptOrder(String service_fee) async {
    //pop alert box
    Navigator.of(context).pop();

    //indicate loading
    setState(() {
      _selectedpage = 1;
    });

    try {
      //debit business wallet of service fee
      var savetransaction = await http.post(
          Uri.https(
              'vendorhive360.com', 'vendor/vendorsaveinbusinesswallet.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.useremail,
            'adminemail': widget.adminemail,
            'debit': service_fee,
            'credit': '0',
            'status': 'pending',
            'refno': widget.tkid,
            'description': "Service Fee",
            'itemid': widget.productid
          });

      //credit five percent table
      var vendor_five_percent = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorfivepercent.php'),
          body: {
            'idname': widget.idname,
            'email': widget.adminemail,
            'percent': service_fee,
            'refno': widget.tkid,
            'type': 'product'
          });

      //sets the product payment to done in the vendororderstatus table
      var response = await http.post(
          Uri.https('vendorhive360.com', 'vendor/accept_order.php'),
          body: {
            'tkid': widget.tkid,
            'customer_email': widget.useremail,
            'vendor_email': widget.adminemail,
            'status': 'done',
            'pidname': widget.productid,
            'value': 'active'
          });

      //notify user
      var notifyuser = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorsendnotification.php'),
          body: {
            'message': widget.productname + " offer is accepted",
            'info': widget.useremail,
            'tag': 'Product Accepted',
            'quantity': widget.quantity,
            'refno': widget.tkid
          });

      if (jsonDecode(response.body) == "true" &&
          jsonDecode(vendor_five_percent.body) == "true" &&
          jsonDecode(savetransaction.body) == "true") {
        //stop loading
        setState(() {
          productPayment = "done";
          _selectedpage = 0;
        });
      }
    } catch (e) {
      //request timed out
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Request Timed Out")));
      //stop loading
      setState(() {
        _selectedpage = 0;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productstats();
    ordershipped = widget.ordershipped;
    orderarrived = widget.orderarrived;
    dpreleased = widget.deliverypayment;
    ppreleased = widget.productpayment;
    showtracks = true;
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
    double total_amount_with_delivery = (double.parse(widget.productprice) +
        double.parse(widget.deliveryprice));
    double service_fee = total_amount_with_delivery * 0.05;
    double amount_after_deduct_serviceFee =
        total_amount_with_delivery - service_fee;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollDown,
        child: Icon(Icons.arrow_drop_down_circle_rounded),
      ),
      body: _selectedpage == 0
          ? Container(
              decoration: BoxDecoration(color: Colors.white),
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
                              child: Text(
                                "Order Status",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          ],
                        )),
                    Flexible(
                        child: ListView(
                      controller: _controller,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 252, 233, 1),
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              //Track order and id
                              Container(
                                padding: EdgeInsets.only(bottom: 20, top: 20),
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: .5, color: Colors.black))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        "Track Order",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              25,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          "ID: " + widget.trackid,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              35),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10)),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Order Processed",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            24),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 2),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Icon(
                                                      Icons.access_time,
                                                      size: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 2),
                                                    child: Text(
                                                      widget.date,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 2),
                                                    child: Text(
                                                      widget.timeordered,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    showtracks
                                        ? ordershipped == 'undone'
                                            ? Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                        : CircularProgressIndicator(
                                            color:
                                                Color.fromRGBO(246, 123, 55, 1),
                                            backgroundColor: Colors.white,
                                          ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Order Shipped",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            24),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 2),
                                              child: Row(
                                                children: [
                                                  ordershipped == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          child: Icon(
                                                            Icons.access_time,
                                                            size: 10,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                  ordershipped == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            widget.dateshipped,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                  ordershipped == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            widget.timeshipped,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    showtracks
                                        ? orderarrived == 'undone'
                                            ? Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                        : CircularProgressIndicator(
                                            color:
                                                Color.fromRGBO(246, 123, 55, 1),
                                            backgroundColor: Colors.white,
                                          ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Order Arrived",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          24,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 2),
                                              child: Row(
                                                children: [
                                                  orderarrived == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          child: Icon(
                                                            Icons.access_time,
                                                            size: 10,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                  orderarrived == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            widget.datearrived,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                  orderarrived == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            widget.timearrived,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    showtracks
                                        ? dpreleased == 'undone'
                                            ? Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                        : CircularProgressIndicator(
                                            color:
                                                Color.fromRGBO(246, 123, 55, 1),
                                            backgroundColor: Colors.white,
                                          ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "Product Payment Released",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          24,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 2),
                                              child: Row(
                                                children: [
                                                  dpreleased == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          child: Icon(
                                                            Icons.access_time,
                                                            size: 10,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                  dpreleased == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            widget
                                                                .datedprelease,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                  dpreleased == 'undone'
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2),
                                                          child: Text(
                                                            widget
                                                                .timedprelease,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    showtracks
                                        ? ppreleased == 'undone'
                                            ? Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        35),
                                                decoration: BoxDecoration(
                                                    color: ppreleased == "done"
                                                        ? Colors.green
                                                        : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10)),
                                                child: Icon(
                                                  ppreleased == "done"
                                                      ? Icons.check
                                                      : Icons.cancel,
                                                  color: Colors.white,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      16,
                                                ),
                                              )
                                        : CircularProgressIndicator(
                                            color:
                                                Color.fromRGBO(246, 123, 55, 1),
                                            backgroundColor: Colors.white,
                                          ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                ppreleased == "undone"?
                                                    "Awaiting vendor response"
                                                :ppreleased == "reject"
                                                    ? "Product is Rejected"
                                                    : "Product is Accepted",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          24,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 40,
                              ),
                            ],
                          ),
                        ),

                        //inform
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(
                              "Click Invoice to view more information on product",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewInvoice(
                                        productimage: widget.productimage,
                                        customername: widget.customername,
                                        customernumber: widget.customernumber,
                                        customerlocation:
                                            widget.customerlocation,
                                        customerstate: widget.customerstate,
                                        productprice: widget.productprice,
                                        quantity: widget.quantity,
                                        deliveryprice: widget.deliveryprice,
                                        deliveryplan: widget.deliveryplan,
                                        deliveryday: widget.deliveryday,
                                        trackid: widget.trackid,
                                        date: widget.date,
                                        time: widget.time)));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(246, 123, 55, 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "Invoice",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),

                        checker
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    child: Text(
                                      "Set order status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (productPayment == "done") ...[
                                    enableshipping
                                        ? GestureDetector(
                                            onTap: () {
                                              if (shipped == false) {
                                                var rng = Random();
                                                shippedpin = rng.nextInt(9999);
                                                setState(() {
                                                  shipped = true;
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _scrollDown();
                                                });
                                              } else if (shipped == true) {
                                                setState(() {
                                                  shipped = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 18),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      14, 44, 3, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Text(
                                                "Order is shipped",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17),
                                              )),
                                            ),
                                          )
                                        : Container(),
                                    shipped
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Center(
                                              child: Text(
                                                  "Shipped pin is ${shippedpin}"),
                                            ),
                                          )
                                        : Container(),
                                    shipped
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              controller: _shippedpin,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  hintText: 'Enter shipped pin',
                                                  enabledBorder:
                                                      OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder()),
                                            ),
                                          )
                                        : Container(),
                                    shipped
                                        ? GestureDetector(
                                            onTap: () {
                                              if (_shippedpin.text ==
                                                  shippedpin.toString()) {
                                                print("Correct pin");
                                                updateshippedorder();
                                              } else {
                                                print("wrong pin");
                                                ScaffoldMessenger.of(
                                                        this.context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text('wrong pin'),
                                                ));
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 18),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Text(
                                                "Click here to confirm shipment",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )),
                                            ),
                                          )
                                        : Container(),
                                    enabledelivery
                                        ? GestureDetector(
                                            onTap: () {
                                              if (delivered == false) {
                                                var rng = Random();
                                                deliveredpin =
                                                    rng.nextInt(9999);
                                                setState(() {
                                                  delivered = true;
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _scrollDown();
                                                });
                                              } else if (delivered == true) {
                                                setState(() {
                                                  delivered = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 18),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      14, 44, 3, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Text(
                                                "Order is delivered",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17),
                                              )),
                                            ),
                                          )
                                        : Container(),
                                    delivered
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Center(
                                              child: Text(
                                                  "Delivery pin is ${deliveredpin}"),
                                            ),
                                          )
                                        : Container(),
                                    delivered
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              controller: _deliveredpin,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'Enter delivery pin',
                                                  enabledBorder:
                                                      OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder()),
                                            ),
                                          )
                                        : Container(),
                                    delivered
                                        ? GestureDetector(
                                            onTap: () {
                                              if (_deliveredpin.text ==
                                                  deliveredpin.toString()) {
                                                print("Correct pin");
                                                updatearrivedorder();
                                              } else {
                                                print("wrong pin");
                                                ScaffoldMessenger.of(
                                                        this.context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text('wrong pin'),
                                                ));
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 18),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Text(
                                                "Click here to confirm delivery",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17),
                                              )),
                                            ),
                                          )
                                        : Container(),
                                    enabledelivery == false &&
                                            enableshipping == false
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "Order status is complete...",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 17),
                                            ),
                                          )
                                        : Container()
                                  ] else if (productPayment == 'reject') ...[
                                    Container(
                                      decoration:
                                          BoxDecoration(color: Colors.red[700]),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      margin: EdgeInsets.only(top: 25),
                                      child: Center(
                                          child: Text(
                                        widget.productname +
                                            " is Rejected by you",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ] else ...[
                                    GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (cxt) {
                                              return AlertDialog(
                                                title: Text("Accept Order"),
                                                content: Text(
                                                    "Are you sure you want to accept order"),
                                                actions: [
                                                  //cancel
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text("Cancel")),

                                                  //accept order button
                                                  TextButton(
                                                      onPressed: () =>
                                                          acceptOrder(
                                                              service_fee
                                                                  .toString()),
                                                      child: Text("Accept")),
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 10, 5),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 18),
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(246, 123, 55, 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                          "Accept Order",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                    reject
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Center(
                                              child: Text(
                                                  "Reject pin is ${rejectpin}"),
                                            ),
                                          )
                                        : Container(),
                                    reject
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              controller: _rejectpin,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  hintText: 'Enter reject pin',
                                                  enabledBorder:
                                                      OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder()),
                                            ),
                                          )
                                        : Container(),
                                    reject
                                        ? const SizedBox(
                                            height: 10,
                                          )
                                        : Container(),
                                    reject
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: TextField(
                                              controller: _reject_reason,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "Enter reason for rejecting",
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder()),
                                            ),
                                          )
                                        : Container(),
                                    reject
                                        ? const SizedBox(
                                            height: 10,
                                          )
                                        : Container(),
                                    reject
                                        ? GestureDetector(
                                            onTap: () {
                                              if (_rejectpin.text.isEmpty ||
                                                  _reject_reason.text.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Fill all rejection fileds")));
                                              } else {
                                                if (_rejectpin.text ==
                                                    rejectpin.toString()) {
                                                  print("Correct pin");
                                                  reject_order();
                                                } else {
                                                  print("wrong pin");
                                                  ScaffoldMessenger.of(
                                                          this.context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text('Wrong pin'),
                                                  ));
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 4, 10, 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 18),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Text(
                                                "Click here to reject",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          )
                                        : Container(),
                                    GestureDetector(
                                      onTap: () {
                                        if (reject == false) {
                                          var rng = Random();
                                          rejectpin = rng.nextInt(9999);
                                          setState(() {
                                            reject = true;
                                          });
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            _scrollDown();
                                          });
                                        } else if (reject == true) {
                                          setState(() {
                                            reject = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 10, 5),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 18),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.red[700],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                          "Reject Order",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ],
                                ],
                              )
                            : LinearProgressIndicator(),

                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Center(
                            child: Text(
                              appstat,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: SpinKitFadingCube(
                            color: Colors.orange,
                            size: 100,
                          ),
                        ),
                        Container(
                          child: Text(
                            "Processing",
                            style: TextStyle(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Center(
                            child: Text(
                              'Vendorhive360',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
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
