import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/adddeliverymethod.dart';
import 'package:vendorandroid/screens/editdeliverymethod.dart';
import 'package:vendorandroid/screens/successdeleteproduct.dart';

import 'faileddelete.dart';

class DeleteProduct extends StatefulWidget {
  String pidname = "";
  String email = "";
  String productimg = "";
  String productPrice = "";
  String productdescription = "";
  String productname = "";
  String payment_option = "";
  String idname = "";

  DeleteProduct(
      {required this.pidname,
      required this.email,
      required this.idname,
      required this.productimg,
      required this.productPrice,
      required this.productdescription,
      required this.productname,
      required this.payment_option,
      Key? key})
      : super(key: key);

  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  int _loadIndex = 0;
  int _selectedItem = 0;
  String priceStatus = "";
  String descriptionStatus = "";
  String product_payment_option = "-";
  String paymentOptionStatus = "";
  List getting_delivery_plan = [];
  bool set_delivery = false;

  TextEditingController _newPrice = new TextEditingController();
  TextEditingController _newDescription = new TextEditingController();

  Future delete_product() async {

    setState(() {
      _loadIndex = 1;
    });

    var response = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/delete_product.php'),
        body: {'pidname': widget.pidname});

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "true") {
        setState(() {
          _loadIndex = 0;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SuccessDeleteProduct();
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FailedDelete();
        }));
      }
    }
  }

  Future update_product_price() async {
    setState(() {
      _loadIndex = 1;
    });
    var response = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorupdateproductprice.php'),
        body: {'pidname': widget.pidname, 'newprice': _newPrice.text});
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "true") {
        setState(() {
          _loadIndex = 0;
          _newPrice.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "New Price is Set",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )));
        setState(() {
          priceStatus = "New Price is Set";
        });
      } else {
        setState(() {
          _loadIndex = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.grey[100],
            content: Text(
              "Failed!!",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red[600]),
            )));
        setState(() {
          priceStatus = "Failed!!";
        });
      }
    }
  }

  Future update_product_description() async {
    setState(() {
      _loadIndex = 1;
    });
    try {
      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorupdatedescription.php'),
          body: {
            'pidname': widget.pidname,
            'newdescription': replacing(_newDescription.text)
          });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == "true") {
          setState(() {
            _loadIndex = 0;
            _newDescription.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "New Description is Set",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )));
          setState(() {
            descriptionStatus = "New Description is Set";
          });
        } else {
          setState(() {
            _loadIndex = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.grey[100],
              content: Text(
                "Failed!!",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red[600]),
              )));
          setState(() {
            descriptionStatus = "Failed!!";
          });
        }
      }
    } catch (e) {
      print("Error is " + e.toString());
    }
  }

  Future update_product_payment_option() async {
    setState(() {
      _loadIndex = 1;
    });
    try {
      var response = await http.post(
          Uri.https('adeoropelumi.com',
              'vendor/vendorproductupdatepaymentoption.php'),
          body: {
            'pidname': widget.pidname,
            'paymentoption': product_payment_option
          });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == "true") {
          setState(() {
            _loadIndex = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "New Payment Option is Set",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )));
          setState(() {
            paymentOptionStatus = "New Payment Option is Set";
          });
        } else {
          setState(() {
            _loadIndex = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.grey[100],
              content: Text(
                "Failed!!",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red[600]),
              )));
          setState(() {
            paymentOptionStatus = "Failed!!";
          });
        }
      }
    } catch (e) {
      print("Error is " + e.toString());
    }
  }

  Future get_deliveryplan() async {
    setState(() {
      set_delivery = false;
    });
    final response = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorgetdeliveryplan.php'),
        body: {'pidname': widget.pidname});
    if (response.statusCode == 200) {
      getting_delivery_plan = jsonDecode(response.body);
      print(jsonDecode(response.body));
      setState(() {
        set_delivery = true;
      });
    } else {
      print("Network Error");
    }
  }

  //modify sent message
  String replacing(String word) {
    word = word.replaceAll("'", "{(L!I_0)}");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  String modify(String word) {
    word = word.replaceAll("{(L!I_0)}", "'");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  @override
  void initState() {
    print(widget.pidname);
    super.initState();
    get_deliveryplan();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _loadIndex == 0
          ? GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //setting app bar
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
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  widget.productname + " Settings",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ),

                            //back button
                            GestureDetector(
                              onTap: () {
                                if (_selectedItem == 1) {
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                } else if (_selectedItem == 2) {
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                } else if (_selectedItem == 3) {
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                } else if (_selectedItem == 4) {
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                } else if (_selectedItem == 5) {
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                } else {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                }
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

                    if (_selectedItem == 0) ...[
                      //Edit price
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = 2;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: .5))),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset("assets/price_tag.png",
                                    color: Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Edit Price",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Edit Description
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = 3;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: .5))),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset("assets/edit.png",
                                    color: Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Edit Description",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Edit Payment Option
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       _selectedItem = 4;
                      //     });
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.only(bottom: 10, top: 10),
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide(
                      //                 color: Colors.grey, width: .5))),
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           width: MediaQuery.of(context).size.width / 8,
                      //           margin: EdgeInsets.only(left: 10),
                      //           child: Image.asset("assets/mobile-payment.png",
                      //               color: Color.fromRGBO(246, 123, 55, 1)),
                      //         ),
                      //         Container(
                      //           margin: EdgeInsets.only(left: 15),
                      //           child: Text(
                      //             "Edit Payment Option",
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: 16),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //Edit Delivery Method
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = 5;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: .5))),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset("assets/bus.png",
                                    color: Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Edit Delivery Method",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Delete Product
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: .5))),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset("assets/bin.png",
                                    color: Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Delete Product",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ] else if (_selectedItem == 1) ...[
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          margin:
                              EdgeInsets.only(bottom: 40, left: 20, right: 20),
                          child: Text(
                            "Do you want to delete this product?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                delete_product();
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 40),
                          height: MediaQuery.of(context).size.width / 2,
                          width: MediaQuery.of(context).size.width / 2,
                          child: FadeInImage(
                            image: NetworkImage(
                              "https://adeoropelumi.com/vendor/productimage/" +
                                  widget.productimg,
                            ),
                            placeholder: AssetImage("assets/image.png"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/error.png',
                                  fit: BoxFit.fitWidth);
                            },
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            "Vendorhive360",
                            style: TextStyle(
                                color: Colors.orange[900],
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ] else if (_selectedItem == 2) ...[
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Old Price:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "₦" +
                                      widget.productPrice.replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (Match m) => '${m[1]},'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          )),
                      Container(
                          padding:
                              EdgeInsets.only(left: 10, top: 10, right: 10),
                          child: Row(
                            children: [
                              Text(
                                "New Price:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: _newPrice,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "Set New Price...",
                                    contentPadding: EdgeInsets.only(left: 10),
                                    enabledBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder()),
                              )),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_newPrice.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Ensure to enter an amount",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )));
                          } else {
                            update_product_price();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(246, 123, 55, 1)),
                          child: Center(
                            child: Text(
                              "Set Price",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          priceStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ] else if (_selectedItem == 3) ...[
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Text(
                          "Old Description:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 1, right: 10),
                        child: Text(
                          modify(widget.productdescription),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Text(
                          "New Description:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 1, right: 10),
                        child: TextField(
                          controller: _newDescription,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Set New Description...",
                              contentPadding: EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_newDescription.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Ensure to enter a new description!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )));
                          } else {
                            update_product_description();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(246, 123, 55, 1)),
                          child: Center(
                            child: Text(
                              "Set Description",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          descriptionStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ] else if (_selectedItem == 4) ...[
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Text(
                          "Old Payment Option:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 1, right: 10),
                        child: Text(
                          modify(widget.payment_option),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Text(
                          "Select new payment option:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              //background color of dropdown button
                              border: Border.all(color: Colors.grey, width: 1),
                              //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  10), //border raiuds of dropdown button
                              // boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                              //   BoxShadow(
                              //       // color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                              //       // blurRadius: 5
                              //   ) //blur radius of shadow
                              // ]
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: DropdownButton(
                                  value: product_payment_option,
                                  items: [
                                    //add items in the dropdown
                                    //default state
                                    DropdownMenuItem(
                                      child: Text(
                                        "-",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      value: "-",
                                    ),
                                    DropdownMenuItem(
                                      child: Text(
                                        "Pay on Delivery",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      value: "Pay on Delivery",
                                    ),
                                    //2nd state Adamawa
                                    DropdownMenuItem(
                                      child: Text(
                                        "Pay Online",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      value: "Pay Online",
                                    ),
                                  ],
                                  onChanged: (value) {
                                    //get value when changed
                                    setState(() {
                                      product_payment_option = value!;
                                    });
                                    print("You have selected $value");
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
                                      fontSize:
                                          20 //font size on dropdown button
                                      ),

                                  dropdownColor: Colors.grey,
                                  //dropdown background color
                                  underline: Container(),
                                  //remove underline
                                  isExpanded:
                                      true, //make true to make width 100%
                                ))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (product_payment_option == "-") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Select a new payment option!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )));
                          } else {
                            update_product_payment_option();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(246, 123, 55, 1)),
                          child: Center(
                            child: Text(
                              "Set Payment Option",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          paymentOptionStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ] else if (_selectedItem == 5) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Click on the Delivery Plan to Edit",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddDeliveryMethod(
                                    idname: widget.idname,
                                    pidname: widget.pidname,
                                    adminemail: widget.email,
                                    productname: widget.productname,
                                  );
                                }));
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      set_delivery
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5),
                                itemCount: getting_delivery_plan.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return EditDeliveryMethod(
                                            adminemail: widget.email,
                                            pidname: widget.pidname,
                                            productname: widget.productname,
                                            deliveryplan:
                                                getting_delivery_plan[index]
                                                    ["3"],
                                            amount: getting_delivery_plan[index]
                                                ["4"],
                                            days: getting_delivery_plan[index]
                                                ["5"]);
                                      }));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.orange[100]),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "Delivery Plan:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      getting_delivery_plan[
                                                          index]["3"],
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "Amount:",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      "₦" +
                                                          getting_delivery_plan[
                                                                  index]["4"]
                                                              .replaceAllMapped(
                                                                  RegExp(
                                                                      r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                  (Match m) =>
                                                                      '${m[1]},'),
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "Days of Delivery:",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      getting_delivery_plan[
                                                          index]["5"],
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: SpinKitFadingCube(
                            color: Colors.orange,
                            size: 100,
                          ),
                        ),
                        Container(
                          child: Text(
                            "processing",
                            style: TextStyle(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Center(
                            child: Text(
                              'Vendorhive360',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    ));
  }
}
