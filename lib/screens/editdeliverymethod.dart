import 'package:flutter/material.dart';

class EditDeliveryMethod extends StatefulWidget {
  String adminemail = "";
  String pidname = "";
  String deliveryplan = "";
  String amount = "";
  String days = "";
  String productname = "";

  EditDeliveryMethod(
      {required this.adminemail,
      required this.pidname,
      required this.deliveryplan,
      required this.amount,
      required this.productname,
      required this.days,
      Key? key})
      : super(key: key);

  @override
  _EditDeliveryMethodState createState() => _EditDeliveryMethodState();
}

class _EditDeliveryMethodState extends State<EditDeliveryMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, .5),
                ),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //setting text
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Text(
                          widget.productname+" Delivery Method",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
                    ),

                    //back button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(217, 217, 217, 1),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          )),
                    )
                  ],
                )),
            Text(widget.deliveryplan),
            Text(widget.amount),
            Text(widget.days)
          ],
        ),
      ),
    );
  }
}
