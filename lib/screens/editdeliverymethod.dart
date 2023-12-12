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

  TextEditingController amount = TextEditingController();
  TextEditingController days = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
              const SizedBox(height: 10,),
              Container(
                child: Center(
                  child: Text("Edit Details for "+widget.deliveryplan,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.orange[700]
                    ),),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Old Amount:",style: TextStyle(
                        fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("₦"+widget.amount.replaceAllMapped(
                        RegExp(
                            r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},'),style: TextStyle(
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
              const SizedBox(height: 2,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: amount,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter new Amount",
                    hintStyle: TextStyle(
                      color: Colors.grey[200]
                    ),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Old Delivery Days:",style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(widget.days+" days",style: TextStyle(
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
              const SizedBox(height: 2,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: days,

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter new days",
                    hintStyle: TextStyle(
                        color: Colors.grey[200]
                    ),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  if(amount.text.isEmpty || days.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fill all fields"))
                    );
                  }else{

                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text("Edit "+widget.deliveryplan,style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text("Vendorhive360",style: TextStyle(
                  fontSize: 12
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
