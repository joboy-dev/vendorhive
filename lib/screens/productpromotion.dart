import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/setproductpromotion.dart';

class Productpromotion extends StatefulWidget {
  String idname = "";
  String adminemail = "";
  Productpromotion({required this.idname,
  required this.adminemail});

  @override
  _ProductpromotionState createState() => _ProductpromotionState();
}

class _ProductpromotionState extends State<Productpromotion> {

  int _selectedpage = 0 ;
  bool myproducts = false;
  bool productlist = false;

  List rawproducts = [];

  Future getproducts() async{

    try{
      var gettingproducts = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorgetproductsforadmin.php'),
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

        print("Network Issues ${gettingproducts.statusCode}");

      }
    }
    catch(e){

      print("error is "+e.toString());

      setState(() {
        _selectedpage = 1;
      });

    }
  }

  Future getproductsretry() async{

    setState(() {
      _selectedpage = 0;
      myproducts = false;
    });

    try{

      var gettingproducts = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorgetproductsforadmin.php'),
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

        print("Network Issues ${gettingproducts.statusCode}");

        setState(() {
          _selectedpage = 1;
        });

      }
    }
    catch(e){

      print("error is "+e.toString());

      setState(() {
        _selectedpage = 1;
      });

    }
  }

  @override
  initState(){
    super.initState();

    getproducts();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //app bar to promote product
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
                    child: Text("Product",style: TextStyle(
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
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.arrow_back,color: Colors.white,)
                      ),
                    ),
                  )

                ],
              ),
            ),
            //page explanation text
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Center(child: Text('Select a product to promote',textAlign: TextAlign.center,)),
            ),

            Flexible(
              child:
              _selectedpage == 0 ?
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
                          print(index);
                          print(rawproducts[index]['pidname']);
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SetPromotion(pidname: rawproducts[index]['pidname'],
                              prodname: rawproducts[index]['productname'],
                              prodimg: rawproducts[index]['productimg'],
                              adminemail: widget.adminemail,
                              idname: widget.idname,);
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
                                  image: NetworkImage("https://vendorhive360.com/vendor/productimage/"+rawproducts[index]['productimg']),
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
                                // child: Image.network("https://vendorhive360.com/vendor/productimage/"+rawproducts[index]['productimg']),
                              ),
                              Expanded(
                                child: Container(
                                  margin:EdgeInsets.only(left: 10,right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: Text(rawproducts[index]['productname'],
                                          textAlign: TextAlign.end,style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/24,
                                              fontWeight: FontWeight.w500
                                          ),),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Text("₦"+rawproducts[index]['productprice'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          textAlign: TextAlign.end,style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width/27,
                                          ),),
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
                        child: Text("no products",style: TextStyle(
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
                      // Image.asset("assets/loading.png",
                      //   width: MediaQuery.of(context).size.width/3,),
                      CircularProgressIndicator(
                        color: Colors.orange,
                        backgroundColor: Colors.green,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("loading.....",style: TextStyle(
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
    );
  }
}
