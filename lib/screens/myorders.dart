import 'dart:convert';

import 'package:vendorandroid/screens/viewadminorder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MyOrders extends StatefulWidget {
  String idname = "";
  String useremail = "";

  MyOrders({required this.idname, required this.useremail});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List raworders = [];

  bool showorder = false;

  Future myorders() async {

    setState(() {
      showorder = false;
    });

    try{

      final getorders = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendoradminorders.php'),
          body: {'idname': widget.idname, 'useremail': widget.useremail});

      if (getorders.statusCode == 200) {

        raworders = jsonDecode(getorders.body);

        print(jsonDecode(getorders.body));

        setState(() {

          showorder = true;

        });

      }
      else{

        print("Admin order ${getorders.statusCode}");

      }
    }
    catch(e){

      setState(() {

        showorder = true;

      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request time out'),)
      );
    }
  }

  Future refresh() async {

    try{

      final getorders = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendoradminorders.php'),
          body: {'idname': widget.idname, 'useremail': widget.useremail});

      if (getorders.statusCode == 200) {

        raworders = jsonDecode(getorders.body);

        print(jsonDecode(getorders.body));

        setState(() {

          showorder = true;

        });

      }
      else{

        print("Admin order ${getorders.statusCode}");

      }
    }
    catch(e){

      setState(() {

        showorder = true;

      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request time out'),)
      );
    }
  }

  @override
  initState() {
    super.initState();
    myorders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //products order for vendor app barr
            Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, .5),
                ),
                padding: EdgeInsets.only(top: 15, bottom: 15,left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(left: 10),
                      child: Text("Products Ordered",style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
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
                )
            ),
            //list of customers orders
            Flexible(
                child: showorder ?
                raworders.length > 0 ?
                RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                      itemCount: raworders.length,
                      padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return Viewadminorder(
                                  idname: widget.idname,
                                  productname: raworders[index]['productname'],
                                productimage: raworders[index]['prodimagename'],
                                productid: raworders[index]['productid'],
                                productprice: raworders[index]['amount'],
                                location: raworders[index]['customerlocation'],
                                deliveryprice: raworders[index]['deliveryprice'],
                                adminemail: raworders[index]['adminemail'],
                                useremail: raworders[index]['useremail'],
                                tkid: raworders[index]['tkid'],
                                customername: raworders[index]['customername'],
                                customerlocation: raworders[index]['customerlocation'],
                                customernumber: raworders[index]['customernumber'],
                                customerstate: raworders[index]['customerstate'],
                                quantity: raworders[index]['quantity'],
                                trackid: raworders[index]['trackid'],
                                date: raworders[index]['date'],
                                time: raworders[index]['time'],
                                deliveryplan: raworders[index]['deliveryplan'],
                                deliveryday: raworders[index]['deliveryday'],
                                datearrived: raworders[index]['datearrived'],
                                datedprelease: raworders[index]['datedpreleased'],
                                dateshipped: raworders[index]['dateshipped'],
                                timearrived: raworders[index]['timearrived'],
                                timedprelease: raworders[index]['timedpreleased'],
                                timeordered: raworders[index]['timeordered'],
                                timeshipped: raworders[index]['timeshipped'],
                                deliverypayment: raworders[index]['deliverypayment'],
                                orderarrived: raworders[index]['orderarrived'],
                                ordershipped: raworders[index]['ordershipped'],
                                productpayment: raworders[index]['productpayment'],);
                              }));
                            },
                            child: Container(
                                padding: EdgeInsets.only(bottom: 15, top: 10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(width: .5, color: Colors.grey))),
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(192, 192, 192, 1),
                                          borderRadius: BorderRadius.circular(5)),
                                      width: MediaQuery.of(context).size.width/8,
                                      child: FadeInImage(
                                        image: NetworkImage(
                                          "https://vendorhive360.com/vendor/productimage/" +
                                              raworders[index]['prodimagename'],
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
                                      ),
                                    ),

                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                raworders[index]['productname'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: MediaQuery.of(context).size.width/23
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              child: Text(raworders[index]['quantity']+" items",style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
                                                  fontSize: MediaQuery.of(context).size.width/30
                                              ),),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              child: Text(
                                                raworders[index]['date'] +
                                                    "  " +
                                                    raworders[index]['timeordered'],
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width/33,
                                                  color:
                                                      Color.fromRGBO(192, 192, 192, 1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10, left: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Text(
                                                "₦" +
                                                    raworders[index]['amount']
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                            (Match m) => '${m[1]},'),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: MediaQuery.of(context).size.width/24
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: raworders[index]['status'] ==
                                                      'active'
                                                      ? Color.fromRGBO(255, 250, 160, 1)
                                                      : raworders[index]['status'] ==
                                                      'complete'
                                                      ? Colors.greenAccent
                                                      : Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(3)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: Text(
                                                raworders[index]['status'] == 'active'
                                                    ? "Payment is pending"
                                                    : raworders[index]['status'] ==
                                                    'complete'
                                                    ? "Payment is completed"
                                                    : "Payment is cancelled",
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/34,
                                                    color: raworders[index]['status']==
                                                        'active'
                                                        ? Color.fromRGBO(244, 187, 68, 1)
                                                        : raworders[index]['status'] ==
                                                        'complete'
                                                        ? Colors.green
                                                        : Colors.white,
                                                    fontWeight: FontWeight.w500),textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: raworders[index]['productpayment'] ==
                                                      'undone'
                                                      ? Color.fromRGBO(255, 250, 160, 1)
                                                      : raworders[index]['productpayment'] ==
                                                      'done'
                                                      ? Colors.greenAccent
                                                      : Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(3)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: Text(
                                                raworders[index]['productpayment'] == 'undone'
                                                    ? "Awaiting vendor response"
                                                    : raworders[index]['productpayment'] ==
                                                    'done'
                                                    ? "Order is Accepted"
                                                    : "Order is Rejected",
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/34,
                                                    color: raworders[index]['productpayment']==
                                                        'undone'
                                                        ? Color.fromRGBO(244, 187, 68, 1)
                                                        : raworders[index]['productpayment'] ==
                                                        'done'
                                                        ? Colors.green
                                                        : Colors.white,
                                                    fontWeight: FontWeight.w500),textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )

                                  ],
                                )),
                          );
                        }
                      ),
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
                          child: Text("no order",style: TextStyle(
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
                            CircularProgressIndicator(
                              color: Colors.orange,
                              backgroundColor: Colors.green,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text("loading...",style: TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }
}
