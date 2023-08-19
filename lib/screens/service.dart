import 'package:vendorandroid/screens/orderstatus.dart';
import 'package:flutter/material.dart';

class Service extends StatefulWidget {
  const Service({Key? key}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  String options = "Pay after service";
  bool value = false;
  bool value1 = false;
  bool value2 = false;
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
                      "Add Service",
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10),
                      child: Text("Name"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: .5,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5,
                                color: Colors.grey
                              )
                          )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                      child: Text("Description"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                      child: Text("Price"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5,
                                  color: Colors.grey
                              )
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                      child: Text("Attach"),
                    ),
                    Container(
                      height: 100,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 110,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                            ),
                            child: Icon(Icons.add,size: 50, color: Color.fromRGBO(128, 128, 128, 1),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 110,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                            ),
                            child: Icon(Icons.add,size: 50, color: Color.fromRGBO(128, 128, 128, 1),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 110,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                            ),
                            child: Icon(Icons.add,size: 50, color: Color.fromRGBO(128, 128, 128, 1),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 110,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                            ),
                            child: Icon(Icons.add,size: 50, color: Color.fromRGBO(128, 128, 128, 1),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                      child: Text("Payment Options"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,),
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
                                    child: Text("Pay after service",style: TextStyle(
                                        fontSize: 17
                                    ),),
                                    value: "Pay after service",
                                  ),
                                  DropdownMenuItem(
                                      child: Text("Contact to negotiate",style: TextStyle(
                                          fontSize: 17
                                      ),),
                                      value: "Contact to negotiate"
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
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10,bottom: 5),
                      child: Text("Tags"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(229, 228, 226, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      margin: EdgeInsets.only(left: 10,top: 5,right: 10),
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Wrap(
                            children:[
                              Row(
                                children: [
                                  Text(
                                    "Website Development",
                                    style: TextStyle(
                                      fontSize: 13,

                                    ),
                                  ),
                                  //Text
                                  Checkbox(
                                    value: this.value,
                                    onChanged: (value) {
                                      setState(() {
                                        this.value = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Landing Page",
                                    style: TextStyle(
                                        fontSize: 13
                                    ),
                                  ),
                                  //Text
                                  Checkbox(
                                    value: this.value1,
                                    onChanged: (value) {
                                      setState(() {
                                        this.value1 = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return OrderStatus();
                        }));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text("Create Service",style: TextStyle(
                            color: Colors.white,
                            fontSize: 17
                        ),)),
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
