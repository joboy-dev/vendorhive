import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/addproduct.dart';
import 'package:vendorandroid/screens/businesseditprofile.dart';
import 'package:vendorandroid/screens/businesspackage.dart';
import 'package:vendorandroid/screens/businesspaidservices.dart';
import 'package:vendorandroid/screens/businesswithdraw.dart';
import 'package:vendorandroid/screens/chatmessage.dart';
import 'package:vendorandroid/screens/contactsupport.dart';
import 'package:vendorandroid/screens/custsetpin.dart';
import 'package:vendorandroid/screens/editprofile.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/messages.dart';
import 'package:vendorandroid/screens/myorders.dart';
import 'package:vendorandroid/screens/notification.dart';
import 'package:vendorandroid/screens/packages.dart';
import 'package:vendorandroid/screens/pendingpayments.dart';
import 'package:vendorandroid/screens/productadded.dart';
import 'package:vendorandroid/screens/productpromotion.dart';
import 'package:vendorandroid/screens/refer.dart';
import 'package:vendorandroid/screens/serviceadded.dart';
import 'package:vendorandroid/screens/servicepromotion.dart';
import 'package:vendorandroid/screens/settings.dart';
import 'package:vendorandroid/screens/topupbusiness.dart';
import 'package:vendorandroid/screens/transaction.dart';
import 'package:vendorandroid/screens/vendorviewproducts.dart';
import 'package:vendorandroid/screens/vendorviewservice.dart';
import 'package:flutter/material.dart';
import 'package:vendorandroid/screens/orderstatus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vendorandroid/screens/listing.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:vendorandroid/screens/viewpromotedproducts.dart';
import 'package:vendorandroid/screens/viewpromotedservice.dart';

import 'forgotpin.dart';

class Chatdetails {
  String useremail = "";

  Chatdetails({required this.useremail});
}

class ProductTag {
  String id = "";
  String tag = "";

  ProductTag({required this.id, required this.tag});
}

class ServiceTags {
  String id = "";
  String tag = "";

  ServiceTags({required this.id, required this.tag});
}

class Msgcontact {
  String contact = "";
  String msg = "";

  Msgcontact({required this.contact, required this.msg});
}

class Dashboard extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String packagename = "";
  String usertype = "";
  String finalbalance = "";
  String pendingbalance = "";
  String username = "";

  Dashboard(
      {required this.idname,
      required this.useremail,
      required this.username,
      required this.packagename,
      required this.usertype,
      required this.finalbalance,
      required this.pendingbalance});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedpage = 0;
  String appproductstatus = "Vendorhive360";
  String appservicestatus = "Vendorhive360";
  String addproductstatus = "Vendorhive360";
  int _selectedIndex = 0;
  int _bottomNavIndex = 0;
  String pidname = "";
  String sidname = "";
  String options = "Pay after service";
  bool value = false;
  bool value1 = false;
  bool value2 = false;
  double amount = 0;
  bool showcontactlist = false;
  String drop = "Lagos State";
  String finalbalance = "";
  String pendingbalance = "";
  String option = "Pay on Delivery";
  String trfid = "";
  String location = "Lagos";
  String productlocation = "Lagos";

  int amountofproducts = 0;
  int amountofservice = 0;
  String numberassignedproduct = "";
  String numberassignedservice = "";
  int numberofproduct = 0;
  int numberofservice = 0;

  File? produploadimage;
  File? produploadimage2;
  File? produploadimage3;
  File? produploadimage4;
  File? produploadimage5;

  File? serviceuploadimage;
  File? serviceuploadimage2;
  File? serviceuploadimage3;
  File? serviceuploadimage4;
  File? serviceuploadimage5;

  final ImagePicker _picker = ImagePicker();
  String prodfilename = '';
  String prodfilename2 = '';
  String prodfilename3 = '';
  String prodfilename4 = '';
  String prodfilename5 = '';

  String servicefilename = '';
  String servicefilename2 = '';
  String servicefilename3 = '';
  String servicefilename4 = '';
  String servicefilename5 = '';

  Future<void> prodchooseImage() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      produploadimage = File(choosedimage!.path);
      prodfilename = choosedimage!.name;
    });
    print(prodfilename);
  }

  Future<void> prodchooseImage2() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      produploadimage2 = File(choosedimage!.path);
      prodfilename2 = choosedimage!.name;
    });
    print(prodfilename2);
  }

  Future<void> prodchooseImage3() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      produploadimage3 = File(choosedimage!.path);
      prodfilename3 = choosedimage!.name;
    });
    print(prodfilename3);
  }

  Future<void> prodchooseImage4() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      produploadimage4 = File(choosedimage!.path);
      prodfilename4 = choosedimage!.name;
    });
    print(prodfilename4);
  }

  Future<void> prodchooseImage5() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      produploadimage5 = File(choosedimage!.path);
      prodfilename5 = choosedimage!.name;
    });
    print(prodfilename5);
  }

  Future<void> servicechooseImage() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      serviceuploadimage = File(choosedimage!.path);
      servicefilename = choosedimage!.name;
    });
    print(servicefilename);
  }

  Future<void> servicechooseImage2() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      serviceuploadimage2 = File(choosedimage!.path);
      servicefilename2 = choosedimage!.name;
    });
    print(servicefilename2);
  }

  Future<void> servicechooseImage3() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      serviceuploadimage3 = File(choosedimage!.path);
      servicefilename3 = choosedimage!.name;
    });
    print(servicefilename3);
  }

  Future<void> servicechooseImage4() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      serviceuploadimage4 = File(choosedimage!.path);
      servicefilename4 = choosedimage!.name;
    });
    print(servicefilename4);
  }

  Future<void> servicechooseImage5() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      serviceuploadimage5 = File(choosedimage!.path);
      servicefilename5 = choosedimage!.name;
    });
    print(servicefilename5);
  }

  List<ProductTag> producttags = [];
  List<ServiceTags> servicetags = [];
  List<String> lastmsg = [];
  List<Chatdetails> chatdetails = [];

  List<String> idnames = [];
  List<String> sidnames = [];
  List<String> servicenamelist = [];
  List<String> chatcontactlist = [];
  List<String> appcontactlist = [];

  TextEditingController products = new TextEditingController();
  TextEditingController service = new TextEditingController();

  TextEditingController _prodname = new TextEditingController();
  TextEditingController _proddesc = new TextEditingController();
  TextEditingController _prodprice = new TextEditingController();
  TextEditingController _proddeliveryprice = new TextEditingController();
  TextEditingController _numberofdays = new TextEditingController();

  TextEditingController _servicename = new TextEditingController();
  TextEditingController _servicedesc = new TextEditingController();
  TextEditingController _serviceprice = new TextEditingController();

  void currentdate() {
    DateTime now = new DateTime.now();
    print(now.toString());
    timestamp(now.toString());
    trfid = timestamp(now.toString());
    print(trfid);
  }

  String timestamp(String str) {
    str = str.replaceAll(":", "");
    str = str.replaceAll("-", "");
    str = str.replaceAll(".", "");
    str = str.replaceAll(" ", "");
    return str;
  }

  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }

  Future addproducts() async {
    setState(() {
      _selectedpage = 1;
      appproductstatus = "loading..";
    });

    currentdate();

    pidname = "prod-" + trfid;
    print("Product ID is " + pidname);

    //product image 1
    try {
      List<int> imageBytes = produploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorproductimage.php'),
          body: {
            'image': baseimage,
            'filename': prodfilename,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'pidname': pidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Product image 1 Upload successful");
          setState(() {
            appproductstatus = "First product image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //product image 2
    try {
      List<int> imageBytes = produploadimage2!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorproductimage.php'),
          body: {
            'image': baseimage,
            'filename': prodfilename2,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'pidname': pidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Product image 2 Upload successful");
          setState(() {
            appproductstatus = "Second product image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //product image 3
    try {
      List<int> imageBytes = produploadimage3!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorproductimage.php'),
          body: {
            'image': baseimage,
            'filename': prodfilename3,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'pidname': pidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Product image 3 Upload successful");
          setState(() {
            appproductstatus = "Third product image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //product image 4
    try {
      List<int> imageBytes = produploadimage4!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorproductimage.php'),
          body: {
            'image': baseimage,
            'filename': prodfilename4,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'pidname': pidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Product image 4 Upload successful");
          setState(() {
            appproductstatus = "Fourth product image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //product image 5
    try {
      List<int> imageBytes = produploadimage5!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorproductimage.php'),
          body: {
            'image': baseimage,
            'filename': prodfilename5,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'pidname': pidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Product image 5 Upload successful");
          setState(() {
            appproductstatus = "Fifth product image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //product tags
    for (int o = 0; o < producttags.length; o++) {
      final addproducttags = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendoraddproducttags.php'),
          body: {
            'idname': widget.idname,
            'pidname': pidname,
            'useremail': widget.useremail,
            'producttag': replacingwords(producttags[o].tag),
          });

      if (addproducttags.statusCode == 200) {
        if (jsonDecode(addproducttags.body) == "product tag added") {
          print(producttags[o].tag + " is added");
          setState(() {
            appproductstatus = producttags[o].tag + " is registered";
          });
        } else {
          print(producttags[o].tag + " did not register");
        }
      } else {
        print('Network Issues');

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Network Issues')));
      }
    }

    final addproductsid = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendoraddproductid.php'),
        body: {
          'idname': widget.idname,
          'pidname': pidname,
          'useremail': widget.useremail,
        });

    try {
      //product details
      final addproducts = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendoraddproduct.php'),
          body: {
            'idname': widget.idname,
            'pidname': pidname,
            'useremail': widget.useremail,
            'prodname': replacingwords(_prodname.text),
            'proddesc': replacingwords(_proddesc.text),
            'prodprice': _prodprice.text.replaceAll(",", ""),
            'productdeliveryprice': _proddeliveryprice.text.replaceAll(",", ""),
            'location': productlocation,
            'img': prodfilename,
            'deliveryoption': option,
            'addstat': 'no'
          });

      if (addproducts.statusCode == 200) {
        if (jsonDecode(addproductsid.body) == "product id added") {
          print("Product ID is added");
          if (jsonDecode(addproducts.body) == "product added") {
            setState(() {
              _selectedpage = 0;
            });

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return ProductAdded(
                idname: widget.idname,
                username: widget.username,
                useremail: widget.useremail,
                packagename: widget.packagename,
                usertype: widget.usertype,
              );
            }), (r) {
              return false;
            });

            print("Product is added");
          } else {
            setState(() {
              _selectedpage = 0;
            });
            print("Product didn't add");
          }
        } else {
          setState(() {
            _selectedpage = 0;
          });
          print("Product ID did not add");
        }
      } else {
        setState(() {
          _selectedpage = 0;
        });
        print("Network Issue");
      }
    } catch (e) {
      var failedproduct = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/failedproduct.php'),
          body: {'pidname': pidname});

      if (failedproduct.statusCode == 200) {
        if (jsonDecode(failedproduct.body) == "true") {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: pidname);
          }));
        } else {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: pidname);
          }));
        }
      } else {
        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Failed(trfid: pidname);
        }));
      }
    }

    setState(() {
      appproductstatus = "Vendorhive360";
    });
  }

  Future checkavailabilityforproducts() async {
    Navigator.of(context).pop();

    setState(() {
      _selectedpage = 1;
    });

    print("print add product out");

    final SharedPreferences pref = await SharedPreferences.getInstance();

    final String? packagename = pref.getString('packagename');

    final productamount = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorgetpackagedetails.php'),
        body: {
          'packagename': packagename ?? '',
        });

    if (productamount.statusCode == 200) {
      print('getting assigned products');
      print(jsonDecode(productamount.body));
      print(jsonDecode(productamount.body)[0]);
      print("Assingned number of products:- " +
          jsonDecode(productamount.body)[0]['productamount']);
      numberassignedproduct =
          jsonDecode(productamount.body)[0]['productamount'];
      numberofproduct = int.parse(numberassignedproduct);
    } else {
      setState(() {
        _selectedpage = 0;
      });
    }

    print("getting used products");
    final checkfornumberofproducts = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorcheckproductid.php'),
        body: {'email': widget.useremail});

    if (checkfornumberofproducts.statusCode == 200) {
      idnames.clear();
      print(jsonDecode(checkfornumberofproducts.body));

      jsonDecode(checkfornumberofproducts.body)
          .forEach((s) => idnames.add(s["pidname"]));
      print("List lenght is $idnames.length");

      amountofproducts = idnames.length;
      print(amountofproducts);

      print("Used amount of products :- $amountofproducts");

      for (int o = 0; o < idnames.length; o++) {
        print("PId names in list " + idnames[o]);
      }

      if (numberofproduct > amountofproducts) {
        int available = numberofproduct - amountofproducts;
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text('You have $available available product to create'),
        ));
        setState(() {
          _selectedpage = 0;
          _selectedIndex = 4;
        });
      } else if (numberofproduct == amountofproducts) {
        setState(() {
          _selectedpage = 0;
        });

        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text('You have used all your available products'),
        ));
      } else {
        setState(() {
          _selectedpage = 0;
        });

        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text('You have used all your available products'),
        ));
      }
    } else {
      setState(() {
        _selectedpage = 0;
      });
    }
  }

  Future addservices() async {
    setState(() {
      _selectedpage = 1;
      appservicestatus = "loading..";
    });

    currentdate();

    sidname = "serv-" + trfid;

    print("Service ID is " + sidname);

    //service image 1
    try {
      List<int> imageBytes = serviceuploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorserviceimage.php'),
          body: {
            'image': baseimage,
            'filename': servicefilename,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'sidname': sidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Service image 1 Upload successful");
          setState(() {
            appservicestatus = "First Service image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //service image 2
    try {
      List<int> imageBytes = serviceuploadimage2!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorserviceimage.php'),
          body: {
            'image': baseimage,
            'filename': servicefilename2,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'sidname': sidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Service image 2 Upload successful");
          setState(() {
            appservicestatus = "Second Service image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //service image 3
    try {
      List<int> imageBytes = serviceuploadimage3!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorserviceimage.php'),
          body: {
            'image': baseimage,
            'filename': servicefilename3,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'sidname': sidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Service image 3 Upload successful");
          setState(() {
            appservicestatus = "Third Service image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //service image 4
    try {
      List<int> imageBytes = serviceuploadimage4!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorserviceimage.php'),
          body: {
            'image': baseimage,
            'filename': servicefilename4,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'sidname': sidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Service image 4 Upload successful");
          setState(() {
            appservicestatus = "Fourth Service image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //service image 5
    try {
      List<int> imageBytes = serviceuploadimage5!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorserviceimage.php'),
          body: {
            'image': baseimage,
            'filename': servicefilename5,
            'idname': widget.idname,
            'useremail': widget.useremail,
            'sidname': sidname
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Service image 5 Upload successful");
          setState(() {
            appservicestatus = "Fifth Service image is registered";
          });
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
    }

    //service tags
    for (int o = 0; o < servicetags.length; o++) {
      final addservicetags = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendoraddservicetag.php'),
          body: {
            'idname': widget.idname,
            'sidname': sidname,
            'useremail': widget.useremail,
            'producttag': replacingwords(servicetags[o].tag),
          });

      if (addservicetags.statusCode == 200) {
        if (jsonDecode(addservicetags.body) == "service tag added") {
          print(servicetags[o].tag + " is added");
          setState(() {
            appservicestatus = servicetags[o].tag + " is registered";
          });
        } else {
          print(servicetags[o].tag + " did not register");
        }
      }
    }

    final addserviceid = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendoraddserviceid.php'),
        body: {
          'idname': widget.idname,
          'sidname': sidname,
          'useremail': widget.useremail
        });

    try {
      final addservice = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendoraddservice.php'),
          body: {
            'idname': widget.idname,
            'sidname': sidname,
            'useremail': widget.useremail,
            'name': replacingwords(_servicename.text),
            'description': replacingwords(_servicedesc.text),
            'price': _serviceprice.text.replaceAll(',', ''),
            'paymentoption': options,
            'img': servicefilename,
            'location' : location
          });

      if (addservice.statusCode == 200) {
        if (jsonDecode(addservice.body) == 'service is registerd') {
          print("Customer service is registered");

          setState(() {
            _selectedpage = 0;
            appservicestatus = "Service details is registered...";
          });

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ServiceAdded(
              idname: widget.idname,
              username: widget.username,
              useremail: widget.useremail,
              packagename: widget.packagename,
              usertype: widget.usertype,
            );
          }), (r) {
            return false;
          });
        } else {
          print('Customer services were not registered');
        }
      } else {
        print('Network Error');
      }
    } catch (e) {
      var failedservices = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/failedservices.php'),
          body: {'sidname': sidname});

      if (failedservices.statusCode == 200) {
        if (jsonDecode(failedservices.body) == "true") {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: pidname);
          }));
        } else {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: pidname);
          }));
        }
      } else {
        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Failed(trfid: pidname);
        }));
      }
    }

    setState(() {
      appservicestatus = 'Vendorhive360';
    });
  }

  Future checkavailabilityforservices() async {
    Navigator.of(context).pop(true);

    setState(() {
      _selectedpage = 1;
    });

    final SharedPreferences pref = await SharedPreferences.getInstance();

    final String? packagename = pref.getString('packagename');

    final serviceamount = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorgetpackagedetails.php'),
        body: {
          'packagename': packagename ?? '',
        });

    if (serviceamount.statusCode == 200) {
      print(jsonDecode(serviceamount.body));

      print(jsonDecode(serviceamount.body)[0]);

      print("Assingned number of service:- " +
          jsonDecode(serviceamount.body)[0]['serviceamount']);

      numberassignedservice =
          jsonDecode(serviceamount.body)[0]['serviceamount'];

      numberofservice = int.parse(numberassignedservice);
    } else {
      setState(() {
        _selectedpage = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Network Issues when getting number of assigned services')));
    }

    print("getting services");

    final checkfornumberofservices = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorcheckserviceid.php'),
        body: {'email': widget.useremail});

    if (checkfornumberofservices.statusCode == 200) {
      sidnames.clear();
      print(jsonDecode(checkfornumberofservices.body));

      jsonDecode(checkfornumberofservices.body)
          .forEach((s) => sidnames.add(s["sidname"]));
      print("List lenght is $sidnames.length");

      amountofservice = sidnames.length;
      print(amountofservice);

      print("Used amount of services :- $amountofservice");

      for (int o = 0; o < sidnames.length; o++) {
        print("SId names in list " + sidnames[o]);
      }

      if (numberofservice > amountofservice) {
        setState(() {
          _selectedpage = 0;
        });

        int available = numberofservice - amountofservice;

        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text('You have $available available service to create'),
        ));

        setState(() {
          _selectedIndex = 5;
        });
      } else if (numberofservice == amountofservice) {
        setState(() {
          _selectedpage = 0;
        });

        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text(
              'You have used all your available service. Upgrade to get more services'),
        ));
      } else {
        setState(() {
          _selectedpage = 0;
        });

        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text(
              'You have used all your available service. Upgrade to get more services'),
        ));
      }
    } else {
      setState(() {
        _selectedpage = 0;
      });

      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text('Network Issues'),
      ));
    }
  }

  Future chatcontact() async {
    setState(() {
      showcontactlist = false;
    });

    print('chat contacts');

    final chatcontact = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorchatcontacts.php'),
        body: {'adminemail': widget.useremail, 'usertype': 'customer'});

    if (chatcontact.statusCode == 200) {
      servicenamelist.clear();
      chatcontactlist.clear();
      appcontactlist.clear();
      lastmsg.clear();
      chatdetails.clear();
      unreadmsgs.clear();

      print(jsonDecode(chatcontact.body));

      // jsonDecode(chatcontact.body).forEach((s)=>chatcontactlist.add(s['useremail']));
      jsonDecode(chatcontact.body)
          .forEach((s) => chatcontactlist.add(s['bstatus']));

      print('chat contact list number ${chatcontactlist.length}');

      appcontactlist = chatcontactlist.toSet().toList();
      print('Actual number ${appcontactlist.length}');

      int move = 0;

      for (int o = 0; o < appcontactlist.length; o++) {
        print("service id " + appcontactlist[o]);

        var servicename = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorgetservicename.php'),
            body: {'sidname': appcontactlist[o]});

        var useremaildetails = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorgetchatuseremail.php'),
            body: {'sidname': appcontactlist[o]});

        final getlastmsg = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorgetlastmsg.php'),
            body: {
              'sidname': appcontactlist[o],
              // 'accountmail': 'customer'
            });

        final unread = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/vendorgetnumberofunread.php'),
            body: {
              'sidname': appcontactlist[o],
              // 'adminemail': widget.useremail
            });

        if (getlastmsg.statusCode == 200) {
          print(jsonDecode(servicename.body));

          print(jsonDecode(getlastmsg.body));

          print(jsonDecode(useremaildetails.body));

          chatdetails
              .add(Chatdetails(useremail: jsonDecode(useremaildetails.body)));

          servicenamelist.add(jsonDecode(servicename.body));

          lastmsg.add(jsonDecode(getlastmsg.body));

          print(jsonDecode(unread.body));

          unreadmsgs.add(jsonDecode(unread.body).toString());

          print(appcontactlist.length);

          move++;

          print('new ${move}');
        } else {
          print("Get last message issues ${getlastmsg.statusCode}");
        }
      }

      if (move == appcontactlist.length) {
        setState(() {
          showcontactlist = true;
        });
      }
    } else {
      print("chat contact issues ${chatcontact.statusCode}");
    }
  }

  String modify(String word) {
    word = word.replaceAll("{(L!I_0)}", "'");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  String replacingwords(String word) {
    word = word.replaceAll("'", "");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  //add products and service
  void showModal() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            //height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 3),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2)),
                          ),
                          height: 10,
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ],
                    ),
                  ),
                  //add product button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        checkavailabilityforproducts();
                      });
                    },
                    child: Container(
                      child: Text(
                        "Add product",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),
                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),
                  //add service button
                  GestureDetector(
                    onTap: () {
                      checkavailabilityforservices();
                    },
                    child: Container(
                      child: Text(
                        "Add service",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),
                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Center(
                      child: Text(
                        addproductstatus,
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  //view products and services
  void showMyPandS() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            //height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
                // color: Colors.blue,
                // borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                ),
            child: Container(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 3),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2)),
                          ),
                          height: 10,
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ],
                    ),
                  ),
                  //view my products button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VendorViewProducts(
                          idname: widget.idname,
                          adminemail: widget.useremail,
                        );
                      }));
                    },
                    child: Container(
                      child: Text(
                        "View Products",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),
                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VendorService(
                          idname: widget.idname,
                          adminemail: widget.useremail,
                        );
                      }));
                    },
                    child: Container(
                      child: Text(
                        "View Services",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),
                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Center(
                      child: Text(
                        addproductstatus,
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  //promote products and services
  void promotion() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              child: ListView(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 3),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2)),
                          ),
                          height: 10,
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ],
                    ),
                  ),
                  //set/proceed to set product promotion
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Productpromotion(
                          idname: widget.idname,
                          adminemail: widget.useremail,
                        );
                      }));
                    },
                    child: Container(
                      child: Text(
                        "Products",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),

                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),

                  //set/proceed to set service promotion
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ServicePromotion(
                          idname: widget.idname,
                          adminemail: widget.useremail,
                        );
                      }));
                    },
                    child: Container(
                      child: Text(
                        "Services",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),

                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),

                  Container(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Center(
                      child: Text(
                        "Vendorhive360",
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
          );
        });
  }

  //view promoted products and services
  void selectviewpromotion() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            //height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
                // color: Colors.blue,
                // borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                ),
            child: Container(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 3),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2)),
                          ),
                          height: 10,
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ],
                    ),
                  ),
                  //view promoted products button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewPromotedProducts(
                          idname: widget.idname,
                          email: widget.useremail,
                        );
                      }));
                    },
                    child: Container(
                      child: Text(
                        "View Promoted Products",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),

                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),
                  //view promoted services button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewPromotedService(
                          idname: widget.idname,
                          email: widget.useremail,
                        );
                      }));
                    },
                    child: Container(
                      child: Text(
                        "View Promoted Services",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      margin: EdgeInsets.only(left: 25, top: 20),
                    ),
                  ),

                  Container(
                    child: Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),

                  Container(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Center(
                      child: Text(
                        addproductstatus,
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  //update available balance
  Future availablebalance() async {
    try {
      print('getting available balance');

      var getbalance = await http.post(
          Uri.https(
              'adeoropelumi.com', 'vendor/vendorbusinessavailablebalance.php'),
          body: {'adminemail': widget.useremail});

      if (getbalance.statusCode == 200) {
        setState(() {
          finalbalance = jsonDecode(getbalance.body);
        });

        final SharedPreferences pref = await SharedPreferences.getInstance();

        await pref.setString('finalbalance', finalbalance);

        print("final balance is " + finalbalance);
      } else {
        print(getbalance.statusCode);
      }
    } catch (e) {
      print("Request timed out");
    }
  }

  //update pending balance
  Future finalpendinglebalance() async {
    try {
      print('getting pending balance');

      var getpendingbalance = await http.post(
          Uri.https(
              'adeoropelumi.com', 'vendor/vendorbusinesspendingbalance.php'),
          body: {'adminemail': widget.useremail});

      if (getpendingbalance.statusCode == 200) {
        setState(() {
          pendingbalance = jsonDecode(getpendingbalance.body);
        });

        final SharedPreferences pref = await SharedPreferences.getInstance();

        await pref.setString('pendingbalance', pendingbalance);

        print("pending balance is " + pendingbalance);
      } else {
        print(getpendingbalance.statusCode);
      }
    } catch (e) {
      print("Request timed out");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 712));
    return Scaffold(
      body: _selectedpage == 0
          ? GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: SafeArea(
                  child: Column(
                    children: [
                      //Home tab
                      if (_selectedIndex == 0) ...[
                        //home appbar - welcome, package, notification and refresh button
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //welcome + package
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome, " + widget.username,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Package: " + widget.packagename,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  26),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                //notification + refresh
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      //notification button
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Notifications(
                                              email: widget.useremail,
                                            );
                                          }));
                                        },
                                        child: Container(
                                            child: FaIcon(
                                          FontAwesomeIcons.solidBell,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              14,
                                        )),
                                      ),

                                      SizedBox(
                                        width: 10,
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          // Navigator.push(context,
                                          //     MaterialPageRoute(builder: (context) {
                                          //       return Notifications(
                                          //         email: widget.useremail,
                                          //       );
                                          //     }));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.orange[100],
                                          child: Image.asset("assets/vendo.png",
                                            width: MediaQuery.of(context).size.width/14,),
                                        ),
                                      ),

                                      //refresh button
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     print('refresh');
                                      //     availablebalance();
                                      //     finalpendinglebalance();
                                      //   },
                                      //   child: Container(
                                      //     child: FaIcon(
                                      //       FontAwesomeIcons.arrowsRotate,
                                      //       size: MediaQuery.of(context)
                                      //               .size
                                      //               .width /
                                      //           14,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        //dashboard - NGN revenue text + amount + topup button + withdrawal button + history button
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 123, 55, 1)),
                          child: Column(
                            children: [
                              //ngn revenue text
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "NGN Revenue",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25),
                                  ),
                                ),
                              ),
                              //ngn amountm/ available balance
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "₦" +
                                        finalbalance.replaceAllMapped(
                                            RegExp(
                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                            (Match m) => '${m[1]},'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                14),
                                  ),
                                ),
                              ),
                              //topup button +
                              Container(
                                margin: EdgeInsets.only(bottom: 20, top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //topup for vendor
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TopupBusiness(
                                              email: widget.useremail,
                                              idname: widget.idname);
                                        }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, .2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              child: Image.asset(
                                                "assets/topup.png",
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              child: Text(
                                                "Top up",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            26),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //withdraw button for vendor
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return BusinessWithdraw(
                                            idname: widget.idname,
                                            useremail: widget.useremail,
                                            finalbalance: finalbalance,
                                          );
                                        }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, .2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              child: Image.asset(
                                                "assets/money-withdrawal.png",
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              child: Text(
                                                "Withdraw",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            26),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //transaction history for vendor
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Transactions(
                                            idname: widget.idname,
                                            adminemail: widget.useremail,
                                          );
                                        }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, .2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              child: Image.asset(
                                                "assets/businesshistory.png",
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              child: Text(
                                                "History",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            26),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ] else if (_selectedIndex == 1) ...[
                        //vendor wallet app bar
                        Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(217, 217, 217, .5),
                            ),
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //wallet text
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Wallet",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                //refresh button + home button
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      //refresh button
                                      GestureDetector(
                                        onTap: () {
                                          print('refresh');
                                          availablebalance();
                                          finalpendinglebalance();
                                        },
                                        child: Container(
                                          child: FaIcon(
                                            FontAwesomeIcons.arrowsRotate,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      //home button
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          child: FaIcon(FontAwesomeIcons.house,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  14),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),

                        Flexible(
                          child: CustomScrollView(slivers: [
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                              return Container(
                                child: Column(
                                  children: [
                                    //available balance text
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        "Available Balance",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26),
                                      ),
                                    ),
                                    //available balance figure
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 15, bottom: 25),
                                      child: Text(
                                        "₦" +
                                            finalbalance.replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match m) => '${m[1]},'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    //pending balance text
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      child: Text(
                                        "Pending Balance",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                26,
                                            color: Color.fromRGBO(
                                                255, 172, 28, 1)),
                                      ),
                                    ),
                                    //pending balance figure
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 15, bottom: 25),
                                      child: Text(
                                        "₦" +
                                            pendingbalance.replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match m) => '${m[1]},'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                15,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                255, 172, 28, .8)),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }, childCount: 1)),
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                              return Column(
                                children: [
                                  //top up wallet button
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return TopupBusiness(
                                            email: widget.useremail,
                                            idname: widget.idname);
                                      }));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(238, 252, 233, 1)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            margin: EdgeInsets.only(left: 10),
                                            child:
                                                Image.asset("assets/topup.png"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Top Up Wallet",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            23),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  //withdrawal button
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return BusinessWithdraw(
                                          idname: widget.idname,
                                          useremail: widget.useremail,
                                          finalbalance: finalbalance,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(238, 252, 233, 1)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Image.asset(
                                                "assets/money-withdrawal.png"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Withdraw",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            23),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  //transaction history button
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Transactions(
                                          idname: widget.idname,
                                          adminemail: widget.useremail,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(238, 252, 233, 1)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
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
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            23),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  //pending payment history
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return PendingPayments(
                                          idname: widget.idname,
                                          adminemail: widget.useremail,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(238, 252, 233, 1)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            margin: EdgeInsets.only(left: 10),
                                            child:
                                                Image.asset("assets/time.png"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Pending Payments",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            23),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  //set promotion budget button
                                  GestureDetector(
                                    onTap: () {
                                      promotion();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(238, 252, 233, 1)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Image.asset(
                                                "assets/promotions.png"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Set Promotions Budget",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            23),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
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
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(238, 252, 233, 1)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Image.asset(
                                                "assets/passpin.png"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Set Pin",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            23),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
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
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(238, 252, 233, 1)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Image.asset(
                                                "assets/forgot-pin.png"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Forgot Pin?",
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            22),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }, childCount: 1)),
                          ]),
                        ),
                      ] else if (_selectedIndex == 2) ...[
                        //message app bar
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
                                child: Text(
                                  "Messages",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 0;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: FaIcon(FontAwesomeIcons.house,
                                      size: MediaQuery.of(context).size.width /
                                          14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_selectedIndex == 3) ...[
                        //vendor profile app bar
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
                                  child: Text(
                                    "Profile",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          child: FaIcon(FontAwesomeIcons.house,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  14),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ] else if (_selectedIndex == 4) ...[
                        //add product app bar
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
                                  child: Text(
                                    "Add Product",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          child: Icon(
                                            Icons.home,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ] else if (_selectedIndex == 5) ...[
                        //add service app bar
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(217, 217, 217, .5),
                          ),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: SafeArea(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Add Service",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = 0;
                                        });
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.home,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                        ),
                      ],

                      if (_selectedIndex == 0) ...[
                        Flexible(
                            child: ListView(
                          children: [
                            //My Account takes you to the wallet
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(238, 252, 233, 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 15),
                                      child: Image.asset(
                                          "assets/businessaccount.png"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "My Account",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //view products ordered by customers on your product
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyOrders(
                                    idname: widget.idname,
                                    useremail: widget.useremail,
                                  );
                                }));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(238, 252, 233, 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 15),
                                      child:
                                          Image.asset("assets/clipboard.png"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "My Orders",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //view promoted products and services
                            GestureDetector(
                              onTap: () {
                                selectviewpromotion();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(238, 252, 233, 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 15),
                                      child:
                                          Image.asset("assets/promotion.png"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Promotion",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //view My Products / Services
                            GestureDetector(
                              onTap: () {
                                showMyPandS();
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(238, 252, 233, 1)),
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 15),
                                      child: Image.asset("assets/store.png"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "My Products/Services",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  22),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ))
                      ] else if (_selectedIndex == 1)
                        ...[]
                      else if (_selectedIndex == 2) ...[
                        //messages
                        Flexible(
                          child: showcontactlist
                              ? appcontactlist.length > 0
                                  ? ListView(children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: appcontactlist.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  unreadmsgs[index] = "0";
                                                });
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ChatMsg(
                                                    sidname:
                                                        appcontactlist[index],
                                                    useremail:
                                                        chatdetails[index]
                                                            .useremail,
                                                    adminemail:
                                                        widget.useremail,
                                                    idname: widget.idname,
                                                    usertype: widget.usertype,
                                                    servicename:
                                                        servicenamelist[index],
                                                  );
                                                }));
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    217,
                                                                    217,
                                                                    217,
                                                                    1),
                                                            radius: 30,
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
                                                                    chatdetails[
                                                                            index]
                                                                        .useremail,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: lastmsg[
                                                                              index]
                                                                          .contains(
                                                                              "https://adeoropelumi.com/vendor/chatsimg/")
                                                                      ? Container(
                                                                          child:
                                                                              Icon(Icons.image),
                                                                        )
                                                                      : Text(
                                                                          modify(
                                                                              lastmsg[index]),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        unreadmsgs[index] == "0"
                                                            ? Container()
                                                            : Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            5),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 15,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          243,
                                                                          207,
                                                                          198,
                                                                          1),
                                                                  child: Text(
                                                                    unreadmsgs[
                                                                        index],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Divider()
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                    ])
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
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            30,
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily: 'Raleway',
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                              : Container(
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
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  30,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      ] else if (_selectedIndex == 3) ...[
                        //vendor profile
                        Flexible(
                          child: ListView(children: [
                            //Editprofile button
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BusinessEditProfile(
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
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                          "assets/editingprofile.png",
                                          color:
                                              Color.fromRGBO(246, 123, 55, 1)),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //View vendor products ordered by customer button
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyOrders(
                                    idname: widget.idname,
                                    useremail: widget.useremail,
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
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/clipboard.png",
                                        color: Color.fromRGBO(246, 123, 55, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "My Orders",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //View vendor serices paid by customer button
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BusinessPaidServices(
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
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/services.png",
                                        color: Color.fromRGBO(246, 123, 55, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Paid Services",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //refer you friends with your code button
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
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/people.png",
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Refer your friends",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //updrage your package
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BusinessPackage(
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
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/businessupgrade.png",
                                        color: Color.fromRGBO(246, 123, 55, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Upgrade to Pro User",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //contact support button
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ContactSupport(
                                    mail: widget.useremail,
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
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/customer-support.png",
                                        color: Color.fromRGBO(246, 123, 55, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Contact Support",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //settings button
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
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        "assets/setts.png",
                                        color: Color.fromRGBO(246, 123, 55, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Settings",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ]),
                        )
                      ] else if (_selectedIndex == 4) ...[
                        //Add products
                        Flexible(
                            child: ListView(children: [
                          //product name text
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Product Name"),
                          ),
                          //product name textfiled
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _prodname,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                              ),
                            ),
                          ),
                          //description text
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Description"),
                          ),
                          //description textfiled
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _proddesc,
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                              ),
                            ),
                          ),
                          //product price text
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Product price"),
                          ),
                          //product price textfield
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _prodprice,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                ThousandsFormatter(allowFraction: true)
                              ],
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                              ),
                            ),
                          ),

                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Delivery price"),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _proddeliveryprice,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                ThousandsFormatter(allowFraction: true)
                              ],
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Number of days for delivery"),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _numberofdays,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: .5, color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: .5, color: Colors.grey)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "days",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 20),
                            child: Text("Delivery Options"),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: DropdownButton(
                                      value: option,
                                      items: [
                                        //add items in the dropdown
                                        DropdownMenuItem(
                                          child: Text(
                                            "Pay on Delivery",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          value: "Pay on Delivery",
                                        ),
                                        DropdownMenuItem(
                                            child: Text(
                                              "Pay Online",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            value: "Pay Online"),
                                      ],
                                      onChanged: (value) {
                                        //get value when changed
                                        setState(() {
                                          option = value!;
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
                                          color: Colors.white,
                                          //Font color
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
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Attach"),
                          ),
                          Container(
                            height: 150,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      prodchooseImage();
                                    },
                                    child: produploadimage == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child:
                                                Image.file(produploadimage!))),
                                GestureDetector(
                                    onTap: () {
                                      prodchooseImage2();
                                    },
                                    child: produploadimage2 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child:
                                                Image.file(produploadimage2!))),
                                GestureDetector(
                                    onTap: () {
                                      prodchooseImage3();
                                    },
                                    child: produploadimage3 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child:
                                                Image.file(produploadimage3!))),
                                GestureDetector(
                                    onTap: () {
                                      prodchooseImage4();
                                    },
                                    child: produploadimage4 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child:
                                                Image.file(produploadimage4!))),
                                GestureDetector(
                                    onTap: () {
                                      prodchooseImage5();
                                    },
                                    child: produploadimage5 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child:
                                                Image.file(produploadimage5!))),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Tags"),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 5, left: 10, right: 10),
                            child: TextField(
                              controller: products,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: .5,
                                  color: Colors.black,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.black)),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      var rand = Random();
                                      int id = rand.nextInt(1000000000);
                                      print("lilo");
                                      print(products.text);
                                      setState(() {
                                        producttags.add(ProductTag(
                                            id: id.toString(),
                                            tag: products.text));
                                        products.clear();
                                      });
                                    },
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 30,
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(229, 228, 226, 1),
                                borderRadius: BorderRadius.circular(10)),
                            margin:
                                EdgeInsets.only(left: 10, top: 5, right: 10),
                            child: Container(
                              // margin: EdgeInsets.only(left: 10),
                              child: Wrap(children: [
                                for (int i = 0; i < producttags.length; i++)
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    margin: EdgeInsets.only(
                                        left: 10, top: 3.5, bottom: 3.5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(producttags[i].tag),
                                        GestureDetector(
                                            onTap: () {
                                              print("lilo");
                                              setState(() {
                                                producttags.removeWhere((a) =>
                                                    a.id == producttags[i].id);
                                              });
                                            },
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Icon(
                                                  Icons.cancel,
                                                  size: 20,
                                                ))),
                                      ],
                                    ),
                                  ),
                              ]),
                            ),
                          ),
                              Container(
                                margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                child: Text("Location"),
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
                                          value: productlocation,
                                          items: [
                                            //add items in the dropdown
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
                                              productlocation = value!;
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
                          GestureDetector(
                            onTap: () {
                              addproducts();
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "NEXT",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                appproductstatus,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 13),
                              ),
                            ),
                          )
                        ]))
                      ] else if (_selectedIndex == 5) ...[
                        //Add service
                        Flexible(
                            child: ListView(children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text("Name"),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: TextField(
                              controller: _servicename,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: .5,
                                  )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: .5, color: Colors.grey))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Description"),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _servicedesc,
                              maxLines: null,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: .5,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Starting Price"),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _serviceprice,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                ThousandsFormatter(allowFraction: true)
                              ],
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: .5,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Attach photos"),
                          ),
                          Container(
                            height: 150,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      servicechooseImage();
                                    },
                                    child: serviceuploadimage == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Image.file(
                                                serviceuploadimage!))),
                                GestureDetector(
                                    onTap: () {
                                      servicechooseImage2();
                                    },
                                    child: serviceuploadimage2 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Image.file(
                                                serviceuploadimage2!))),
                                GestureDetector(
                                    onTap: () {
                                      servicechooseImage3();
                                    },
                                    child: serviceuploadimage3 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Image.file(
                                                serviceuploadimage3!))),
                                GestureDetector(
                                    onTap: () {
                                      servicechooseImage4();
                                    },
                                    child: serviceuploadimage4 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Image.file(
                                                serviceuploadimage4!))),
                                GestureDetector(
                                    onTap: () {
                                      servicechooseImage5();
                                    },
                                    child: serviceuploadimage5 == null
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 228, 226, 1),
                                            ),
                                            child: Image(
                                              image:
                                                  AssetImage("assets/add.png"),
                                              color: Color.fromRGBO(
                                                  129, 133, 137, 1),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Image.file(
                                                serviceuploadimage5!))),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Payment Options"),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
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
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: DropdownButton(
                                      value: options,
                                      items: [
                                        //add items in the dropdown
                                        DropdownMenuItem(
                                          child: Text(
                                            "Pay after service",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          value: "Pay after service",
                                        ),
                                        DropdownMenuItem(
                                            child: Text(
                                              "Contact to negotiate",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            value: "Contact to negotiate"),
                                      ],
                                      onChanged: (value) {
                                        //get value when changed
                                        setState(() {
                                          options = value!;
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
                                          color: Colors.white,
                                          //Font color
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
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, bottom: 5),
                            child: Text("Tags"),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 5, left: 10, right: 10),
                            child: TextField(
                              controller: service,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: .5,
                                  color: Colors.black,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5, color: Colors.black)),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      var rand = Random();
                                      int id = rand.nextInt(1000000000);
                                      print("lilo");
                                      print(service.text);
                                      setState(() {
                                        servicetags.add(ServiceTags(
                                            id: id.toString(),
                                            tag: service.text));
                                        service.clear();
                                      });
                                    },
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 30,
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(229, 228, 226, 1),
                                borderRadius: BorderRadius.circular(10)),
                            margin:
                                EdgeInsets.only(left: 10, top: 5, right: 10),
                            child: Container(
                              // margin: EdgeInsets.only(left: 10),
                              child: Wrap(children: [
                                for (int i = 0; i < servicetags.length; i++)
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    margin: EdgeInsets.only(
                                        left: 10, top: 3.5, bottom: 3.5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(servicetags[i].tag),
                                        GestureDetector(
                                            onTap: () {
                                              print("lilo");
                                              setState(() {
                                                servicetags.removeWhere((a) =>
                                                    a.id == servicetags[i].id);
                                              });
                                            },
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Icon(
                                                  Icons.cancel,
                                                  size: 20,
                                                ))),
                                      ],
                                    ),
                                  ),
                              ]),
                            ),
                          ),
                          Container(
                            margin:
                            EdgeInsets.only(top: 10, left: 10, bottom: 10),
                            child: Text("Location"),
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
                                      value: location,
                                      items: [
                                        //add items in the dropdown
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
                                          location = value!;
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
                          GestureDetector(
                            onTap: () {
                              addservices();
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(246, 123, 55, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "Create Service",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                "Vendorhive360",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ]))
                      ],
                    ],
                  ),
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
                            "Processing",
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              _selectedIndex = 0;
              _bottomNavIndex = 0;
            });
          } else if (index == 1) {
            setState(() {
              _selectedIndex = 1;
              _bottomNavIndex = 1;
            });
            availablebalance();
            finalpendinglebalance();
          } else if (index == 2) {
            setState(() {
              _bottomNavIndex = 2;
              showModal();
            });
          } else if (index == 3) {
            chatcontact();
            setState(() {
              _selectedIndex = 2;
              _bottomNavIndex = 3;
            });
          } else if (index == 4) {
            setState(() {
              _selectedIndex = 3;
              _bottomNavIndex = 4;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.house,
                size: MediaQuery.of(context).size.width / 13,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.wallet,
                size: MediaQuery.of(context).size.width / 13,
              ),
              label: 'My Wallet'),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Color.fromRGBO(246, 123, 55, 1),
                radius: MediaQuery.of(context).size.width / 13,
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width / 13,
                ),
              ),
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

  @override
  initState() {
    super.initState();
    finalbalance = widget.finalbalance;
    pendingbalance = widget.pendingbalance;
  }
}
