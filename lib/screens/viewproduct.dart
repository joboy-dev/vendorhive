import 'dart:convert';
import 'dart:math';

import 'package:vendorandroid/screens/cart.dart';
import 'package:vendorandroid/screens/ratings.dart';
import 'package:vendorandroid/screens/searchgridview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vendorandroid/screens/welcome.dart';

import 'checkout.dart';

class ViewProduct extends StatefulWidget {
  String idname = "";
  String username = "";
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

  ViewProduct(
      {required this.name,
      required this.username,
      required this.amount,
      required this.imagename,
      required this.description,
      required this.idname,
      required this.useremail,
      required this.packagename,
      required this.usertype,
      required this.prodid,
      required this.adminemail,
      required this.deliveryprice,
      required this.location,
      required this.custwalletbalance});

  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  bool showlist = false;
  bool showrating = false;
  double finalratings = 0.0;
  String drop = "";
  String deliveryprice = "";
  String deliverydays = "";
  String deliveryplan = "";
  int quantity = 1;

  List rawservice = [];
  List<String> productsimg = [];

  List<DropdownMenuItem<String>> dropdownItems = [];
  List items = [];

  Future get_delivery_method() async {
    print("============");
    print(widget.prodid);
    print("============");

    var response = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorgetdeliveryplan.php'),
        body: {
          'pidname': widget.prodid,
        });

    print("============");
    print(response.statusCode);
    print("============");

    if (response.statusCode == 200) {
      print("============");
      print(jsonDecode(response.body));
      print("============");

      setState(() {
        items = jsonDecode(response.body);
        drop = items[0]['price'] +
            "===" +
            items[0]['days'] +
            "===" +
            items[0]['plan'];
        deliveryprice = items[0]['price'];
        deliverydays = items[0]['days'];
        deliveryplan = items[0]['plan'];
      });

      dropdownItems = List.generate(
        items.length,
        (index) => DropdownMenuItem(
          value: items[index]['price'] +
              "===" +
              items[index]['days'] +
              "===" +
              items[index]['plan'],
          child: Text(
            items[index]['plan'],
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    }
  }

  Future productimages() async {
    setState(() {
      showlist = false;
    });

    var productimg = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorproductimagelist.php'),
        body: {'pidname': widget.prodid});

    if (productimg.statusCode == 200) {
      print(jsonDecode(productimg.body));
      rawservice = jsonDecode(productimg.body);

      for (int o = 0; o < rawservice.length; o++) {
        setState(() {
          productsimg.add(jsonDecode(productimg.body)[o]['productimage']);
        });
      }
    } else {
      print("Product image issues ${productimg.statusCode}");
    }

    setState(() {
      showlist = true;
    });
  }

  Future loadratings() async {
    setState(() {
      showrating = false;
    });

    var viewrattings = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorviewrattings.php'),
        body: {'pidname': widget.prodid});

    if (viewrattings.statusCode == 200) {
      print(jsonDecode(viewrattings.body));

      if (jsonDecode(viewrattings.body) == 0) {
        setState(() {
          finalratings = 0;
        });
      } else {
        setState(() {
          finalratings = double.parse(jsonDecode(viewrattings.body));
        });
      }

      print(jsonDecode(viewrattings.body));
      print(finalratings);

      setState(() {
        showrating = true;
      });
    } else {
      print("View rattings issues ${viewrattings.statusCode}");
    }
  }

  void selectDeliverymethod() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        builder: (cxt) {
          return StatefulBuilder(builder: (contx, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Center(
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    Center(
                      child: Text(
                        "Set Quantity",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(Icons.add_circle)),
                        Text('$quantity'),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                quantity--;
                                if (quantity < 1) {
                                  quantity = 1;
                                }
                              });
                            },
                            icon: Icon(Icons.remove_circle)),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Center(
                        child: Text(
                          "Select a Delivery Method",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            //background color of dropdown button
                            border: Border.all(color: Colors.grey, width: 1),
                            //border of dropdown button
                            borderRadius: BorderRadius.circular(
                                10), //border raiuds of dropdown button
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton<String>(
                                items: dropdownItems,
                                value: drop,
                                onChanged: (value) {
                                  setState(() {
                                    drop = value!;
                                    print("======");
                                    print("You have selected $value");
                                    print("======");
                                    final names = drop;
                                    final splitNames = names.split('===');

                                    for (int i = 0;
                                        i < splitNames.length;
                                        i++) {
                                      print(splitNames[i]);
                                      deliveryprice = splitNames[0];
                                      deliverydays = splitNames[1];
                                      deliveryplan = splitNames[2];
                                    }

                                    print("====================");
                                    print(widget.prodid);
                                    print("Delivery plan = " + deliveryplan);
                                    print("Delivery price = " + deliveryprice);
                                    print("Delivery Days = " + deliverydays);
                                    print("====================");
                                  });
                                },
                                icon: Padding(
                                    //Icon at tail, arrow bottom is default icon
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.arrow_drop_down)),
                                iconEnabledColor: Colors.white,
                                //Icon color
                                style: TextStyle(
                                    //te
                                    color: Colors.white, //Font color
                                    fontSize: 20 //font size on dropdown button
                                    ),

                                dropdownColor: Colors.grey,
                                //dropdown background color
                                underline: Container(),
                                //remove underline
                                isExpanded: true, //make true to make width 100%
                              ))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivery Price :- ₦" + deliveryprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Delivery Days :- " + deliverydays + " days",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        addCartItem();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(246, 123, 55, 1)),
                        child: Center(
                          child: Text(
                            "Proceed",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2000,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  addCartItem() {
    cartitems.clear();
    print("Cart Item Lenght " + cartitems.length.toString());

    setState(() {
      var rng = Random();
      int id = rng.nextInt(2000000000);
      print(id);

      for (int o = 0; o < cartitems.length; o++) {
        print(cartitems[o].id);
        while (id == cartitems[o].id) {
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

      cartitems.add(Cart(
          id: id,
          name: widget.name,
          quantity: quantity,
          amount: double.parse(widget.amount.replaceAll(',', '')),
          imagename: widget.imagename,
          prodid: widget.prodid,
          adminemail: widget.adminemail,
          deliveryprice: double.parse(deliveryprice),
          location: widget.location,
          deliveryplan: deliveryplan,
          deliverydays: deliverydays));
    });

    print("Cart Item Lenght " + cartitems.length.toString());

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thank you for picking " + widget.name)));

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Checkout(
        totalamount: (double.parse(widget.amount.replaceAll(',', '')) * quantity),
        totalamountplusdelivery:
            (double.parse(widget.amount.replaceAll(',', '')) * quantity) +
                double.parse(deliveryprice),
        service_fee: 0.0,
        useremail: widget.useremail,
        idname: widget.idname,
        username: widget.username,
      );
    }));
  }

  @override
  initState() {
    super.initState();
    get_delivery_method();
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
                  color: Colors.grey, borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height / 2) - 70,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: FadeInImage(
                        image: NetworkImage(
                            "https://adeoropelumi.com/vendor/productimage/" +
                                widget.imagename),
                        placeholder: AssetImage("assets/image.png"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/error.png',
                              fit: BoxFit.fitWidth);
                        },
                        fit: BoxFit.fitWidth,
                      ),
                      // child: Image.network("https://adeoropelumi.com/vendor/productimage/"+widget.imagename,)
                    ),
                    for (int o = 0; o < rawservice.length; o++)
                      if (widget.imagename == productsimg[o])
                        ...[]
                      else ...[
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: FadeInImage(
                            image: NetworkImage(
                                "https://adeoropelumi.com/vendor/productimage/" +
                                    productsimg[o]),
                            placeholder: AssetImage("assets/image.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/error.png',
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
                child: showlist
                    ? Text(
                        "swipe left",
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      )
                    : Icon(Icons.more_horiz),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                widget.name,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                "₦" +
                                    widget.amount.replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    showrating
                        ? Expanded(
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
                        : Container(
                            child: Icon(Icons.more_horiz),
                          )
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Text(
                widget.description,
                style:
                    TextStyle(fontSize: MediaQuery.of(context).size.width / 26),
              ),
            ),
            //purchase
            GestureDetector(
              onTap: () {
                if (items.length > 0) {
                  selectDeliverymethod();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Processing, please try again")));
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 123, 55, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    "Purchase",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width / 22),
                  ),
                ),
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: () {
            //           if(items.length > 0){
            //             selectDeliverymethod();
            //           }
            //           else{
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(content: Text("Processing, please try again"))
            //             );
            //           }
            //         },
            //         child: Container(
            //           margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            //           padding: EdgeInsets.symmetric(vertical: 15),
            //           decoration: BoxDecoration(
            //               color: Color.fromRGBO(246, 123, 55, 1),
            //               borderRadius: BorderRadius.circular(15)),
            //           child: Center(
            //             child: Text(
            //               "purchase",
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: MediaQuery.of(context).size.width / 22),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //         child: GestureDetector(
            //       onTap: () {
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context) {
            //           return Welcome(
            //             idname: widget.idname,
            //             username: widget.username,
            //             useremail: widget.useremail,
            //             packagename: widget.packagename,
            //             usertype: widget.usertype,
            //             pagenumber: 2,
            //             custwalletbalance: widget.custwalletbalance,
            //           );
            //         }));
            //       },
            //       child: Container(
            //         margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            //         padding: EdgeInsets.symmetric(vertical: 15),
            //         decoration: BoxDecoration(
            //             color: Color.fromRGBO(246, 123, 55, 1),
            //             borderRadius: BorderRadius.circular(15)),
            //         child: Center(
            //           child: Text(
            //             "Go to cart",
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: MediaQuery.of(context).size.width / 22),
            //           ),
            //         ),
            //       ),
            //     ))
            //   ],
            // ),
            GestureDetector(
              onTap: () {
                if (showrating) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Ratings(
                      pidname: widget.prodid,
                      finalratings: finalratings,
                    );
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ratings is loading')));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 234, 190, 1),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                padding: EdgeInsets.only(top: 13, bottom: 13),
                child: Center(
                    child: showrating
                        ? Text(
                            "Ratings and Reviews",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize:
                                    MediaQuery.of(context).size.width / 22),
                          )
                        : Icon(Icons.more_horiz)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(14, 44, 3, 1),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                padding: EdgeInsets.only(top: 13, bottom: 13),
                child: Center(
                    child: Text(
                  "Go Back",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 22),
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
