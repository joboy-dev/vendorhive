import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/deleteproduct.dart';

class MyProducts{
  String productname = "";
  String piname = "";
  String productprice = "";
  String productimg = "";
  MyProducts({required this.productname,
  required this.piname,
  required this.productprice,
  required this.productimg});
}

class VendorViewProducts extends StatefulWidget {
  String adminemail = "";
  String idname = "";
  VendorViewProducts({required this.adminemail,required this.idname});

  @override
  _VendorViewProductsState createState() => _VendorViewProductsState();
}

class _VendorViewProductsState extends State<VendorViewProducts> {
  int _selectedPage = 0;
  List rawproducts = [];
  List<MyProducts> myproductlist = [];
  bool myproducts = false;

  Future getproducts() async{

    var gettingproducts = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorgetproductsforadmin.php'),
        body: {
          'idname':widget.idname,
          'adminemail':widget.adminemail
        }
    );
    
    if(gettingproducts.statusCode == 200){

      print(jsonDecode(gettingproducts.body));

      rawproducts = jsonDecode(gettingproducts.body);

      print(rawproducts.length);

      setState(() {

        myproducts = true;

      });

    }
    else{

      print("gettingproducts issues ${gettingproducts.statusCode}");

    }
  }

  Future getproductsretry() async{

    try{

      setState(() {
        myproducts = false;
      });

      var gettingproducts = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorgetproductsforadmin.php'),
          body: {
            'idname':widget.idname,
            'adminemail':widget.adminemail
          }
      );

      if(gettingproducts.statusCode == 200){

        print(jsonDecode(gettingproducts.body));

        rawproducts = jsonDecode(gettingproducts.body);

        print(rawproducts.length);

        setState(() {

          myproducts = true;

        });

      }
      else{

        print("gettingproducts issues ${gettingproducts.statusCode}");

      }
    }
    catch(e){
      setState(() {
        _selectedPage = 1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getproducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SafeArea(
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
                        child: Text("My Product",style: TextStyle(
                            fontWeight: FontWeight.w500,
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
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.arrow_back,color: Colors.white,)
                          ),
                        ),
                      )
                    ],
                  )
              ),

              Flexible(
                  child:
                 _selectedPage == 0 ?
                 myproducts ?
                 rawproducts.length > 0 ?
                 RefreshIndicator(
                   onRefresh: getproducts,
                   child: ListView.builder(
                       padding: EdgeInsets.zero,
                       itemCount: rawproducts.length,
                       itemBuilder: (context,index){
                         return GestureDetector(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                               return DeleteProduct(
                                 productname: rawproducts[index]['productname'],
                                 pidname: rawproducts[index]['pidname'],
                                 email: widget.adminemail,
                                 productimg: rawproducts[index]['productimg'],
                                 productPrice: rawproducts[index]['productprice'],
                                 productdescription: rawproducts[index]['productdescription'],
                               );
                             }));
                           },
                           child: Container(
                             padding: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                             margin:EdgeInsets.only(left: 10,top: 10,right: 10),
                             decoration: BoxDecoration(
                                 color: Color.fromRGBO(229, 228, 226, 1)
                             ),
                             child: Row(
                               children: [
                                 Container(
                                   width: MediaQuery.of(context).size.width/8,
                                   child: FadeInImage(
                                     image: NetworkImage(
                                       "https://adeoropelumi.com/vendor/productimage/" +
                                           rawproducts[
                                           index]
                                           [
                                           'productimg'],
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
                                     fit:
                                     BoxFit.fitWidth,
                                   ),
                                 ),
                                 Expanded(
                                   child: Container(
                                     margin:EdgeInsets.only(left: 10,right: 10),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: [
                                         Container(
                                           child: Text(rawproducts[index]['productname'],
                                             textAlign: TextAlign.end,
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
                                           child: Text("₦"+rawproducts[index]['productprice'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                             textAlign: TextAlign.end,
                                             style: TextStyle(
                                               fontSize: MediaQuery.of(context).size.width/26
                                             ),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           ),
                         );
                       }),
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
                               child: Text("you haven't registerd any products",style: TextStyle(
                                   fontSize: MediaQuery.of(context).size.width/30,
                                   fontStyle: FontStyle.italic,
                                   fontFamily: 'Raleway',
                                   fontWeight: FontWeight.bold
                               ),textAlign: TextAlign.center,),
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
                      :
                 Container(
                    child: Center(
                      child: Column(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              getproductsretry();
                            },
                            child: Container(
                              child: Image.asset("assets/internet.png",
                                width: MediaQuery.of(context).size.width/3,),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              getproductsretry();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text("Click icon to retry",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/30,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
