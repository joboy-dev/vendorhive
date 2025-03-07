import 'dart:convert';
import 'dart:ffi';
import '../cities/cities_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

import 'login.dart';

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
  String cities_item = "-";
  String cities_item_service = "-";
  String walletbal = "";
  String finalbalance = "0";
  String pendingbalance = "0";
  String productfilter = "-";
  String servicefilter = "-";
  String service_payment_option = "-";
  int lilo = 0;
  int _loguot = 0;
  int _selectedIndex = 0;
  int itemselected = 1;
  int bottom_nav = 0;
  double totalsum = 0;
  double totalsumplusdelivery = 0;
  double deliverysum = 0;
  bool showproducts = false;
  bool showservice = false;
  bool searchproducts = false;
  bool searchservices = false;
  bool showcontactlist = false;
  bool searchbar = false;
  bool pricesort = false;
  bool value = false;

  TextEditingController _Controller = new TextEditingController();
  TextEditingController _serviceController = new TextEditingController();
  TextEditingController _priceFrom = new TextEditingController();
  TextEditingController _priceTo = new TextEditingController();
  TextEditingController _priceFromService = new TextEditingController();
  TextEditingController _priceToService = new TextEditingController();

  List<String> lastmsg = [];
  List<String> getLogo = [];
  List<String> servicenamelist = [];
  List<String> adminemaillist = [];
  List<String> adminusername = [];
  List<String> chatcontactlist = [];
  List<String> appcontactlist = [];

  List<DropdownMenuItem<String>> dropdownItems = [];

  Future chatcontact() async {

    setState(() {
      showcontactlist = false;
    });

    print('chat contacts');
    final chatcontact = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorchatcontactscustomer.php'),
        body: {
          'useremail': widget.useremail,
        });

    if (chatcontact.statusCode == 200) {
      chatcontactlist.clear();
      appcontactlist.clear();
      lastmsg.clear();
      getLogo.clear();
      adminemaillist.clear();
      adminusername.clear();
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
            Uri.https('vendorhive360.com', 'vendor/vendorgetadminemailcust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        var admingetusername = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorgetamdinusernamecust.php'),
            body: {
              'adminemail': jsonDecode(adminemail.body),
            });

        var getonlyLogo = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorgetonlylogo.php'),
            body: {
              'useremail': jsonDecode(adminemail.body),
            });

        var servicename = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorservicenamecust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        final getlastmsg = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorgetlastmsgcust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        final unread = await http.post(
            Uri.https(
                'vendorhive360.com', 'vendor/vendorgetnumberofunreadcust.php'),
            body: {
              'sidname': appcontactlist[o],
            });

        print(jsonDecode(unread.body));

        if (unread.statusCode == 200) {
          print(appcontactlist[o]);
          print(jsonDecode(servicename.body));
          print(jsonDecode(adminemail.body));
          print(jsonDecode(admingetusername.body));
          print(jsonDecode(getlastmsg.body));
          print(jsonDecode(unread.body));
          getLogo.add(jsonDecode(getonlyLogo.body));
          adminemaillist.add(jsonDecode(adminemail.body));
          adminusername.add(jsonDecode(admingetusername.body));
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
        Uri.https('vendorhive360.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorviewproduct.php'),
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
        Uri.https('vendorhive360.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorviewproduct.php'),
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
        Uri.https('vendorhive360.com', 'vendor/vendorproductsearch.php'),
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

  Future search_filter_product() async {
    setState(() {
      showproducts = false;
    });

    var searchproduct = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetfilter.php'),
        body: {
          'from': _priceFrom.text.isEmpty?"":_priceFrom.text,
          'to' : _priceTo.text.isEmpty?"":_priceTo.text,
          'word' : _Controller.text,
          'location' : productfilter=="-" ? "" : productfilter,
          'city': cities_item == "-" ? "" : cities_item
        });

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
      print("product filtered search ${searchproduct.statusCode}");
    }
  }

  Future search_filter_service() async {
    setState(() {
      showservice = false;
    });

    var searchservice = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetservicefilter.php'),
        body: {
          'from': _priceFromService.text.isEmpty?"":_priceFromService.text,
          'to' : _priceToService.text.isEmpty?"":_priceToService.text,
          'word' : _serviceController.text,
          'location' : servicefilter=="-" ? "" : servicefilter,
          'paymentoption' : service_payment_option == "-"? "" : service_payment_option,
          'city': cities_item_service == "-" ? "" : cities_item_service
        });

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
    }
    else {
      print("Service search issues ${searchservice.statusCode}");
    }
  }

  Future _refreshservice() async {
    setState(() {
      showservice = false;
    });

    print("Print services");

    var autopromote = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorviewservice.php'),
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
        Uri.https('vendorhive360.com', 'vendor/vendorautoupdate.php'),
        body: {'name': 'vendorhive 360'});

    if (autopromote.statusCode == 200) {
      if (jsonDecode(autopromote.body) == 'true') {
        final views = await http.post(
            Uri.https('vendorhive360.com', 'vendor/vendorviewservice.php'),
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
        Uri.https('vendorhive360.com', 'vendor/vendorservicesearch.php'),
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
    }
    else {
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
        Uri.https('vendorhive360.com', 'vendor/vendorcustbalance.php'),
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
        await http.get(Uri.https('vendorhive360.com', 'vendor/getvendors.php'));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      setState(() {
        vendors = jsonDecode(response.body);
      });
    }
  }

  void filterproducts(){
    showModalBottomSheet(
      context: context,
        isScrollControlled:true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
      builder: (context){
        return StatefulBuilder(builder: (context, setState){
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text("Filter",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 0, left: 10, bottom: 0),
                      child: Text("Select State:",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            //background color of dropdown button
                            border:
                            Border.all(color: Colors.grey, width: 1),
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
                                value: productfilter,
                                items: [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    child: Text(
                                      "-",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "-",
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                      "Abia",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Abia",
                                  ),
                                  //2nd state Adamawa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Adamawa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Adamawa",
                                  ),
                                  //3rd state Akwa Ibom
                                  DropdownMenuItem(
                                    child: Text(
                                      "Akwa Ibom",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Akwa Ibom",
                                  ),
                                  //4th state Anambra
                                  DropdownMenuItem(
                                    child: Text(
                                      "Anambra",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Anambra",
                                  ),
                                  //5th state Bauchi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Bauchi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Bauchi",
                                  ),
                                  //6th state Bayelsa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Bayelsa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Bayelsa",
                                  ),
                                  //7th state Benue
                                  DropdownMenuItem(
                                    child: Text(
                                      "Benue",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Benue",
                                  ),
                                  //8th state Borno
                                  DropdownMenuItem(
                                    child: Text(
                                      "Borno",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Borno",
                                  ),
                                  //9th state Cross River
                                  DropdownMenuItem(
                                    child: Text(
                                      "Cross River",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Cross River",
                                  ),
                                  //10th state Delta
                                  DropdownMenuItem(
                                    child: Text(
                                      "Delta",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Delta",
                                  ),
                                  //11th state Ebonyi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ebonyi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ebonyi",
                                  ),
                                  //12th state Edo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Edo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Edo",
                                  ),
                                  //13th state Ekiti
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ekiti",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ekiti",
                                  ),
                                  //14th state Enugu
                                  DropdownMenuItem(
                                    child: Text(
                                      "Enugu",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Enugu",
                                  ),
                                  //37th state FCT
                                  DropdownMenuItem(
                                      child: Text(
                                        "FCT",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      value: "FCT"),
                                  //15th state Gombe
                                  DropdownMenuItem(
                                    child: Text(
                                      "Gombe",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Gombe",
                                  ),
                                  //16th state Imo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Imo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Imo",
                                  ),
                                  //17th state Jigawa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Jigawa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Jigawa",
                                  ),
                                  //18th state Kaduna
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kaduna",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kaduna",
                                  ),
                                  //19th state Kano
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kano",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kano",
                                  ),
                                  //20th state Katsina
                                  DropdownMenuItem(
                                    child: Text(
                                      "Katsina",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Katsina",
                                  ),
                                  //21th state Kebbi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kebbi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kebbi",
                                  ),
                                  //22th state kogi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kogi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kogi",
                                  ),
                                  //23th state Kwara
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kwara",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kwara",
                                  ),
                                  //24th state Lagos
                                  DropdownMenuItem(
                                    child: Text(
                                      "Lagos",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Lagos",
                                  ),
                                  //25th state Nasarawa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Nasarawa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Nasarawa",
                                  ),
                                  //26th state Niger
                                  DropdownMenuItem(
                                    child: Text(
                                      "Niger",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Niger",
                                  ),
                                  //27th  state Ogun
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ogun",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ogun",
                                  ),
                                  //28th state Ondo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ondo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ondo",
                                  ),
                                  //29th state Osun
                                  DropdownMenuItem(
                                    child: Text(
                                      "Osun",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Osun",
                                  ),
                                  //30th state Oyo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Oyo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Oyo",
                                  ),
                                  //31st state Plateau
                                  DropdownMenuItem(
                                    child: Text(
                                      "Plateau",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Plateau",
                                  ),
                                  //32nd state Rivers
                                  DropdownMenuItem(
                                    child: Text(
                                      "Rivers",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Rivers",
                                  ),
                                  //33rd state Sokoto
                                  DropdownMenuItem(
                                    child: Text(
                                      "Sokoto",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Sokoto",
                                  ),
                                  //34th state Taraba
                                  DropdownMenuItem(
                                    child: Text(
                                      "Taraba",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Taraba",
                                  ),
                                  //35th state Yobe
                                  DropdownMenuItem(
                                    child: Text(
                                      "Yobe",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Yobe",
                                  ),
                                  //36th state Zamfara
                                  DropdownMenuItem(
                                      child: Text(
                                        "Zamfara",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      value: "Zamfara"),
                                ],
                                onChanged: (value) {
                                  //get value when changed
                                  setState(() {
                                    productfilter = value!;
                                    if(value == "Abia"){
                                      // cities = List.from(abia_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        abia_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: abia_cities[index],
                                          child: Text(
                                            abia_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Adamawa"){
                                      // cities = List.from(adamawa_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        adamawa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: adamawa_cities[index],
                                          child: Text(
                                            adamawa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Akwa Ibom"){
                                      // cities = List.from(akwaibom_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        akwaibom_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: akwaibom_cities[index],
                                          child: Text(
                                            akwaibom_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Anambra"){
                                      // cities = List.from(anambra_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        anambra_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: anambra_cities[index],
                                          child: Text(
                                            anambra_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Bauchi"){
                                      // cities = List.from(bauchi_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        bauchi_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: bauchi_cities[index],
                                          child: Text(
                                            bauchi_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Bayelsa"){
                                      // cities = List.from(bayelsa_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        bayelsa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: bayelsa_cities[index],
                                          child: Text(
                                            bayelsa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Benue"){
                                      // cities = List.from(benue_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        benue_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: benue_cities[index],
                                          child: Text(
                                            benue_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Borno"){
                                      // cities = List.from(borno_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        borno_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: borno_cities[index],
                                          child: Text(
                                            borno_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Cross River"){
                                      // cities = List.from(cross_river_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        cross_river_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: cross_river_cities[index],
                                          child: Text(
                                            cross_river_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Delta"){
                                      // cities = List.from(delta_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        delta_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: delta_cities[index],
                                          child: Text(
                                            delta_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ebonyi"){
                                      // cities = List.from(ebonyi_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        ebonyi_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: ebonyi_cities[index],
                                          child: Text(
                                            ebonyi_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Edo"){
                                      // cities = List.from(edo_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        edo_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: edo_cities[index],
                                          child: Text(
                                            edo_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ekiti"){
                                      // cities = List.from(ekiti_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        ekiti_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: ekiti_cities[index],
                                          child: Text(
                                            ekiti_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Enugu"){
                                      // cities = List.from(enugu_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        enugu_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: enugu_cities[index],
                                          child: Text(
                                            enugu_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Gombe"){
                                      // cities = List.from(gombe_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        gombe_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: gombe_cities[index],
                                          child: Text(
                                            gombe_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Imo"){
                                      // cities = List.from(imo_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        imo_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: imo_cities[index],
                                          child: Text(
                                            imo_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Jigawa"){
                                      // cities = List.from(jigawa_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        jigawa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: jigawa_cities[index],
                                          child: Text(
                                            jigawa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kaduna"){
                                      // cities = List.from(kaduna_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        kaduna_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kaduna_cities[index],
                                          child: Text(
                                            kaduna_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kano"){
                                      // cities = List.from(kano_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        kano_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kano_cities[index],
                                          child: Text(
                                            kano_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Katsina"){
                                      // cities = List.from(katsina_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        katsina_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: katsina_cities[index],
                                          child: Text(
                                            katsina_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kebbi"){
                                      // cities = List.from(kebbi_cites);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        kebbi_cites.length,
                                            (index) => DropdownMenuItem(
                                          value: kebbi_cites[index],
                                          child: Text(
                                            kebbi_cites[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kogi"){
                                      // cities = List.from(kogi_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        kogi_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kogi_cities[index],
                                          child: Text(
                                            kogi_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kwara"){
                                      // cities = List.from(kwara_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        kwara_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kwara_cities[index],
                                          child: Text(
                                            kwara_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Lagos"){
                                      // cities = List.from(lagos_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        lagos_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: lagos_cities[index],
                                          child: Text(
                                            lagos_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Nasarawa"){
                                      // cities = List.from(nasarawa_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        nasarawa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: nasarawa_cities[index],
                                          child: Text(
                                            nasarawa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Niger"){
                                      // cities = List.from(niger_cites);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        niger_cites.length,
                                            (index) => DropdownMenuItem(
                                          value: niger_cites[index],
                                          child: Text(
                                            niger_cites[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ogun"){
                                      // cities = List.from(ogun_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        ogun_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: ogun_cities[index],
                                          child: Text(
                                            ogun_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ondo"){
                                      // cities = List.from(ondo_cites);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        ondo_cites.length,
                                            (index) => DropdownMenuItem(
                                          value: ondo_cites[index],
                                          child: Text(
                                            ondo_cites[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Osun"){
                                      // cities = List.from(osun_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        osun_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: osun_cities[index],
                                          child: Text(
                                            osun_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Oyo"){
                                      // cities = List.from(oyo_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        oyo_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: oyo_cities[index],
                                          child: Text(
                                            oyo_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Plateau"){
                                      // cities = List.from(plateau_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        plateau_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: plateau_cities[index],
                                          child: Text(
                                            plateau_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Rivers"){
                                      // cities = List.from(rivers_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        rivers_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: rivers_cities[index],
                                          child: Text(
                                            rivers_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Sokoto"){
                                      // cities = List.from(sokoto_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        sokoto_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: sokoto_cities[index],
                                          child: Text(
                                            sokoto_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Taraba"){
                                      // cities = List.from(taraba_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        taraba_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: taraba_cities[index],
                                          child: Text(
                                            taraba_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Yobe"){
                                      // cities = List.from(yobe_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        yobe_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: yobe_cities[index],
                                          child: Text(
                                            yobe_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Zamfara"){
                                      // cities = List.from(zamfara_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        zamfara_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: zamfara_cities[index],
                                          child: Text(
                                            zamfara_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "FCT"){
                                      // cities = List.from(fct_cities);
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        fct_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: fct_cities[index],
                                          child: Text(
                                            fct_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "-"){
                                      cities_item = "-";
                                      dropdownItems = List.generate(
                                        select_city.length,
                                            (index) => DropdownMenuItem(
                                          value: select_city[index],
                                          child: Text(
                                            select_city[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
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
                              )
                          )),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 10, left: 10, bottom: 0),
                      child: Text("Select a City",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    // select city dropdown menu
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5,bottom: 10),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            //background color of dropdown button
                            border:
                            Border.all(color: Colors.grey, width: 1),
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
                              child: DropdownButton<String>(
                                items: dropdownItems,
                                value: cities_item,
                                onChanged: (value) {
                                  setState(() {
                                    cities_item = value!;
                                    print("You have selected $value");
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
                      height: 7,
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 0, left: 10, bottom: 0),
                      child: Text("Price:",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("From",style: TextStyle(
                                      fontSize: 12
                                  ),),
                                  TextField(
                                    controller: _priceFrom,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("To",style: TextStyle(
                                        fontSize: 12
                                    ),),
                                    TextField(
                                      controller: _priceTo,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        enabledBorder: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_priceFrom.text.isNotEmpty && _priceTo.text.isEmpty){
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can't just fill one price")));
                        }
                        else if(_priceFrom.text.isEmpty && _priceTo.text.isNotEmpty){
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can't just fill one price")));
                        }
                        else if(_priceFrom.text.isEmpty && _priceTo.text.isEmpty && productfilter == "-" && cities_item == "-"){
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select a filter category")));
                        }
                        else{
                          if(_priceFrom.text.isNotEmpty && _priceTo.text.isNotEmpty){
                            if(int.parse(_priceFrom.text) > int.parse(_priceTo.text) ){
                              _priceTo.clear();
                              _priceFrom.clear();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Price from can't be greater than price to")));
                            }else{
                              Navigator.of(context).pop();
                              search_filter_product();
                              _priceFrom.clear();
                              _priceTo.clear();
                            }
                          }else{
                            Navigator.of(context).pop();
                            search_filter_product();
                            _priceFrom.clear();
                            _priceTo.clear();
                          }

                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(246, 123, 55, 1)
                        ),
                        child: Center(
                          child: Text("Filter",style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
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
          },
        );
      }
    );
  }

  void filterService(){
    showModalBottomSheet(
        context: context,
        isScrollControlled:true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        builder: (context){
          return StatefulBuilder(builder: (context,setState){
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text("Filter",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 0, left: 10, bottom: 0),
                      child: Text("Select State:",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            //background color of dropdown button
                            border:
                            Border.all(color: Colors.grey, width: 1),
                            //border of dropdown button
                            borderRadius: BorderRadius.circular(
                                10), //border raiuds of dropdown button
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                value: servicefilter,
                                items: [
                                  //add items in the dropdown
                                  DropdownMenuItem(
                                    child: Text(
                                      "-",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "-",
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                      "Abia",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Abia",
                                  ),
                                  //2nd state Adamawa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Adamawa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Adamawa",
                                  ),
                                  //3rd state Akwa Ibom
                                  DropdownMenuItem(
                                    child: Text(
                                      "Akwa Ibom",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Akwa Ibom",
                                  ),
                                  //4th state Anambra
                                  DropdownMenuItem(
                                    child: Text(
                                      "Anambra",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Anambra",
                                  ),
                                  //5th state Bauchi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Bauchi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Bauchi",
                                  ),
                                  //6th state Bayelsa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Bayelsa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Bayelsa",
                                  ),
                                  //7th state Benue
                                  DropdownMenuItem(
                                    child: Text(
                                      "Benue",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Benue",
                                  ),
                                  //8th state Borno
                                  DropdownMenuItem(
                                    child: Text(
                                      "Borno",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Borno",
                                  ),
                                  //9th state Cross River
                                  DropdownMenuItem(
                                    child: Text(
                                      "Cross River",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Cross River",
                                  ),
                                  //10th state Delta
                                  DropdownMenuItem(
                                    child: Text(
                                      "Delta",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Delta",
                                  ),
                                  //11th state Ebonyi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ebonyi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ebonyi",
                                  ),
                                  //12th state Edo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Edo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Edo",
                                  ),
                                  //13th state Ekiti
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ekiti",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ekiti",
                                  ),
                                  //14th state Enugu
                                  DropdownMenuItem(
                                    child: Text(
                                      "Enugu",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Enugu",
                                  ),
                                  //37th state FCT
                                  DropdownMenuItem(
                                      child: Text(
                                        "FCT",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      value: "FCT"),
                                  //15th state Gombe
                                  DropdownMenuItem(
                                    child: Text(
                                      "Gombe",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Gombe",
                                  ),
                                  //16th state Imo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Imo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Imo",
                                  ),
                                  //17th state Jigawa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Jigawa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Jigawa",
                                  ),
                                  //18th state Kaduna
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kaduna",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kaduna",
                                  ),
                                  //19th state Kano
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kano",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kano",
                                  ),
                                  //20th state Katsina
                                  DropdownMenuItem(
                                    child: Text(
                                      "Katsina",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Katsina",
                                  ),
                                  //21th state Kebbi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kebbi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kebbi",
                                  ),
                                  //22th state kogi
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kogi",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kogi",
                                  ),
                                  //23th state Kwara
                                  DropdownMenuItem(
                                    child: Text(
                                      "Kwara",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Kwara",
                                  ),
                                  //24th state Lagos
                                  DropdownMenuItem(
                                    child: Text(
                                      "Lagos",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Lagos",
                                  ),
                                  //25th state Nasarawa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Nasarawa",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Nasarawa",
                                  ),
                                  //26th state Niger
                                  DropdownMenuItem(
                                    child: Text(
                                      "Niger",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Niger",
                                  ),
                                  //27th  state Ogun
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ogun",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ogun",
                                  ),
                                  //28th state Ondo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Ondo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Ondo",
                                  ),
                                  //29th state Osun
                                  DropdownMenuItem(
                                    child: Text(
                                      "Osun",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Osun",
                                  ),
                                  //30th state Oyo
                                  DropdownMenuItem(
                                    child: Text(
                                      "Oyo",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Oyo",
                                  ),
                                  //31st state Plateau
                                  DropdownMenuItem(
                                    child: Text(
                                      "Plateau",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Plateau",
                                  ),
                                  //32nd state Rivers
                                  DropdownMenuItem(
                                    child: Text(
                                      "Rivers",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Rivers",
                                  ),
                                  //33rd state Sokoto
                                  DropdownMenuItem(
                                    child: Text(
                                      "Sokoto",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Sokoto",
                                  ),
                                  //34th state Taraba
                                  DropdownMenuItem(
                                    child: Text(
                                      "Taraba",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Taraba",
                                  ),
                                  //35th state Yobe
                                  DropdownMenuItem(
                                    child: Text(
                                      "Yobe",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Yobe",
                                  ),
                                  //36th state Zamfara
                                  DropdownMenuItem(
                                      child: Text(
                                        "Zamfara",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      value: "Zamfara"),
                                ],
                                onChanged: (value) {
                                  //get value when changed
                                  setState(() {
                                    servicefilter = value!;
                                    if(value == "Abia"){
                                      // cities = List.from(abia_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        abia_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: abia_cities[index],
                                          child: Text(
                                            abia_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Adamawa"){
                                      // cities = List.from(adamawa_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        adamawa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: adamawa_cities[index],
                                          child: Text(
                                            adamawa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Akwa Ibom"){
                                      // cities = List.from(akwaibom_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        akwaibom_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: akwaibom_cities[index],
                                          child: Text(
                                            akwaibom_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Anambra"){
                                      // cities = List.from(anambra_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        anambra_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: anambra_cities[index],
                                          child: Text(
                                            anambra_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Bauchi"){
                                      // cities = List.from(bauchi_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        bauchi_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: bauchi_cities[index],
                                          child: Text(
                                            bauchi_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Bayelsa"){
                                      // cities = List.from(bayelsa_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        bayelsa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: bayelsa_cities[index],
                                          child: Text(
                                            bayelsa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Benue"){
                                      // cities = List.from(benue_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        benue_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: benue_cities[index],
                                          child: Text(
                                            benue_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Borno"){
                                      // cities = List.from(borno_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        borno_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: borno_cities[index],
                                          child: Text(
                                            borno_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Cross River"){
                                      // cities = List.from(cross_river_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        cross_river_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: cross_river_cities[index],
                                          child: Text(
                                            cross_river_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Delta"){
                                      // cities = List.from(delta_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        delta_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: delta_cities[index],
                                          child: Text(
                                            delta_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ebonyi"){
                                      // cities = List.from(ebonyi_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        ebonyi_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: ebonyi_cities[index],
                                          child: Text(
                                            ebonyi_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Edo"){
                                      // cities = List.from(edo_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        edo_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: edo_cities[index],
                                          child: Text(
                                            edo_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ekiti"){
                                      // cities = List.from(ekiti_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        ekiti_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: ekiti_cities[index],
                                          child: Text(
                                            ekiti_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Enugu"){
                                      // cities = List.from(enugu_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        enugu_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: enugu_cities[index],
                                          child: Text(
                                            enugu_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Gombe"){
                                      // cities = List.from(gombe_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        gombe_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: gombe_cities[index],
                                          child: Text(
                                            gombe_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Imo"){
                                      // cities = List.from(imo_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        imo_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: imo_cities[index],
                                          child: Text(
                                            imo_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Jigawa"){
                                      // cities = List.from(jigawa_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        jigawa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: jigawa_cities[index],
                                          child: Text(
                                            jigawa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kaduna"){
                                      // cities = List.from(kaduna_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        kaduna_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kaduna_cities[index],
                                          child: Text(
                                            kaduna_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kano"){
                                      // cities = List.from(kano_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        kano_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kano_cities[index],
                                          child: Text(
                                            kano_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Katsina"){
                                      // cities = List.from(katsina_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        katsina_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: katsina_cities[index],
                                          child: Text(
                                            katsina_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kebbi"){
                                      // cities = List.from(kebbi_cites);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        kebbi_cites.length,
                                            (index) => DropdownMenuItem(
                                          value: kebbi_cites[index],
                                          child: Text(
                                            kebbi_cites[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kogi"){
                                      // cities = List.from(kogi_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        kogi_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kogi_cities[index],
                                          child: Text(
                                            kogi_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Kwara"){
                                      // cities = List.from(kwara_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        kwara_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: kwara_cities[index],
                                          child: Text(
                                            kwara_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Lagos"){
                                      // cities = List.from(lagos_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        lagos_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: lagos_cities[index],
                                          child: Text(
                                            lagos_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Nasarawa"){
                                      // cities = List.from(nasarawa_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        nasarawa_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: nasarawa_cities[index],
                                          child: Text(
                                            nasarawa_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Niger"){
                                      // cities = List.from(niger_cites);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        niger_cites.length,
                                            (index) => DropdownMenuItem(
                                          value: niger_cites[index],
                                          child: Text(
                                            niger_cites[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ogun"){
                                      // cities = List.from(ogun_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        ogun_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: ogun_cities[index],
                                          child: Text(
                                            ogun_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Ondo"){
                                      // cities = List.from(ondo_cites);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        ondo_cites.length,
                                            (index) => DropdownMenuItem(
                                          value: ondo_cites[index],
                                          child: Text(
                                            ondo_cites[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Osun"){
                                      // cities = List.from(osun_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        osun_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: osun_cities[index],
                                          child: Text(
                                            osun_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Oyo"){
                                      // cities = List.from(oyo_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        oyo_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: oyo_cities[index],
                                          child: Text(
                                            oyo_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Plateau"){
                                      // cities = List.from(plateau_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        plateau_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: plateau_cities[index],
                                          child: Text(
                                            plateau_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Rivers"){
                                      // cities = List.from(rivers_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        rivers_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: rivers_cities[index],
                                          child: Text(
                                            rivers_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Sokoto"){
                                      // cities = List.from(sokoto_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        sokoto_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: sokoto_cities[index],
                                          child: Text(
                                            sokoto_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Taraba"){
                                      // cities = List.from(taraba_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        taraba_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: taraba_cities[index],
                                          child: Text(
                                            taraba_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Yobe"){
                                      // cities = List.from(yobe_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        yobe_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: yobe_cities[index],
                                          child: Text(
                                            yobe_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "Zamfara"){
                                      // cities = List.from(zamfara_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        zamfara_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: zamfara_cities[index],
                                          child: Text(
                                            zamfara_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "FCT"){
                                      // cities = List.from(fct_cities);
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        fct_cities.length,
                                            (index) => DropdownMenuItem(
                                          value: fct_cities[index],
                                          child: Text(
                                            fct_cities[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
                                    else if(value == "-"){
                                      cities_item_service = "-";
                                      dropdownItems = List.generate(
                                        select_city.length,
                                            (index) => DropdownMenuItem(
                                          value: select_city[index],
                                          child: Text(
                                            select_city[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      );
                                    }
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
                              )
                          )),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 10, left: 10, bottom: 0),
                      child: Text("Select a City",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    // select city dropdown menu
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5,bottom: 10),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            //background color of dropdown button
                            border:
                            Border.all(color: Colors.grey, width: 1),
                            //border of dropdown button
                            borderRadius: BorderRadius.circular(
                                10), //border raiuds of dropdown button
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton<String>(
                                items: dropdownItems,
                                value: cities_item_service,
                                onChanged: (value) {
                                  setState(() {
                                    cities_item_service = value!;
                                    print("You have selected $value");
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
                      height: 7,
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 0, left: 10, bottom: 0),
                      child: Text("Select payment option:",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            //background color of dropdown button
                            border:
                            Border.all(color: Colors.grey, width: 1),
                            //border of dropdown button
                            borderRadius: BorderRadius.circular(
                                10), //border raiuds of dropdown button
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: DropdownButton(
                                value: service_payment_option,
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
                                      "Pay after service",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Pay after service",
                                  ),
                                  //2nd state Adamawa
                                  DropdownMenuItem(
                                    child: Text(
                                      "Contact to negotiate",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    value: "Contact to negotiate",
                                  ),
                                ],
                                onChanged: (value) {
                                  //get value when changed
                                  setState(() {
                                    service_payment_option = value!;
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
                              )
                          )),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(top: 0, left: 10, bottom: 0),
                      child: Text("Price:",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("From",style: TextStyle(
                                      fontSize: 12
                                  ),),
                                  TextField(
                                    controller: _priceFromService,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("To",style: TextStyle(
                                        fontSize: 12
                                    ),),
                                    TextField(
                                      controller: _priceToService,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        enabledBorder: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_priceFromService.text.isNotEmpty && _priceToService.text.isEmpty){
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can't just fill one price")));
                        }
                        else if(_priceFromService.text.isEmpty && _priceToService.text.isNotEmpty){
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can't just fill one price")));
                        }
                        else if(_priceFromService.text.isEmpty && _priceToService.text.isEmpty && servicefilter == "-"
                            && service_payment_option == "-" && cities_item_service == "-"){
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select a filter category")));
                        }
                        else{
                          if(_priceFromService.text.isNotEmpty && _priceToService.text.isNotEmpty){
                            if(int.parse(_priceFromService.text) > int.parse(_priceToService.text) ){
                              _priceToService.clear();
                              _priceFromService.clear();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Price from can't be greater than price to")));
                            }else{
                              Navigator.of(context).pop();
                              search_filter_service();
                              _priceFromService.clear();
                              _priceToService.clear();
                            }
                          }
                          else{
                            Navigator.of(context).pop();
                            search_filter_service();
                            _priceFromService.clear();
                            _priceToService.clear();
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(246, 123, 55, 1)
                        ),
                        child: Center(
                          child: Text("Filter",style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
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
        }
    );
  }

  void switch_button(){
    showDialog(
        context: context,
        builder:(cxt){
          return AlertDialog(
              title: const Text('Switch Account'),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(widget.username+", to switch account to vendor. Please sign out and login with your "
                          "vendor account and if you don't have a vendor account, kindly sign out and create a new "
                          "vendor account. Thank you ")
                    ],
                  )
              ),
              actions:[
                TextButton(
                  child: const Text('Sign Out'),
                  onPressed: () async{

                    Navigator.pop(cxt);

                    setState(() {
                      cartitems.clear();
                      _loguot = 1;
                    });

                    await Future.delayed(Duration(seconds: 5));

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    await prefs.remove('counter');
                    await prefs.remove('idname');
                    await prefs.remove('useremail');
                    await prefs.remove('packagename');
                    await prefs.remove('usertype');
                    await prefs.remove('pagenumber');
                    await prefs.remove('finalbalance');
                    await prefs.remove('pendingbalance');

                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return Login();
                        }), (r) {
                          return false;
                        });
                  },
                ),
              ]
          );
        }
    );
  }

  Future popup_notification() async{
    await Future.delayed(Duration(seconds: 3));
    showDialog(
      context: context,
      builder:(context){
        return AlertDialog(
          title: const Text('Welcome'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(""+widget.username+" welcome to Vendorhive360, a shopping hub where you can "
                    "find any product/service you want from different range of sellers, "
                    "a place where you have the control to only release payment after a product "
                    "has been delivered or after a service has been rendered to you.")
              ],
            )
          ),
          actions:[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]
        );
      }
    );
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
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

    dropdownItems = List.generate(
      select_city.length,
          (index) => DropdownMenuItem(
        value: select_city[index],
        child: Text(
          select_city[index],
          style: TextStyle(fontSize: 17),
        ),
      ),
    );

    if(widget.pagenumber != 2)popup_notification();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, designSize: const Size(360, 712));
    double pad = MediaQuery.of(context).size.width / 13;
    return _loguot == 0 ?
    Scaffold(
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
                                  popup_notification();
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
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (val){
                                      if (val.isNotEmpty) {
                                        print('search product');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        searchproduct();
                                      }
                                      else {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        print('search product is empty');
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 3),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: (){
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();

                                            if(_Controller.text.isNotEmpty){
                                              //product filter
                                              filterproducts();
                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Colors.green[800],
                                                      content: Text("Type a product in the search bar",style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),)));
                                            }

                                            print("==========");
                                            print("product Filter");
                                            print("==========");
                                          },
                                            child: Icon(Icons.filter_alt)),
                                        hintText: 'I am looking for ...',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     if (_Controller.text.isNotEmpty) {
                                //       print('search product');
                                //       FocusManager.instance.primaryFocus
                                //           ?.unfocus();
                                //       searchproduct();
                                //     } else {
                                //       FocusManager.instance.primaryFocus
                                //           ?.unfocus();
                                //       print('search product is empty');
                                //     }
                                //   },
                                //   child: Container(
                                //     padding: EdgeInsets.symmetric(
                                //         vertical: 10, horizontal: 5),
                                //     decoration: BoxDecoration(
                                //         border: Border.all(),
                                //         borderRadius: BorderRadius.circular(5)),
                                //     child: Text(
                                //       'Search',
                                //       style: TextStyle(
                                //           fontSize: MediaQuery.of(context)
                                //                   .size
                                //                   .width /
                                //               25),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  ]
                  else if (itemselected == 1) ...[
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
                                    onSubmitted: (val){
                                      if (val.isNotEmpty) {
                                        print('============');
                                        print('search product');
                                        print('============');
                                        // FocusManager.instance.primaryFocus
                                        //     ?.unfocus();
                                        searchservice();
                                      }
                                      else {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        print('============');
                                        print('search product is empty');
                                        print('============');
                                      }
                                    },
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 3),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: GestureDetector(
                                            onTap: (){
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              if(_serviceController.text.isNotEmpty){
                                                //service filter
                                                filterService();
                                              }
                                              else{
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                        backgroundColor: Colors.green[800],
                                                        content: Text("Type a service in the search bar",style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),)));
                                              }

                                              //service filter
                                              // showDialog(
                                              //     context: context,
                                              //     builder: (context) => Center(
                                              //         child: AlertDialog(
                                              //           title: Text("Fliter"),
                                              //           actions: [
                                              //             Row(
                                              //               mainAxisSize: MainAxisSize.max,
                                              //               mainAxisAlignment: MainAxisAlignment.center,
                                              //               children: [
                                              //                 TextButton(
                                              //                     onPressed: () {
                                              //                       setState(() {
                                              //                         rawservice.sort((a, b) =>
                                              //                             (int.parse(b['price']))
                                              //                                 .compareTo(
                                              //                                 int.parse(a['price'])));
                                              //                       });
                                              //                       Navigator.of(context).pop();
                                              //                     },
                                              //                     child: Text("Higest to Lowest Price")),
                                              //               ],
                                              //             ),
                                              //             Row(
                                              //               mainAxisSize: MainAxisSize.max,
                                              //               mainAxisAlignment: MainAxisAlignment.center,
                                              //               children: [
                                              //                 TextButton(
                                              //                     onPressed: () {
                                              //                       setState(() {
                                              //                         rawservice.sort((a, b) =>
                                              //                             (int.parse(a['price']))
                                              //                                 .compareTo(
                                              //                                 int.parse(b['price'])));
                                              //                       });
                                              //                       Navigator.of(context).pop();
                                              //                     },
                                              //                     child: Text("Lowest to Highest Price")),
                                              //               ],
                                              //             ),
                                              //           ],
                                              //         )));
                                              print("==========");
                                              print("Filter");
                                              print("==========");
                                            },
                                            child: Icon(Icons.filter_alt)),
                                        hintText: 'I am looking for ...',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     if (_serviceController.text.isNotEmpty) {
                                //       print('search service');
                                //       FocusManager.instance.primaryFocus
                                //           ?.unfocus();
                                //       searchservice();
                                //     } else {
                                //       FocusManager.instance.primaryFocus
                                //           ?.unfocus();
                                //       print("search service is empty");
                                //     }
                                //   },
                                //   child: Container(
                                //     padding: EdgeInsets.symmetric(
                                //         vertical: 10, horizontal: 5),
                                //     decoration: BoxDecoration(
                                //         border: Border.all(),
                                //         borderRadius: BorderRadius.circular(5)),
                                //     child: Text(
                                //       'Search',
                                //       style: TextStyle(
                                //           fontSize: MediaQuery.of(context)
                                //                   .size
                                //                   .width /
                                //               25),
                                //     ),
                                //   ),
                                // )
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
                                    }
                                    else
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
                                            childAspectRatio: 1 / 2.1,
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
                                                      MainAxisAlignment.start,
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
                                                              "https://vendorhive360.com/vendor/productimage/" +
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
                                                    Container(
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
                                                            fontSize: 15,
                                                          ),
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
                                                              rawproduct[index][
                                                              'location'],
                                                          textAlign:
                                                          TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors.yellow,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold
                                                          ),
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
                                                          rawproduct[index][
                                                          'city'],
                                                          textAlign:
                                                          TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.lightGreenAccent,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.bold
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
                                            childAspectRatio: 1 / 2.1,
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
                                                    username: widget.username,
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
                                                      MainAxisAlignment.start,
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
                                                              "https://vendorhive360.com/vendor/serviceimage/" +
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

                                                    //location
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                top: 5),
                                                        child: Text(
                                                          rawservice[index]
                                                                      ['location'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.yellow,
                                                              fontSize: 13,
                                                          fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),

                                                    //city
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 5,
                                                            top: 5),
                                                        child: Text(
                                                          rawservice[index]
                                                          ['city'],
                                                          textAlign:
                                                          TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                              Colors.lightGreenAccent,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.bold),
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
                                    bottom_nav = 0;
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
                                  child: FadeInImage(
                                    image: NetworkImage(
                                      "https://vendorhive360.com/vendor/productimage/" +
                                          cartitems[index].imagename,
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
                                                "₦" +
                                                    "${deliverysum-totalsum}"
                                                        .replaceAllMapped(
                                                    RegExp(
                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                        (Match m) =>
                                                    '${m[1]},'),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //service fee
                                  // Container(
                                  //   margin: EdgeInsets.only(bottom: 10),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Container(
                                  //         child: Text(
                                  //           "Service Fee",
                                  //           style: TextStyle(
                                  //               color: Colors.grey,
                                  //               fontSize: 12),
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         child: Align(
                                  //           alignment: Alignment.centerRight,
                                  //           child: Container(
                                  //             child: Text(
                                  //               "₦" +
                                  //                   "${(totalsumplusdelivery*0.05)}"
                                  //                       .replaceAllMapped(
                                  //                       RegExp(
                                  //                           r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  //                           (Match m) =>
                                  //                       '${m[1]},'),
                                  //               style: TextStyle(
                                  //                 color: Colors.grey,
                                  //                 fontSize: 12,),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),

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
                                                    "${totalsumplusdelivery+(totalsumplusdelivery*0.05)}"
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
                                            totalsumplusdelivery+(totalsumplusdelivery*0.05),
                                            service_fee: (totalsumplusdelivery*0.05),
                                            useremail: widget.useremail,
                                            idname: widget.idname,
                                            username: widget.username,
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
                              bottom_nav = 0;
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
                              ? RefreshIndicator(
                                onRefresh: chatcontact,
                                child: ListView.builder(
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
                                                        logo: getLogo[index],
                                                        username: adminusername[index],
                                                        adminemail:
                                                        adminemaillist[index],
                                                        servicename:
                                                        servicenamelist[index],
                                                        serviceid:
                                                        appcontactlist[index],
                                                        useremail: widget.useremail,
                                                        idname: widget.idname,
                                                        usertype: widget.usertype,
                                                    custname: widget.username,);
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
                                                      child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: FadeInImage(
                                                            image: NetworkImage(
                                                              "https://www.vendorhive360.com/vendor/blogo/"+getLogo[index],
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
                                                          )
                                                      ),
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
                                                                "https://vendorhive360.com/vendor/chatsimg/")
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
                                    }),
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
                              bottom_nav = 0;
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
                              custname: widget.username,
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
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (context) {
                      //       return PaidServices(
                      //         useremail: widget.useremail,
                      //         idname: widget.idname,
                      //       );
                      //     }));
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
                      //           child: Image.asset(
                      //             "assets/services.png",
                      //             color: Color.fromRGBO(246, 123, 55, 1),
                      //           ),
                      //         ),
                      //         Expanded(
                      //           child: Container(
                      //             margin: EdgeInsets.only(left: 15),
                      //             child: Text(
                      //               "Paid Services",
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize:
                      //                     MediaQuery.of(context).size.width /
                      //                         22.5,
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      //switch to vendor profile
                      GestureDetector(
                        onTap: () {
                          switch_button();
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
                                width:
                                MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset(
                                  "assets/switchprofile.png",
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Switch to Vendor Profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                      MediaQuery.of(context).size.width /
                                          22.5),
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
                              username: widget.username,
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
                                            22.5
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
        currentIndex: bottom_nav,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[500],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              widget.pagenumber = 0;
              if(_selectedIndex == 0){
                viewproduct();
                viewservice();
              }
              _selectedIndex = 0;
              bottom_nav = 0;
              _serviceController.clear();
              _Controller.clear();
            });
          }
          else if (index == 1) {
            walletbalance();
            setState(() {
              searchbar = false;
              _selectedIndex = 1;
              bottom_nav = 1;
            });
          }
          // else if (index == 5) {
          //   setState(() {
          //     searchbar = false;
          //     _selectedIndex = 2;
          //   });
          // }
          else if (index == 2) {
            chatcontact();
            setState(() {
              searchbar = false;
              _selectedIndex = 3;
              bottom_nav = 2;
            });
          }
          else if (index == 3) {
            setState(() {
              searchbar = false;
              _selectedIndex = 4;
              bottom_nav = 3;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: FaIcon(
                FontAwesomeIcons.house,
                size: MediaQuery.of(context).size.width / 13,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: FaIcon(
                  FontAwesomeIcons.wallet,
                  size: MediaQuery.of(context).size.width / 13,
                ),
              ),
              label: 'My Wallet'),
          // BottomNavigationBarItem(
          //     icon: CircleAvatar(
          //         radius: MediaQuery.of(context).size.width / 13,
          //         backgroundColor: _selectedIndex == 2 ? Color(0xffFFE0B1): Color.fromRGBO(246, 123, 55, 1),
          //         child: FaIcon(
          //           FontAwesomeIcons.cartShopping,
          //           color: _selectedIndex == 2 ? Colors.green[900] : Colors.white,
          //           size: MediaQuery.of(context).size.width / 13,
          //         )),
          //     label: ''),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: FaIcon(
                  FontAwesomeIcons.message,
                  size: MediaQuery.of(context).size.width / 13,
                ),
              ),
              label: 'Messages'),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: MediaQuery.of(context).size.width / 13,
                ),
              ),
              label: 'Profile')
        ],
      ),
    )
    :Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Column(
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
                        "Logging out",
                        style: TextStyle(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            fontWeight: FontWeight.bold,
                            fontSize:
                            MediaQuery.of(context).size.width / 26),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          'Vendorhive360',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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
  }
}
