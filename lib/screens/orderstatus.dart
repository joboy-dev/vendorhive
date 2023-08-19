import 'package:flutter/material.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  String options = "Order shipped";

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
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        )
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
                      margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                      padding: EdgeInsets.only(bottom: 10),
                      decoration:BoxDecoration(
                        color: Color.fromRGBO(229, 228, 226, 1),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: .5
                                )
                              )
                            ),
                            margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                            padding: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text("Order Tracking"),
                                ),
                                Container(
                                  child: Text("ID: #12345",style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 20,left: 20),
                                  child: CircleAvatar(
                                    backgroundColor: Color.fromRGBO(246, 123, 55, 1),
                                    radius: 20,
                                    child: Icon(Icons.check,color: Colors.white,),
                                  ),
                                ),
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Order Processed "),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Icon(Icons.access_time,size: 10,),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("9:40 AM; 10 March 2023",style: TextStyle(
                                                fontSize: 10
                                              ),),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: CircleAvatar(
                                    backgroundColor: Color.fromRGBO(246, 123, 55, 1),
                                    radius: 20,
                                    child: Icon(Icons.check,color: Colors.white,),
                                  ),
                                ),
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Order shipped "),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Icon(Icons.access_time,size: 10,),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("9:40 AM; 10 March 2023",style: TextStyle(
                                                  fontSize: 10
                                              ),),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: CircleAvatar(
                                    backgroundColor: Color.fromRGBO(246, 123, 55, 1),
                                    radius: 20,
                                    child: Icon(Icons.check,color: Colors.white,),
                                  ),
                                ),
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Order arrived "),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Icon(Icons.access_time,size: 10,),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("9:30 AM; 18 March 2023",style: TextStyle(
                                                  fontSize: 10
                                              ),),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 20,
                                    child: Icon(Icons.check,color: Colors.white,),
                                  ),
                                ),
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Delivery Payment Released"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Icon(Icons.access_time,size: 10,),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("9:30 AM; 20 March 2023",style: TextStyle(
                                                  fontSize: 10
                                              ),),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 20,
                                    child: Icon(Icons.check,color: Colors.white,),
                                  ),
                                ),
                                Container(
                                  margin:EdgeInsets.only(top: 10,left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Product Payment Released"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Icon(Icons.access_time,size: 10,),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("9:30 AM; 20 March 2023",style: TextStyle(
                                                  fontSize: 10
                                              ),),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30,left: 20),
                      child: Text("Set order status",style: TextStyle(
                        fontSize: 16
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color:Colors.grey, //background color of dropdown button
                            border: Border.all(color: Colors.grey, width:1), //border of dropdown button
                            borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                            // boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                            //   BoxShadow(
                            //       // color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                            //       // blurRadius: 5
                            //   ) //blur radius of shadow
                            // ]
                          ),

                          child:Padding(
                              padding: EdgeInsets.only(left:20, right:20),
                              child:DropdownButton(
                                value: options,
                                items: [ //add items in the dropdown

                                  DropdownMenuItem(
                                    child: Text("Order shipped",style: TextStyle(
                                        fontSize: 17
                                    ),),
                                    value: "Order shipped",
                                  ),

                                  DropdownMenuItem(
                                      child: Text("Order arrived",style: TextStyle(
                                          fontSize: 17
                                      ),),
                                      value: "Order arrived"
                                  ),

                                ],
                                onChanged: (value){ //get value when changed
                                  setState(() {
                                    options = value!;
                                  });
                                  print("You have selected $value");
                                },
                                icon: Padding( //Icon at tail, arrow bottom is default icon
                                    padding: EdgeInsets.only(left:20),
                                    child:Icon(Icons.arrow_drop_down)
                                ),
                                iconEnabledColor: Colors.white, //Icon color
                                style: TextStyle(  //te
                                    color: Colors.white, //Font color
                                    fontSize: 20 //font size on dropdown button
                                ),

                                dropdownColor: Colors.grey, //dropdown background color
                                underline: Container(), //remove underline
                                isExpanded: true, //make true to make width 100%
                              )
                          )
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
