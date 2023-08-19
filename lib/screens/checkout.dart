import 'package:vendorandroid/screens/checkoutsecond.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  double totalamount  = 0;
  double totalamountplusdelivery = 0;
  String idname = "";
  String useremail = "";
  Checkout({required this.totalamount, required this.totalamountplusdelivery,
  required this.idname,required this.useremail});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String options = "Lagos";

  TextEditingController _fname = new TextEditingController();
  TextEditingController _phonenumber = new TextEditingController();
  TextEditingController _street = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.totalamount);
    print(widget.totalamountplusdelivery);
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
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
                                  color: Colors.black,
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
                  margin: EdgeInsets.only(left: 10,top: 10),
                  child: Text("Enter your shiping address",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: Text("Lorem ipsum dolor sit amet consectetur. Id duis libero pulvinar lacus consectetur pharetra sem. Scelerisque maecenas velit dignissim suspendisse. ",
                  style: TextStyle(
                    fontSize: 14
                  ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Text("Enter Full Name",style: TextStyle(
                    fontSize: 14
                  ),)
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: TextField(
                    controller: _fname,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: .5
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: .5
                          ),
                          borderRadius: BorderRadius.circular(10)
                      )
                    )
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                    child: Text("Phone number",style: TextStyle(
                        fontSize: 14
                    ),)
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: TextField(
                    controller: _phonenumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5
                              ),
                              borderRadius: BorderRadius.circular(10)
                          )
                      )
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                    child: Text("Street Address",style: TextStyle(
                        fontSize: 14
                    ),)
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: TextField(
                    controller: _street,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: .5
                              ),
                              borderRadius: BorderRadius.circular(10)
                          )
                      )
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10,top: 10,),
                    child: Text("State",style: TextStyle(
                        fontSize: 14
                    ),)
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:Colors.grey, //background color of dropdown button
                        border: Border.all(color: Colors.grey, width:1), //border of dropdown button
                        borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                      ),

                      child:Padding(
                          padding: EdgeInsets.only(left:20, right:20),
                          child:DropdownButton(
                            value: options,
                            items: [ //add items in the dropdown

                              DropdownMenuItem(
                                child: Text("Lagos",style: TextStyle(
                                    fontSize: 17
                                ),),
                                value: "Lagos",
                              ),

                              DropdownMenuItem(
                                  child: Text("Osun",style: TextStyle(
                                      fontSize: 17
                                  ),),
                                  value: "Osun"
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
                GestureDetector(
                  onTap:(){
                    if(_fname.text.isEmpty || _phonenumber.text.isEmpty||_street.text.isEmpty){
                      ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text('Fill all fields'),
                          ));
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CheckoutSecond(totalamount: widget.totalamount,totalamountplusdelivery: widget.totalamountplusdelivery,
                          fullname: _fname.text,phonenumber: _phonenumber.text,streetaddress: _street.text,
                          state: options,idname: widget.idname,useremail: widget.useremail,);
                      }));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10,left: 10,right: 10,top: 20),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text("Next",style: TextStyle(
                          color: Colors.white,
                        fontSize: 16
                      ),),
                    ),
                  ),
                )
              ],
            )
            )
          ],
        ),
      ),
    );
  }
}
