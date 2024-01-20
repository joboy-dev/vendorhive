import 'package:flutter/material.dart';

class ViewInvoice extends StatefulWidget {
  final String productimage;
  final String customername;
  final String customernumber;
  final String customerlocation;
  final String customerstate;
  final String productprice;
  final String quantity;
  final String deliveryprice;
  final String deliveryplan;
  final String deliveryday;
  final String trackid;
  final String date;
  final String time;

  ViewInvoice(
      {Key? key,
      required this.productimage,
      required this.customername,
      required this.customernumber,
      required this.customerlocation,
      required this.customerstate,
      required this.productprice,
      required this.quantity,
      required this.deliveryprice,
      required this.deliveryplan,
      required this.deliveryday,
      required this.trackid,
      required this.date,
      required this.time})
      : super(key: key);

  @override
  _ViewInvoiceState createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends State<ViewInvoice> {
  @override
  Widget build(BuildContext context) {
    double total_amount_with_delivery = (double.parse(widget.productprice) +
        double.parse(widget.deliveryprice));
    double service_fee = total_amount_with_delivery * 0.05;
    double amount_after_deduct_serviceFee =
        total_amount_with_delivery - service_fee;

    return Scaffold(
      backgroundColor: Colors.white,
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
                        "Invoice",
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
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),

                //Image
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Center(
                      child: FadeInImage(
                    image: NetworkImage(
                      "https://vendorhive360.com/vendor/productimage/" +
                          widget.productimage,
                    ),
                    placeholder: AssetImage("assets/image.png"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/error.png',
                          fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitWidth,
                  )),
                ),

                const SizedBox(
                  height: 25,
                ),

                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Customer Name: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.customername,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Customer Phonenumber: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.customernumber,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Customer Address: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.customerlocation,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Customer State: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.customerstate,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Total Amount: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "₦" +
                                widget.productprice.replaceAllMapped(
                                    RegExp(
                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},'),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Quantity: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.quantity,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
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
                        child: Text(
                          "Delivery Price: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "₦" +
                                widget.deliveryprice.replaceAllMapped(
                                    RegExp(
                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},'),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
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
                        child: Text(
                          "Delivery Plan: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.deliveryplan,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Days of delivery: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.deliveryday,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Product Id: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.trackid,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Date & Time: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.date + " & " + widget.time,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Service Fee: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '₦' +
                                '${service_fee}'.replaceAllMapped(
                                    RegExp(
                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},'),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Total  Payout: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '₦' +
                                '${amount_after_deduct_serviceFee}'
                                    .replaceAllMapped(
                                    RegExp(
                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},'),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  child: Center(
                    child: Text(
                      "Vendorhive360",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
