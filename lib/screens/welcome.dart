import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/components/profiles.dart';
import 'package:vendorandroid/screens/activeproductorders.dart';
import 'package:vendorandroid/screens/bankaccdetails.dart';
import 'package:vendorandroid/screens/checkout.dart';
import 'package:vendorandroid/screens/contactsupport.dart';
import 'package:vendorandroid/screens/custtransaction.dart';
import 'package:vendorandroid/screens/editprofile.dart';
import 'package:vendorandroid/screens/forgotpin.dart';
import 'package:vendorandroid/screens/listing.dart';
import 'package:vendorandroid/screens/myorders.dart';
import 'package:vendorandroid/screens/custsetpin.dart';
import 'package:vendorandroid/screens/notification.dart';
import 'package:vendorandroid/screens/packages.dart';
import 'package:vendorandroid/screens/paidservices.dart';
import 'package:vendorandroid/screens/payforservice.dart';
import 'package:vendorandroid/screens/refer.dart';
import 'package:vendorandroid/screens/servicemsg.dart';
import 'package:vendorandroid/screens/settings.dart';
import 'package:vendorandroid/screens/topup.dart';
import 'package:vendorandroid/screens/vendor_profile.dart';
import 'package:vendorandroid/screens/viewproduct.dart';
import 'package:vendorandroid/screens/viewservice.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:vendorandroid/screens/cart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class Lilo {
  String name = "";
  String amount = "";

  Lilo({required this.name, required this.amount});
}

class Products {
  String idname = "";
  String pidname = "";
  String useremail = "";
  String productname = "";
  String productdesc = "";
  String productprice = "";
  String paymentoption = "";
  String productimage = "";
  String productdeliveryprice = '';
  String location = '';

  Products(
      {required this.idname,
      required this.pidname,
      required this.useremail,
      required this.productname,
      required this.productdesc,
      required this.productprice,
      required this.paymentoption,
      required this.productimage,
      required this.productdeliveryprice,
      required this.location});
}

class Service {
  String idname = "";
  String sidname = "";
  String useremail = "";
  String servicename = "";
  String servicedesc = "";
  String serviceprice = "";
  String paymentoption = "";
  String serviceimage = "";

  Service(
      {required this.idname,
      required this.sidname,
      required this.useremail,
      required this.servicename,
      required this.servicedesc,
      required this.serviceprice,
      required this.paymentoption,
      required this.serviceimage});
}

class Welcome extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String packagename = "";
  String usertype = "";
  String username ="";
  int pagenumber = 0;
  String custwalletbalance = "";

  Welcome(
      {required this.idname,
        required this.username,
      required this.useremail,
      required this.packagename,
      required this.usertype,
      required this.pagenumber,
      required this.custwalletbalance});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String walletbal = "";
  int lilo = 0;
  int _selectedIndex = 0;
  double totalsum = 0;
  double totalsumplusdelivery = 0;
  double deliverysum = 0;
  bool showproducts = false;
  bool showservice = false;
  bool searchproducts = false;
  bool searchservices = false;
  int itemselected = 1;
  bool showcontactlist = false;
  String finalbalance = "0";
  String pendingbalance = "0";
  bool searchbar = false;
  bool pricesort = false;
  bool value = false;
  TextEditingController _Controller = new TextEditingController();
  TextEditingController _serviceController = new TextEditingController();

  List<String> lastmsg = [];
  List<String> servicenamelist = [];
  List<String> adminemaillist = [];
  List<String> chatcontactlist = [];
  List<String> appcontactlist = [];

  Future chatcontact() async {
    setState(() {
      showcontactlist = false;
    });

    print('chat contacts');
    final chatcontact = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorchatcontactscustomer.php'),
        body: {
          'useremail': widget.useremail,
        });

    if (chatcontact.statusCode == 200) {
      chatcontactlist.clear();
      appcontactlist.clear();
      lastmsg.clear();
      adminemaillist.clear();
      servicenamelist.clear();
      unreadmsgscust.clear();

      print(jsonDecode(chatcontact.body));
      jsonDecode(chatcontact.body)
          .forEach((s) => chatcontactlist.add(s['bstatus']));

      print(chatcontactlist.length);

      appcontactlist = chatcontactlist.toSet().toList();
      print("Filtered list ${appcontactlist.length}");

      for (int o = 0; o < chatcontactlist.length; o++) {
        print(chatcontactlist[o]);
      }

      int move = 0;

      for (int o = 0; o < appcontactlist.length; o++) {
        var adminemail = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorgetadminemailcust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        var servicename = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorservicenamecust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        final getlastmsg = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorgetlastmsgcust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        final unread = await http.post(
            Uri.https(
                'adeoropelumi.com', 'vendor/vendorgetnumberofunreadcust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        print(jsonDecode(unread.body));

        if (unread.statusCode == 200) {
          print(appcontactlist[o]);
          print(jsonDecode(servicename.body));
          print(jsonDecode(adminemail.body));
          print(jsonDecode(getlastmsg.body));
          print(jsonDecode(unread.body));
          adminemaillist.add(jsonDecode(adminemail.body));
          servicenamelist.add(jsonDecode(servicename.body));
          lastmsg.add(jsonDecode(getlastmsg.body));
          unreadmsgscust.add(jsonDecode(unread.body).toString());
          move++;
          print(move);
        }
      }

      if (move == appcontactlist.length) {
        setState(() {
          showcontactlist = true;
        });
      }
    }
  }

  Future viewproduct() async {
    setState(() {
      showproducts = false;
    });

    print("Print Products");

    var autopromote = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorviewproduct.php'),
            body: {'users': widget.useremail});

        if (views.statusCode == 200) {
          setState(() {
            rawproduct = jsonDecode(views.body);
          });

          print(rawproduct.length);
          print(jsonDecode(views.body));

          if (rawproduct.length > 0) {
            setState(() {
              showproducts = true;
              searchproducts = true;
            });
          } else {
            setState(() {
              showproducts = true;
              searchproducts = false;
            });
          }
        } else {
          print("Network issues ${views.statusCode}");
        }
      } else if (jsonDecode(autopromote.body) == 'false') {
        print('api error');
      } else if (jsonDecode(autopromote.body) == 'error') {
        print('app error');
      } else {
        print('app error');
      }
    } else {
      print('Network Issues ${autopromote.statusCode}');
    }
  }

  Future _refresh() async {
    setState(() {
      showproducts = false;
    });

    setState(() {
      productlist.clear();
    });

    print("Print Products");

    var autopromote = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorviewproduct.php'),
            body: {'users': widget.useremail});

        if (views.statusCode == 200) {
          setState(() {
            rawproduct = jsonDecode(views.body);
            showproducts = true;
          });

          getvendors();
          print(rawproduct.length);
          print(jsonDecode(views.body));
        }
      } else if (jsonDecode(autopromote.body) == 'false') {
        print('api error');
      } else if (jsonDecode(autopromote.body) == 'error') {
        print('app error');
      }
    } else {
      print('Network Issues');
    }
  }

  Future searchproduct() async {
    setState(() {
      showproducts = false;
    });

    var searchproduct = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorproductsearch.php'),
        body: {'word': _Controller.text});

    if (searchproduct.statusCode == 200) {
      setState(() {
        rawproduct = jsonDecode(searchproduct.body);
      });

      if (rawproduct.length > 0) {
        setState(() {
          showproducts = true;
          searchproducts = true;
        });
      } else {
        setState(() {
          showproducts = true;
          searchproducts = false;
        });
      }
    } else {
      print("product search ${searchproduct.statusCode}");
    }
  }

  Future _refreshservice() async {
    setState(() {
      showservice = false;
    });

    print("Print services");

    var autopromote = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorviewservice.php'),
            body: {'users': widget.useremail});

        if (views.statusCode == 200) {
          rawservice = jsonDecode(views.body);
          getvendors();
          print(rawservice.length);
          print(jsonDecode(views.body));

          setState(() {
            showservice = true;
          });
        }
      } else if (jsonDecode(autopromote.body) == 'false') {
        print('api error');
      } else if (jsonDecode(autopromote.body) == 'error') {
        print('app error');
      }
    } else {
      print('Network Issues');
    }
  }

  Future viewservice() async {
    setState(() {
      showservice = false;
    });

    servicelist.clear();
    print("Print services");

    var autopromote = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorviewservice.php'),
            body: {'users': widget.useremail});

        if (views.statusCode == 200) {
          rawservice = jsonDecode(views.body);
          print(rawservice.length);
          print(jsonDecode(views.body));
          if (rawservice.length > 0) {
            setState(() {
              showservice = true;
              searchservices = true;
            });
          } else {
            setState(() {
              showservice = true;
              searchservices = false;
            });
          }
        }
      } else if (jsonDecode(autopromote.body) == 'false') {
        print('api error');
      } else if (jsonDecode(autopromote.body) == 'error') {
        print('app error');
      }
    } else {
      print('Network Issues');
    }
  }

  Future searchservice() async {
    setState(() {
      showservice = false;
    });

    var searchservice = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorservicesearch.php'),
        body: {'word': _serviceController.text});

    if (searchservice.statusCode == 200) {
      print("serach word is " + _serviceController.text);
      print(jsonDecode(searchservice.body));

      setState(() {
        rawservice = jsonDecode(searchservice.body);
      });

      if (rawservice.length > 0) {
        setState(() {
          showservice = true;
          searchservices = true;
        });
      } else {
        setState(() {
          showservice = true;
          searchservices = false;
        });
      }
    } else {
      print("Service search issues ${searchservice.statusCode}");
    }
  }

  void totalsumofitem() {
    totalsum = 0;
    for (int i = 0; i < cartitems.length; i++) {
      totalsum += (cartitems[i].amount * cartitems[i].quantity);
    }
  }

  void newtotalsum() {
    totalsum = 0;
    for (int i = 0; i < cartitems.length; i++) {
      totalsum += (cartitems[i].amount * cartitems[i].quantity);
    }
  }

  void newtotalsumplusdelivery() {
    totalsumplusdelivery = 0;
    deliverysum = 0;
    for (int i = 0; i < cartitems.length; i++) {
      deliverysum += ((cartitems[i].amount * cartitems[i].quantity) +
          cartitems[i].deliveryprice);
      totalsumplusdelivery = deliverysum;
    }
  }

  void starttotalsumplusdelivery() {
    totalsumplusdelivery = 0;
    deliverysum = 0;
    for (int i = 0; i < cartitems.length; i++) {
      deliverysum += ((cartitems[i].amount * cartitems[i].quantity) +
          cartitems[i].deliveryprice);
      totalsumplusdelivery = deliverysum;
    }
  }

  String modify(String word) {
    word = word.replaceAll("{(L!I_0)}", "'");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  Future walletbalance() async {
    print('update wallet balance');

    var getbalance = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorcustbalance.php'),
        body: {
          'custemail': widget.useremail,
        });

    if (getbalance.statusCode == 200) {
      setState(() {
        walletbal = jsonDecode(getbalance.body);
      });

      final SharedPreferences pref = await SharedPreferences.getInstance();

      await pref.setString('finalbalance', walletbal);

      print("New Wallet balance is " + walletbal);
    }
  }

  List vendors = [];

  Future getvendors() async {
    final response =
        await http.get(Uri.https('adeoropelumi.com', 'vendor/getvendors.php'));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      setState(() {
        vendors = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalsumofitem();
    starttotalsumplusdelivery();

    _selectedIndex = widget.pagenumber;

    viewproduct();
    viewservice();

    walletbal = widget.custwalletbalance;
    getvendors();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, designSize: const Size(360, 712));
    double pad = MediaQuery.of(context).size.width / 13;
    return Scaffold(
      floatingActionButton: searchbar
          ? FloatingActionButton(
              onPressed: () {
                itemselected == 0
                    ?
                    //product filter
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                                child: AlertDialog(
                              title: Text("Fliter"),
                              actions: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            rawproduct.sort((a, b) =>
                                                (int.parse(b['productprice']))
                                                    .compareTo(int.parse(
                                                        a['productprice'])));
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Higest to Lowest Price")),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            rawproduct.sort((a, b) =>
                                                (int.parse(a['productprice']))
                                                    .compareTo(int.parse(
                                                        b['productprice'])));
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Lowest to Highest Price")),
                                  ],
                                ),
                              ],
                            )))
                    :
                    //service filter
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                                child: AlertDialog(
                              title: Text("Fliter"),
                              actions: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            rawservice.sort((a, b) =>
                                                (int.parse(b['price']))
                                                    .compareTo(
                                                        int.parse(a['price'])));
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Higest to Lowest Price")),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            rawservice.sort((a, b) =>
                                                (int.parse(a['price']))
                                                    .compareTo(
                                                        int.parse(b['price'])));
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Lowest to Highest Price")),
                                  ],
                                ),
                              ],
                            )));
              },
              child: Icon(
                Icons.filter_alt_outlined,
                color: Colors.green[900],
              ),
            )
          : Container(),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: SafeArea(
            bottom: true,
            child: Column(
              children: [
                //Home Tab
                if (_selectedIndex == 0) ...[
                  //Welcome text with seacrh icon and notification icon
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, .5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              "Welcome, " + widget.username,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                        //filter Icon and notification icon
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              //search Icon
                              // GestureDetector(
                              //   onTap: () {
                              //     FocusManager.instance.primaryFocus?.unfocus();
                              //     setState(() {
                              //       searchbar = !searchbar;
                              //     });
                              //   },
                              //   child: Container(
                              //     child: FaIcon(
                              //       FontAwesomeIcons.filter,
                              //       size:
                              //           MediaQuery.of(context).size.width / 14,
                              //     ),
                              //   ),
                              // ),

                              //notification icon
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Notifications(
                                          email: widget.useremail,
                                        );
                                      }));
                                },
                                child: Container(
                                  child: FaIcon(
                                    FontAwesomeIcons.bell,
                                    size:
                                    MediaQuery.of(context).size.width / 14,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Notifications(
                                          email: widget.useremail,
                                        );
                                      }));
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.orange[100],
                                  child: Image.asset("assets/vendo.png",
                                  width: MediaQuery.of(context).size.width/14,),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  if (itemselected == 0) ...[
                    // searchbar
                      true
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 15, left: 10, right: 10, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _Controller,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        hintText: 'I am looking for ...',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_Controller.text.isNotEmpty) {
                                      print('search product');
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      searchproduct();
                                    } else {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      print('search product is empty');
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      'Search',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              25),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          ),

                  ] else if (itemselected == 1) ...[
                    // searchbar
                    true
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 15, left: 10, right: 10, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _serviceController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        hintText: 'I am looking for ...',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_serviceController.text.isNotEmpty) {
                                      print('search service');
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      searchservice();
                                    } else {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      print("search service is empty");
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      'Search',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              25),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          ),

                  ],

                  //services and products button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                itemselected = 1;
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    color: itemselected == 1
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  "Services",
                                  style: TextStyle(
                                      color: itemselected == 1
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              26,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              itemselected = 0;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                  color: itemselected == 0
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "Products",
                                style: TextStyle(
                                    color: itemselected == 0
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 26,
                                    fontWeight: FontWeight.bold),
                              ))),
                        )),
                      ],
                    ),
                  ),

                  if (itemselected == 0) ...[
                    showproducts
                        ? searchproducts
                            ? Flexible(
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    if (details.delta.dx > 0) {
                                      print("Dragging in +X direction");
                                      setState(() {
                                        itemselected = 1;
                                      });
                                    } else
                                      print("Dragging in -X direction");
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: RefreshIndicator(
                                      onRefresh: _refresh,
                                      child: GridView.builder(
                                          padding: EdgeInsets.only(top: 10),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 1 / 2,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemCount: rawproduct.length,
                                          itemBuilder: (ctx, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ViewProduct(
                                                    username: widget.username,
                                                    name: rawproduct[index]
                                                        ['productname'],
                                                    amount: rawproduct[index]
                                                        ['productprice'],
                                                    imagename: rawproduct[index]
                                                        ['productimg'],
                                                    description: rawproduct[
                                                            index]
                                                        ['productdescription'],
                                                    idname: widget.idname,
                                                    useremail: widget.useremail,
                                                    usertype: widget.usertype,
                                                    packagename:
                                                        widget.packagename,
                                                    prodid: rawproduct[index]
                                                        ['pidname'],
                                                    adminemail:
                                                        rawproduct[index]
                                                            ['useremail'],
                                                    deliveryprice: double.parse(
                                                        rawproduct[index]
                                                            ['deliveryprice']),
                                                    location: rawproduct[index]
                                                        ['location'],
                                                    custwalletbalance: widget
                                                        .custwalletbalance,
                                                  );
                                                }));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    rawproduct[index]
                                                                ['adstats'] ==
                                                            'yes'
                                                        ? Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .brown,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 2,
                                                                        bottom:
                                                                            2),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  'Ad',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                          )
                                                        : Container(),
                                                    Container(
                                                      child: Center(
                                                          child: AspectRatio(
                                                        aspectRatio: 1 / 1,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child: FadeInImage(
                                                            image: NetworkImage(
                                                              "https://adeoropelumi.com/vendor/productimage/" +
                                                                  rawproduct[
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
                                                      )),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                top: 5),
                                                        child: Text(
                                                          rawproduct[index]
                                                              ['productname'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                top: 5),
                                                        child: Text(
                                                          "₦" +
                                                              rawproduct[index][
                                                                      'productprice']
                                                                  .replaceAllMapped(
                                                                      RegExp(
                                                                          r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                      (Match m) =>
                                                                          '${m[1]},'),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        child:
                                            Image.asset('assets/search.png')),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Text(
                                        'No results',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        : Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.orange,
                                  backgroundColor: Colors.green,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "loading...",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ] else if (itemselected == 1) ...[
                    showservice == true
                        ? searchservices
                            ? Flexible(
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    if (details.delta.dx > 0) {
                                      print("Dragging in +X direction");
                                    } else {
                                      print("Dragging in -X direction");
                                      setState(() {
                                        itemselected = 0;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: RefreshIndicator(
                                      onRefresh: _refreshservice,
                                      child: GridView.builder(
                                          padding: EdgeInsets.only(top: 10),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 1 / 2,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemCount: rawservice.length,
                                          itemBuilder: (ctx, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                print(index);
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ViewService(
                                                    name: rawservice[index]
                                                        ['name'],
                                                    amount: rawservice[index]
                                                        ['price'],
                                                    imagename: rawservice[index]
                                                        ['serviceimg'],
                                                    description:
                                                        rawservice[index]
                                                            ['desription'],
                                                    idname: widget.idname,
                                                    useremail: widget.useremail,
                                                    usertype: widget.usertype,
                                                    packagename:
                                                        widget.packagename,
                                                    serviceid: rawservice[index]
                                                        ['sidname'],
                                                    adminemail:
                                                        rawservice[index]
                                                            ['useremail'],
                                                  );
                                                }));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    //ad symbol
                                                    rawservice[index]
                                                                ['adstats'] ==
                                                            'yes'
                                                        ? Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .brown,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 2,
                                                                        bottom:
                                                                            2),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  'Ad',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                          )
                                                        : Container(),
                                                    //service image
                                                    Container(
                                                        child: Center(
                                                            child: AspectRatio(
                                                      aspectRatio: 1 / 1,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        child: FadeInImage(
                                                          image: NetworkImage(
                                                              "https://adeoropelumi.com/vendor/serviceimage/" +
                                                                  rawservice[
                                                                          index]
                                                                      [
                                                                      'serviceimg']),
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
                                                      ),
                                                    ))),
                                                    //service name
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                top: 5),
                                                        child: Text(
                                                          rawservice[index]
                                                              ['name'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                    //amount
                                                    // Flexible(
                                                    //   child: Container(
                                                    //     padding:
                                                    //         EdgeInsets.only(
                                                    //             left: 5,
                                                    //             top: 5),
                                                    //     child: Text(
                                                    //       "₦" +
                                                    //           rawservice[index]
                                                    //                   ['price']
                                                    //               .replaceAllMapped(
                                                    //                   RegExp(
                                                    //                       r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                    //                   (Match m) =>
                                                    //                       '${m[1]},'),
                                                    //       textAlign:
                                                    //           TextAlign.center,
                                                    //       overflow: TextOverflow
                                                    //           .ellipsis,
                                                    //       maxLines: 2,
                                                    //       style: TextStyle(
                                                    //           color:
                                                    //               Colors.white,
                                                    //           fontSize: 16),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.height /
                                                20,
                                        child:
                                            Image.asset('assets/search.png')),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Text(
                                        'No results',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        : Flexible(
                            child: SafeArea(
                              child: Container(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.orange,
                                        backgroundColor: Colors.green,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "loading...",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ]
                ]

                //My Wallet
                else if (_selectedIndex == 1) ...[
                  //Wallet text , refresh icon and home Icon
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, .5),
                    ),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //wallet text
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Wallet",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        //refresh icon and Home Icon
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              //refresh icon
                              GestureDetector(
                                onTap: () {
                                  walletbalance();
                                },
                                child: Container(
                                  child: FaIcon(
                                    FontAwesomeIcons.arrowsRotate,
                                    size:
                                        MediaQuery.of(context).size.width / 14,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              //Home icon
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 0;
                                    widget.pagenumber = 0;
                                    showservice = true;
                                    showproducts = true;
                                    searchproducts = true;
                                    searchservices = true;
                                  });
                                },
                                child: Container(
                                  // width: MediaQuery.of(context).size.width/14,
                                  child: FaIcon(FontAwesomeIcons.house,
                                      size: MediaQuery.of(context).size.width /
                                          14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //available balance text and figure
                  Container(
                    child: Column(
                      children: [
                        //available balance text
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 20),
                          child: Text(
                            "Available Balance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 24),
                          ),
                        ),

                        //available balance figure
                        Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height / 20,
                              top: 10),
                          child: Text(
                            "₦" +
                                walletbal.replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                      child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      //topup wallet button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Topup(
                              email: widget.useremail,
                              idname: widget.idname,
                            );
                          }));
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 252, 233, 1)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset("assets/topup.png"),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Top Up Wallet",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: MediaQuery.of(context).size.width / 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //withdraw button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BankAccDetails(
                              finalbalance: walletbal,
                              idname: widget.idname,
                              useremail: widget.useremail,
                            );
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 252, 233, 1)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child:
                                    Image.asset("assets/money-withdrawal.png"),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Withdraw",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: MediaQuery.of(context).size.width / 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //transaction history
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CustTransaction(
                              email: widget.useremail,
                            );
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 252, 233, 1)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset(
                                    "assets/transactionhistory.png"),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Transaction History",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: MediaQuery.of(context).size.width / 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //set pin button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CustSetPin(
                              idname: widget.idname,
                              useremail: widget.useremail,
                            );
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 252, 233, 1)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset("assets/passpin.png"),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Set Pin",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: MediaQuery.of(context).size.width / 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //Forgot pin button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ForgotPin(
                              email: widget.useremail,
                            );
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 252, 233, 1)),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset("assets/forgot-pin.png"),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Forgot Pin?",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: MediaQuery.of(context).size.width / 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
                ] else if (_selectedIndex == 2) ...[
                  //cart
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: CustomScrollView(slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                          return cartitems.length < 1
                              ? Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.width / 4,
                                  child: Image.asset("assets/emptycart.png"))
                              : Container();
                        }, childCount: 1)),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                          double finalquantity = cartitems[index].quantity *
                              cartitems[index].amount;
                          return Container(
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 15,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  child: Image.network(
                                    "https://adeoropelumi.com/vendor/productimage/" +
                                        cartitems[index].imagename,
                                  ),
                                  width: MediaQuery.of(context).size.width / 8,
                                  height: MediaQuery.of(context).size.width / 8,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            cartitems[index].name,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text(
                                            "Vendorhive360",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: RichText(
                                            text: TextSpan(
                                                text: "₦" +
                                                    "$finalquantity"
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                            (Match m) => '${m[1]},'),
                                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14),
                                                children: [
                                                  TextSpan(
                                                      text: ' per unit',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12))
                                                ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cartitems[index].quantity--;
                                                  if (cartitems[index]
                                                          .quantity ==
                                                      0) {
                                                    cartitems[index].quantity =
                                                        1;
                                                  }
                                                  newtotalsum();
                                                  newtotalsumplusdelivery();
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 15),
                                                child: Icon(Icons.remove),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                  "${cartitems[index].quantity}"),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cartitems[index].quantity++;
                                                  newtotalsum();
                                                  newtotalsumplusdelivery();
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 15, right: 5),
                                                child: Icon(Icons.add),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            cartitems.removeWhere((i) =>
                                                i.id == cartitems[index].id);

                                            newtotalsum();
                                            newtotalsumplusdelivery();
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 2,
                                              bottom: 2),
                                          child: Text("Remove"),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }, childCount: cartitems.length)),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 20),
                              child: Column(
                                children: [
                                  //coupon code and apply button
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(238, 252, 233, 1),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(20),
                                      padding:
                                          EdgeInsets.only(bottom: 15, top: 15),
                                      color: Colors.black26,
                                      child: ClipRRect(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //Coupon code text
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  "Coupon Code",
                                                  style: TextStyle(
                                                      color: Colors.black26,
                                                      fontSize: 17),
                                                ),
                                              ),
                                            ),
                                            // apply button
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      14, 44, 3, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  right: 15,
                                                  left: 15,
                                                  bottom: 10),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                "Apply",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  //subtotal and subtotal amount
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Subtotal",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              child: Text(
                                                "₦" +
                                                    "${totalsum}".replaceAllMapped(
                                                        RegExp(
                                                            r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                        (Match m) =>
                                                            '${m[1]},'),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //delivery text and amount
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Delivery",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              child: Text(
                                                "Enter Shipping Address ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //total text and amount
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Total",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              child: Text(
                                                "₦" +
                                                    "${totalsumplusdelivery}"
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                            (Match m) =>
                                                                '${m[1]},'),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //empty cart button
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cartitems.clear();

                                        newtotalsum();

                                        newtotalsumplusdelivery();

                                        ScaffoldMessenger.of(this.context)
                                            .showSnackBar(SnackBar(
                                          content: Text('You emptied cart!'),
                                        ));
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(14, 44, 3, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Empty Cart",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  24),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //proceed to checkout button
                                  GestureDetector(
                                    onTap: () {
                                      if (cartitems.length < 1) {
                                        ScaffoldMessenger.of(this.context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Cart is empty'),
                                        ));
                                      } else {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Checkout(
                                            totalamount: totalsum,
                                            totalamountplusdelivery:
                                                totalsumplusdelivery,
                                            useremail: widget.useremail,
                                            idname: widget.idname,
                                          );
                                        }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(246, 123, 55, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Proceed to Checkout",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          childCount: 1,
                        ))
                      ]),
                    ),
                  )
                ] else if (_selectedIndex == 3) ...[
                  // message text and home button
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, .5),
                    ),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Messages",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                              widget.pagenumber = 0;
                              showservice = true;
                              showproducts = true;
                              searchproducts = true;
                              searchservices = true;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            // width: MediaQuery.of(context).size.width/14,
                            child: FaIcon(FontAwesomeIcons.house,
                                size: MediaQuery.of(context).size.width / 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //messages
                  Flexible(
                      child: showcontactlist
                          ? appcontactlist.length > 0
                              ? ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: appcontactlist.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                unreadmsgscust[index] = "0";
                                              });

                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ServiceMsg(
                                                    adminemail:
                                                        adminemaillist[index],
                                                    servicename:
                                                        servicenamelist[index],
                                                    serviceid:
                                                        appcontactlist[index],
                                                    useremail: widget.useremail,
                                                    idname: widget.idname,
                                                    usertype: widget.usertype);
                                              }));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Color.fromRGBO(
                                                                  217,
                                                                  217,
                                                                  217,
                                                                  1),
                                                          radius: 30,
                                                          child: Image.asset("assets/vendo.png"),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            5),
                                                                child: Text(
                                                                  servicenamelist[
                                                                      index],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: lastmsg[
                                                                            index]
                                                                        .contains(
                                                                            "https://adeoropelumi.com/vendor/chatsimg/")
                                                                    ? Container(
                                                                        child: Icon(
                                                                            Icons.image),
                                                                      )
                                                                    : Text(
                                                                        modify(lastmsg[
                                                                            index]),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      unreadmsgscust[index] ==
                                                              "0"
                                                          ? Container()
                                                          : Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 10,
                                                                      left: 5),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 15,
                                                                backgroundColor:
                                                                    Color
                                                                        .fromRGBO(
                                                                            243,
                                                                            207,
                                                                            198,
                                                                            1),
                                                                child: Text(
                                                                  unreadmsgscust[
                                                                      index],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  //pay vendor button
                                                  // GestureDetector(
                                                  //   onTap: () {
                                                  //     print("pay vendor");
                                                  //
                                                  //     Navigator.push(context,
                                                  //         MaterialPageRoute(
                                                  //             builder:
                                                  //                 (context) {
                                                  //       return PayforService(
                                                  //         idname: widget.idname,
                                                  //         sidname:
                                                  //             appcontactlist[
                                                  //                 index],
                                                  //         useremail:
                                                  //             widget.useremail,
                                                  //         adminemail:
                                                  //             adminemaillist[
                                                  //                 index],
                                                  //         servicename:
                                                  //             servicenamelist[
                                                  //                 index],
                                                  //       );
                                                  //     }));
                                                  //   },
                                                  //   child: Container(
                                                  //     decoration: BoxDecoration(
                                                  //         border: Border.all(
                                                  //             color: Colors
                                                  //                 .orangeAccent),
                                                  //         color: Colors.green),
                                                  //     padding:
                                                  //         EdgeInsets.symmetric(
                                                  //             vertical: 10),
                                                  //     margin: EdgeInsets.only(
                                                  //         top: 3),
                                                  //     child: Row(
                                                  //       children: [
                                                  //         Expanded(
                                                  //             child: Text(
                                                  //           "Pay Vendor",
                                                  //           textAlign: TextAlign
                                                  //               .center,
                                                  //           style: TextStyle(
                                                  //               color: Colors
                                                  //                   .white,
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .bold,
                                                  //               fontSize: 14),
                                                  //         ))
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  Divider(),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                  ],
                                )
                              : Container(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/no-spam.png",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child: Text(
                                            "no message",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    30,
                                                fontStyle: FontStyle.italic,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                          : Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.orange,
                                    backgroundColor: Colors.green,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "loading...",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                ]
                //profile page
                else if (_selectedIndex == 4) ...[
                  //profile text and home icon
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217, .5),
                    ),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //profile text
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),

                        //home icon button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                              widget.pagenumber = 0;
                              showservice = true;
                              showproducts = true;
                              searchproducts = true;
                              searchservices = true;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            // width: MediaQuery.of(context).size.width/14,
                            child: FaIcon(FontAwesomeIcons.house,
                                size: MediaQuery.of(context).size.width / 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                      child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      //edit profile button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Editprofile(
                              idname: widget.idname,
                              email: widget.useremail,
                            );
                          }));
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
                                child: Image.asset("assets/editingprofile.png",
                                    color: Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.5,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //my order button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ActiveProductOrders(
                              useremail: widget.useremail,
                              idname: widget.idname,
                            );
                          }));
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
                                child: Image.asset(
                                  "assets/clipboard.png",
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "My Orders",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.5,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //paid services button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PaidServices(
                              useremail: widget.useremail,
                              idname: widget.idname,
                            );
                          }));
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
                                child: Image.asset(
                                  "assets/services.png",
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Paid Services",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.5,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //Refer your friends button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Refers(
                              idname: widget.idname,
                              email: widget.useremail,
                            );
                          }));
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
                                child: Image.asset(
                                  "assets/people.png",
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Refer your friends",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.5,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //contect support button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ContactSupport(
                              idname: widget.idname,
                              mail: widget.useremail,
                            );
                          }));
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
                                child: Image.asset(
                                  "assets/customer-support.png",
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Contact Support",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.5,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //Settings button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Settings(
                              idname: widget.idname,
                              email: widget.useremail,
                              usertype: widget.usertype,
                            );
                          }));
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
                                child: Image.asset(
                                  "assets/setts.png",
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Settings",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.5,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[500],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              widget.pagenumber = 0;
              viewproduct();
              viewservice();
              _selectedIndex = 0;
              _serviceController.clear();
              _Controller.clear();
            });
          } else if (index == 1) {
            walletbalance();
            setState(() {
              searchbar = false;
              _selectedIndex = 1;
            });
          } else if (index == 2) {
            setState(() {
              searchbar = false;
              _selectedIndex = 2;
            });
          } else if (index == 3) {
            chatcontact();
            setState(() {
              searchbar = false;
              _selectedIndex = 3;
            });
          } else if (index == 4) {
            setState(() {
              searchbar = false;
              _selectedIndex = 4;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: MediaQuery.of(context).size.width / 13,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.wallet,
                size: MediaQuery.of(context).size.width / 13,
              ),
              label: 'My Wallet'),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 13,
                  backgroundColor: Color.fromRGBO(246, 123, 55, 1),
                  child: FaIcon(
                    FontAwesomeIcons.cartShopping,
                    color: _selectedIndex == 2 ? Colors.green : Colors.white,
                    size: MediaQuery.of(context).size.width / 13,
                  )),
              label: ''),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.message,
                size: MediaQuery.of(context).size.width / 13,
              ),
              label: 'Messages'),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.user,
                size: MediaQuery.of(context).size.width / 13,
              ),
              label: 'Profile')
        ],
      ),
    );
  }
}
