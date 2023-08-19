import 'package:flutter/material.dart';

class SetDelivery extends StatefulWidget {
  const SetDelivery({Key? key}) : super(key: key);

  @override
  _SetDeliveryState createState() => _SetDeliveryState();
}

class _SetDeliveryState extends State<SetDelivery> {
  String drop = "Within Lagos";
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
                      "Set Delivery Price",
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
                      margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                      child: Text("Location"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 5),
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
                                value: drop,
                                items: [ //add items in the dropdown
                                  DropdownMenuItem(
                                    child: Text("Within Lagos",style: TextStyle(
                                        fontSize: 17
                                    ),),
                                    value: "Within Lagos",
                                  ),
                                  DropdownMenuItem(
                                      child: Text("Oyo State",style: TextStyle(
                                          fontSize: 17
                                      ),),
                                      value: "Oyo State"
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Ogun State",style: TextStyle(
                                        fontSize: 17
                                    ),),
                                    value: "Ogun State",
                                  )

                                ],
                                onChanged: (value){ //get value when changed
                                  setState(() {
                                    drop = value!;
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
                    Container(
                      margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                      child: Text("Price"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .5
                            )
                          )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                      child: Text("Estimated Delivery Time"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: TextField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: .5
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: .5
                                )
                            )
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(14, 44, 3, 1)
                ),
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(14, 44, 3, 1)
              ),
              padding: EdgeInsets.only(top: 15,bottom: 15),
              child: Center(child: Text("ADD LOCATION",style: TextStyle(
                color: Colors.white
              ),)),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(246, 123, 55, 1)
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(246, 123, 55, 1)
              ),
              padding: EdgeInsets.only(top: 15,bottom: 15),
              child: Center(child: Text("UPDATE PRICE",style: TextStyle(
                  color: Colors.white
              ),)),
            )
          ],
        ),
      ),
    );
  }
}
