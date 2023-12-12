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
  String username = "";
  VendorViewProducts({required this.adminemail,required this.idname,required this.username});

  @override
  _VendorViewProductsState createState() => _VendorViewProductsState();
}

class _VendorViewProductsState extends State<VendorViewProducts> {
  int _selectedPage = 0;
  List rawproducts = [];
  List<MyProducts> myproductlist = [];
  List getallresults = [];
  bool myproducts = false;
  bool getlogo = false;

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

  Future vendorgetdescriptionsummary() async{
    final gettinglogo = await http.post(Uri.https('adeoropelumi.com', 'vendor/vendorgetlogo.php'),
        body: {
          'useremail' : widget.adminemail
        });
    if(gettinglogo.statusCode == 200){
      setState(() {
        getallresults = jsonDecode(gettinglogo.body);
        getlogo = true;
      });
      print(jsonDecode(gettinglogo.body));
      print(getallresults[0]["logoname"]);
    }else{
      print("Error Getting Image");
      setState(() {
        getlogo = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getproducts();
    vendorgetdescriptionsummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header and back button
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

            //picture + business name + call + menu button
            Container(
                margin:EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.lime[100],
                      radius: 20,
                      child: getlogo ?
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FadeInImage(
                          image: NetworkImage(
                            "https://www.adeoropelumi.com/vendor/blogo/"+getallresults[0]["logoname"],
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
                          fit: BoxFit.fitWidth,
                        ),
                      ):
                      CircularProgressIndicator(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.username,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),),
                              Text(getlogo? widget.username+" shop in "+getallresults[0]["state"]:"loading...",
                                style: TextStyle(
                                  fontSize: 9,
                                ),)
                            ],
                          )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.lime[100],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Icon(Icons.phone,size: 15,color: Colors.black,),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.lime[100],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Icon(Icons.more_horiz,size: 15,color: Colors.black,),
                    )
                  ],
                )
            ),

            //Brief Explanation
            Container(
              margin:EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Text(getlogo?getallresults[0]["description"]:"loading...",
                style: TextStyle(
                    fontSize: 9
                ),maxLines: 6,overflow: TextOverflow.ellipsis,),
            ),

            const SizedBox(
              height: 10,
            ),

            //send message button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 123, 55, 1),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Center(
                child: Text("Send Message",style: TextStyle(
                    color: Colors.white
                ),),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // My Products text
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text("My Products",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),),
            ),

            //products
            Flexible(
              child:
              _selectedPage == 0 ?
              myproducts ?
              rawproducts.length > 0 ?
              RefreshIndicator(
                onRefresh: getproducts,
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rawproducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .7
                    ),
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return DeleteProduct(
                              idname: widget.idname,
                              productname: rawproducts[index]['productname'],
                              pidname: rawproducts[index]['pidname'],
                              payment_option: rawproducts[index]['paymentoption'],
                              email: widget.adminemail,
                              productimg: rawproducts[index]['productimg'],
                              productPrice: rawproducts[index]['productprice'],
                              productdescription: rawproducts[index]['productdescription'],
                            );
                          }));
                        },
                        child: Container(
                          // padding: EdgeInsets.only(top: 10,bottom: 10),
                          margin:EdgeInsets.only(left: 10,right: 10,top: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
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
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(rawproducts[index]['productname'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      child: Text("₦"+rawproducts[index]['productprice'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                        style: TextStyle(
                                            fontSize: 14
                                        ),textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
    );
  }
}
