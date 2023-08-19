import 'dart:convert';
import 'dart:math';

import 'package:vendorandroid/screens/cart.dart';
import 'package:vendorandroid/screens/ratings.dart';
import 'package:vendorandroid/screens/searchgridview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vendorandroid/screens/welcome.dart';

class ViewProduct extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String packagename = "";
  String usertype = "";
  String name = "";
  String amount = "";
  String imagename = "";
  String description = "";
  String prodid = "";
  String adminemail = "";
  double deliveryprice = 0;
  String location = "";
  String custwalletbalance = "";

  ViewProduct({required this.name, required this.amount, required this.imagename,
  required this.description, required this.idname, required this.useremail,
  required this.packagename, required this.usertype, required this.prodid,
  required this.adminemail,required this.deliveryprice,required this.location,
    required this.custwalletbalance});

  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  bool showlist = false;
  bool showrating = false;
  double finalratings = 0.0;

  List rawservice = [];
  List<String> productsimg = [];

  Future productimages() async{

    setState(() {
      showlist = false;
    });

    var productimg = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorproductimagelist.php'),
        body: {
          'pidname':widget.prodid
        }
    );

    if(productimg.statusCode == 200){

      print(jsonDecode(productimg.body));
      rawservice = jsonDecode(productimg.body);

      for(int o=0; o<rawservice.length; o++){
        setState(() {
          productsimg.add(jsonDecode(productimg.body)[o]['productimage']);
        });
      }
    }
    else{

      print("Product image issues ${productimg.statusCode}");

    }

    setState(() {
      showlist = true;
    });

  }

  Future loadratings() async{

    setState(() {

      showrating = false;

    });

    var viewrattings = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorviewrattings.php'),
        body: {
          'pidname':widget.prodid
        }
    );

    if(viewrattings.statusCode == 200){
      print(jsonDecode(viewrattings.body));

      if(jsonDecode(viewrattings.body)==0){

        setState(() {
          finalratings = 0;
        });

      }
      else{

        setState(() {
          finalratings = double.parse(jsonDecode(viewrattings.body));
        });

      }

      print(jsonDecode(viewrattings.body));
      print(finalratings);

      setState(() {
        showrating = true;
      });

    }
    else{

      print("View rattings issues ${viewrattings.statusCode}");

    }
  }

  @override
  initState(){
    super.initState();

    productimages();
    loadratings();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [

            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15)
              ),
              margin: EdgeInsets.only(left: 20,right: 20,top: 20),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height/2)-70,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 30),
                        width: MediaQuery.of(context).size.width/1.4,
                        child: FadeInImage(
                          image: NetworkImage("https://adeoropelumi.com/vendor/productimage/"+widget.imagename),
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
                        // child: Image.network("https://adeoropelumi.com/vendor/productimage/"+widget.imagename,)
                    ),
                    for(int o=0; o < rawservice.length; o++)
                      if(widget.imagename == productsimg[o] )...[

                      ]else...[
                        Container(
                          margin: EdgeInsets.only(left: 30),
                            width: MediaQuery.of(context).size.width/1.4,
                            child: FadeInImage(
                              image: NetworkImage("https://adeoropelumi.com/vendor/productimage/"+productsimg[o]),
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
                            // child: Image.network("https://adeoropelumi.com/vendor/productimage/"+productsimg[o],)
                        ),
                      ]
                  ],
                ),
              ),
            ),
            Container(
              child: Center(
                child: showlist?
                Text("swipe left",style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic
                ),)
                    :
                Icon(Icons.more_horiz),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(widget.name,
                              style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/16,
                              fontWeight: FontWeight.w500
                            ),),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text("₦"+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                              style: TextStyle(
                              fontWeight: FontWeight.w500,
                                fontSize: MediaQuery.of(context).size.width/18,
                            ),),
                          )
                        ],
                      ),
                    ),
                  ),

                  showrating ?
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: RatingBarIndicator(
                          rating: finalratings,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ),
                    ),
                  )
                      :
                  Container(
                    child: Icon(Icons.more_horiz),
                  )

                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 30),
              child: Text(widget.description,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/26
              ),),
            ),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {

                        var rng = Random();
                        int id = rng.nextInt(2000000000);
                        print(id);

                        for(int o = 0; o < cartitems.length; o++){
                          print(cartitems[o].id);
                          while(id == cartitems[o].id){
                            id = rng.nextInt(2000000000);
                            print("another id $id");
                          }
                        }

                        print(id);
                        print(widget.name);
                        print(widget.amount);
                        print(widget.imagename);
                        print(widget.prodid);
                        print(widget.deliveryprice);
                        print(widget.location);

                        cartitems.add(Cart(id: id,name: widget.name,
                        quantity: 1,amount: double.parse(widget.amount.replaceAll(',', '')),
                            imagename: widget.imagename,
                        prodid: widget.prodid,
                        adminemail: widget.adminemail,
                          deliveryprice: widget.deliveryprice,
                          location: widget.location
                        ));

                        print("Item added cart");

                      });

                      ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text('Item added to cart'),
                          ));

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text("Add to cart",style: TextStyle(
                          color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width/22
                        ),),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Welcome(idname: widget.idname,useremail: widget.useremail,packagename: widget.packagename,
                          usertype: widget.usertype,pagenumber: 2,
                            custwalletbalance: widget.custwalletbalance,);
                        }));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                            child: Text("Go to cart",style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width/22
                            ),),
                        ),
                      ),
                    ))
              ],
            ),

            GestureDetector(
              onTap: (){
                if(showrating){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Ratings(pidname: widget.prodid,finalratings: finalratings,);
                  }));
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ratings is loading'))
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246,234,190, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                padding: EdgeInsets.only(top: 13,bottom: 13),
                child: Center(
                    child: showrating ?
                    Text("Ratings and Reviews",style: TextStyle(
                        color: Colors.black54,
                        fontSize: MediaQuery.of(context).size.width/22
                    ),)
                        :
                    Icon(Icons.more_horiz)
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(14, 44, 3, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                padding: EdgeInsets.only(top: 13,bottom: 13),
                child: Center(
                    child: Text("Go Back",style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/22
                    ),)
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
