import 'package:flutter/material.dart';

class ProductOrders extends StatefulWidget {
  const ProductOrders({Key? key}) : super(key: key);

  @override
  _ProductOrdersState createState() => _ProductOrdersState();
}

class _ProductOrdersState extends State<ProductOrders> {
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
                      "My Orders",
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
                child:ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 15,top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          )
                      ),
                      margin: EdgeInsets.only(top: 10,),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(192, 192, 192, 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            margin: EdgeInsets.only(left: 10),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Logo Design",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("N30,000",style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(146, 200, 133, .4),
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text("Completed",style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15,top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          )
                      ),
                      margin: EdgeInsets.only(top: 10,),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(192, 192, 192, 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Logo Design",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("N30,000",style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(196, 30, 58, .4),
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text("Cancelled",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(196, 30, 58, 1),
                                      fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15,top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          )
                      ),
                      margin: EdgeInsets.only(top: 10,),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(192, 192, 192, 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Logo Design",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("N30,000",style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(146, 200, 133, .4),
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text("Completed",style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15,top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          )
                      ),
                      margin: EdgeInsets.only(top: 10,),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(192, 192, 192, 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Logo Design",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("N30,000",style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(253, 218, 13, .2),
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text("Pending",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(253, 218, 13, 1),
                                      fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15,top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          )
                      ),
                      margin: EdgeInsets.only(top: 10,),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(192, 192, 192, 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Logo Design",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("N30,000",style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(146, 200, 133, .4),
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text("Completed",style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15,top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          )
                      ),
                      margin: EdgeInsets.only(top: 10,),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(192, 192, 192, 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Logo Design",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("N30,000",style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(146, 200, 133, .4),
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text("Completed",style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15,top: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          )
                      ),
                      margin: EdgeInsets.only(top: 10,),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(192, 192, 192, 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Logo Design",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text("21 Feb 2022  12:01 PM",style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("N30,000",style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(146, 200, 133, .4),
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text("Completed",style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500
                                  ),),
                                )
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
