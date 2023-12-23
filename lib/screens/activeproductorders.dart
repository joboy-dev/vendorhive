import 'dart:convert';
import 'package:vendorandroid/screens/listing.dart';
import 'package:vendorandroid/screens/trackorder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ActiveProductOrders extends StatefulWidget {
  String useremail = "";
  String idname = "";
  String custname = "";

  ActiveProductOrders({required this.useremail,required this.idname,required this.custname});

  @override
  _ActiveProductOrdersState createState() => _ActiveProductOrdersState();
}

class _ActiveProductOrdersState extends State<ActiveProductOrders> {
  bool showorders = false;
  List raworders = [];

  Future myorders() async{

    setState(() {
      showorders = false;
    });

      final myorders = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorgetactiveorders.php'),
          body: {
            'useremail':widget.useremail,
            'idname':widget.idname
          }
      );

      if(myorders.statusCode == 200){

        setState(() {
          raworders = jsonDecode(myorders.body);
        });

        print(raworders.length);
        print(jsonDecode(myorders.body));

        setState(() {
          showorders = true;
        });

      }
      else{

        print("Network issue");

      }
  }

  Future refresh() async{

    final myorders = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorgetactiveorders.php'),
        body: {
          'useremail':widget.useremail,
          'idname':widget.idname
        }
    );

    if(myorders.statusCode == 200){

      setState(() {
        raworders = jsonDecode(myorders.body);
      });

      print(raworders.length);
      print(jsonDecode(myorders.body));

      setState(() {
        showorders = true;
      });

    }
    else{

      print("Network issue");

    }
  }

  @override
  initState(){
    super.initState();
    myorders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //my order
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
                    child: Text("My Orders",style: TextStyle(
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
                          child: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
                        )
                    ),
                  )
                ],
              ),
            ),

            showorders
               ?
           Flexible(
                child:
                raworders.length> 0 ?
                RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: raworders.length,
                      itemBuilder: (context,index){
                        return   GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return TrackOrder(idname: raworders[index]['idname'],
                              useremail: raworders[index]['useremail'],
                              productid: raworders[index]['productid'],
                              amount: raworders[index]['amount'],
                              trackid: raworders[index]['trackid'],
                              date: raworders[index]['date'],
                              adminemail: raworders[index]['adminemail'],
                              orderprocessed: raworders[index]['orderprocessed'],
                              orderarrived: raworders[index]['orderarrived'],
                              ordershipped: raworders[index]['ordershipped'],
                              deliverypayment: raworders[index]['deliverypayment'],
                              productpayment: raworders[index]['productpayment'],
                              timeshipped: raworders[index]['timeshipped'],
                              timearrived: raworders[index]['timearrived'],
                              timedprelease: raworders[index]['timedpreleased'],
                              timepprelease: raworders[index]['timeppreleased'],
                              timeordered: raworders[index]['timeordered'],
                              datearrived: raworders[index]['datearrived'],
                              dateshipped: raworders[index]['dateshipped'],
                              datedprelease: raworders[index]['datedpreleased'],
                              datepprelease: raworders[index]['dateppreleased'],
                              productimage: raworders[index]['prodimagename'],
                              productname: raworders[index]['productname'],
                              deliveryprice: raworders[index]['deliveryprice'],
                              tkid: raworders[index]['tkid'],
                              quantity: raworders[index]['quantity'],
                              username: widget.custname,);
                            }));
                          },
                          child:
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
                            child:
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10,),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(192, 192, 192, 1),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  width: MediaQuery.of(context).size.width/8,
                                  child: FadeInImage(
                                    image: NetworkImage("https://adeoropelumi.com/vendor/productimage/"+
                                        raworders[index]['prodimagename']),
                                    placeholder: AssetImage(
                                        "assets/image.png"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/error.png',
                                          fit: BoxFit.fitWidth);
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
                                          child: Text(raworders[index]['productname'],style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context).size.width/23
                                          ),),
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
                                          height: 10,
                                        ),
                                        Container(
                                          child: Text(raworders[index]['date']+"  "+raworders[index]['timeordered'],
                                            style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width/35,
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
                                        child: Text("₦"+raworders[index]['amount'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context).size.width/24
                                        ),),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: raworders[index]['status'] == 'active' ?
                                            Color.fromRGBO(255, 250, 160, 1)
                                            :
                                            raworders[index]['status'] == 'complete' ?
                                            Colors.greenAccent
                                            :
                                            Colors.redAccent,
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        child: Text(raworders[index]['status'] == 'active' ?
                                          "pending"
                                          :
                                        raworders[index]['status'] == 'complete' ?
                                        "completed"
                                          :
                                          "cancelled",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width/36,
                                            color: raworders[index]['status'] == 'active' ?
                                            Color.fromRGBO(244, 187, 68, 1)
                                                :
                                            raworders[index]['status'] == 'complete' ?
                                            Colors.green
                                            :
                                            Colors.red,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          )
                        );
                      },
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
                          child: Text("no orders",style: TextStyle(
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
            )

            :

           Flexible(
             child: Container(
               child: Center(
                 child: Column(
                   children: [
                     Spacer(),
                     // Image.asset("assets/loading.png",
                     //   width: MediaQuery.of(context).size.width/3,),
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
             ),
           ),

          ],
        ),
      ),
    );
  }
}
