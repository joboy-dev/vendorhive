import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/successdeleteservice.dart';

import 'faileddelete.dart';

class DeleteService extends StatefulWidget {
  String sidname = "";
  String email = "";
  String serviceimg = "";
  String serviceoldPrice = "";
  String serviceolddescription = "";
  String servicename = "";
  String payment_option = "";
  String service_status = "";
  String idname = "";

  DeleteService(
      {required this.email,
      required this.idname,
      required this.sidname,
      required this.serviceimg,
      required this.serviceoldPrice,
      required this.serviceolddescription,
      required this.servicename,
      required this.payment_option,
      required this.service_status,
      Key? key})
      : super(key: key);

  @override
  _DeleteServiceState createState() => _DeleteServiceState();
}

class _DeleteServiceState extends State<DeleteService> {
  int _loadIndex = 0;
  int _selectedItem = 0;
  String priceStatus = "";
  String descriptionStatus = "";
  String paymentOptionStatus = "";
  String service_payment_option = "-";
  String numberassignedservice = "";
  int numberofservice = 0;
  List<String> sidnames = [];
  int amountof_active_service = 0;
  int number_of_referals_service = 0;
  List referals_service = [];

  TextEditingController _newPrice = new TextEditingController();
  TextEditingController _newDescription = new TextEditingController();

  Future check_before_activate_service() async {

    final getpackages = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetpackage.php'),
        body: {'useremail': widget.email});

    print("Package "+jsonDecode(getpackages.body)['package'].toString());

    final serviceamount = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetpackagedetails.php'),
        body: {
          'packagename': jsonDecode(getpackages.body)['package'].toString(),
        });

    var earn = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorviewearnings.php'),
        body: {
          'idname':widget.idname
        }
    );

    if (serviceamount.statusCode == 200 && earn.statusCode == 200) {
      print(jsonDecode(serviceamount.body));

      print(jsonDecode(serviceamount.body)[0]);

      print("Assingned number of service:- " +
          jsonDecode(serviceamount.body)[0]['serviceamount']);

      numberassignedservice =
      jsonDecode(serviceamount.body)[0]['serviceamount'];

      if(jsonDecode(getpackages.body)['package'].toString() == "Free"){
        numberofservice = int.parse(numberassignedservice);
      }
      else{
        numberofservice = int.parse(numberassignedservice)+5;
      }
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text('Network Issues when getting number of assigned services')));
    }

    print("getting services");

    final checkfornumberofservices = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendor_number_of_active_services.php'),
        body: {'email': widget.email});

    if (checkfornumberofservices.statusCode == 200) {
      sidnames.clear();
      print(jsonDecode(checkfornumberofservices.body));

      jsonDecode(checkfornumberofservices.body)
          .forEach((s) => sidnames.add(s["sidname"]));
      print("List lenght is ${sidnames.length}");

      amountof_active_service = sidnames.length;
      print(amountof_active_service);

      print("Used amount of services :- $amountof_active_service");

      // for (int o = 0; o < sidnames.length; o++) {
      //   print("SId names in list " + sidnames[o]);
      // }

      referals_service = jsonDecode(earn.body);
      number_of_referals_service = referals_service.length;

      if ((numberofservice + number_of_referals_service) > amountof_active_service) {
        print("Activating service");
        activate_service();
      }
      else {
        setState(() {
          _loadIndex = 0;
        });
        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text('You have exceed your activation limit, Upgrade Package'),
            )
        );
      }
    } else {
      setState(() {
        _loadIndex = 0;
      });
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text('Network Issues'),
      ));
    }
  }

  Future deactivate_service() async{
    setState(() {
      _loadIndex = 1;
    });

    var deactivate = await http.post(
        Uri.https('vendorhive360.com','vendor/vendor_deactivate_service.php'
        ),
        body: {
          "sidname":widget.sidname
        });

    if(deactivate.statusCode == 200){
      if(jsonDecode(deactivate.body) == "true"){

        setState(() {
          _loadIndex = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Service is deactivated"))
        );
      }
      else{

        setState(() {
          _loadIndex = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request timed out")));
      }
    }
    else{

      setState(() {
        _loadIndex = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request timed out")));
    }
  }

  Future activate_service() async{
    var activate = await http.post(
        Uri.https(
            'vendorhive360.com','vendor/vendor_service_activate.php'
        ),
        body: {
          "sidname":widget.sidname
        });

    if(activate.statusCode == 200){
      if(jsonDecode(activate.body) == "true"){

        setState(() {
          _loadIndex = 0;
        });

        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text('Service is Activated!'),
            )
        );
      }
      else{

        setState(() {
          _loadIndex = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request timed out")));
      }
    }
    else{

      setState(() {
        _loadIndex = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request timed out")));
    }
  }

  Future delete_service()async{
    setState(() {
      _loadIndex = 1;
    });
    var response = await http.post(
        Uri.https('vendorhive360.com', 'vendor/delete_service.php'),
        body: {'sidname': widget.sidname});
    if(response.statusCode == 200){
      if(jsonDecode(response.body)=="true"){
        setState(() {
          _loadIndex = 0;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SuccessDeleteService();
        }));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return FailedDelete();
        }));
      }
    }
  }

  Future update_service_price() async{
    setState(() {
      _loadIndex = 1;
    });
    var response = await http.post(Uri.https('vendorhive360.com', 'vendor/vendorupdateserviceprice.php'),
        body: {
          'sidname':widget.sidname,
          'newprice':_newPrice.text
        });
    if(response.statusCode == 200){
      if(jsonDecode(response.body) == "true"){
        setState(() {
          _loadIndex = 0;
          _newPrice.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text("New Price is Set",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),)));
        setState(() {
          priceStatus = "New Price is Set";
        });
      }else{
        setState(() {
          _loadIndex = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.grey[100],
                content: Text("Failed!!",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600]
                ),))
        );
        setState(() {
          priceStatus = "Failed!!";
        });
      }
    }
  }

  Future update_service_description() async{
    setState(() {
      _loadIndex = 1;
    });
    try{
      var response = await http.post(Uri.https('vendorhive360.com', 'vendor/vendorupdateservicedescription.php'),
          body: {
            'sidname':widget.sidname,
            'newdescription': replacing(_newDescription.text)
          });
      if(response.statusCode == 200){
        if(jsonDecode(response.body) == "true"){
          setState(() {
            _loadIndex = 0;
            _newDescription.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("New Description is Set",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),)));
          setState(() {
            descriptionStatus = "New Description is Set";
          });
        }else{
          setState(() {
            _loadIndex = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.grey[100],
                  content: Text("Failed!!",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600]
                  ),))
          );
          setState(() {
            descriptionStatus = "Failed!!";
          });
        }
      }
    }catch(e){
      print("Error is "+e.toString());
    }
  }

  Future update_service_payment_option() async{
    setState(() {
      _loadIndex = 1;
    });
    try{
      var response = await http.post(Uri.https('vendorhive360.com', 'vendor/vendorupdatepaymentoption.php'),
          body: {
            'sidname':widget.sidname,
            'paymentoption': service_payment_option
          });
      if(response.statusCode == 200){
        if(jsonDecode(response.body) == "true"){
          setState(() {
            _loadIndex = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("New Payment Option is Set",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),)));
          setState(() {
            paymentOptionStatus = "New Payment Option is Set";
          });
        }else{
          setState(() {
            _loadIndex = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.grey[100],
                  content: Text("Failed!!",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600]
                  ),))
          );
          setState(() {
            paymentOptionStatus = "Failed!!";
          });
        }
      }
    }catch(e){
      print("Error is "+e.toString());
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
    print(widget.sidname);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _loadIndex == 0
          ? GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
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
                                  widget.servicename+" Settings",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ),

                            //back button
                            GestureDetector(
                              onTap: () {
                                if(_selectedItem == 1){
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                }
                                else if(_selectedItem == 2){
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                }
                                else if(_selectedItem == 3){
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                }
                                else if(_selectedItem == 4){
                                  setState(() {
                                    _selectedItem = 0;
                                  });
                                }
                                else{
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

                    if(_selectedItem == 0)...[
                      //edit price
                      GestureDetector(
                        onTap: (){
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
                                width:
                                MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset(
                                    "assets/price_tag.png",
                                    color:
                                    Color.fromRGBO(246, 123, 55, 1)),
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
                      //edit description
                      GestureDetector(
                        onTap: (){
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
                                width:
                                MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset(
                                    "assets/edit.png",
                                    color:
                                    Color.fromRGBO(246, 123, 55, 1)),
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
                      //edit payment option
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedItem = 4;
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
                                width:
                                MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset(
                                    "assets/mobile-payment.png",
                                    color:
                                    Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Edit Payment Option",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      widget.service_status == "active"?
                      //Deactivate Product
                      GestureDetector(
                        onTap: () {
                          showDialog(context: context, builder: (cxt)=>AlertDialog(
                            title: Text("Deactivate product"),
                            content: Text("Do you want to deactivate this product"),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("No",style: TextStyle(
                                  color: Colors.red
                              ),)),
                              TextButton(onPressed: (){
                                Navigator.pop(cxt);
                                deactivate_service();
                              }, child: Text("Yes")),
                            ],
                          ));
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
                                child: Image.asset("assets/deactivate.png",
                                    color: Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Deactivate Product",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      //activate product
                      :GestureDetector(
                        onTap: () {
                          showDialog(context: context, builder: (cxt)=>AlertDialog(
                            title: Text("Activate product"),
                            content: Text("Do you want to activate this product"),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("No",style: TextStyle(
                                  color: Colors.red
                              ),)),
                              TextButton(onPressed: (){
                                Navigator.pop(cxt);
                                check_before_activate_service();
                              }, child: Text("Yes")),
                            ],
                          ));
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
                                child: Image.asset("assets/power-button.png",
                                    color: Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Activate Product",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //delete service
                      GestureDetector(
                        onTap: (){
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
                                width:
                                MediaQuery.of(context).size.width / 8,
                                margin: EdgeInsets.only(left: 10),
                                child: Image.asset(
                                    "assets/bin.png",
                                    color:
                                    Color.fromRGBO(246, 123, 55, 1)),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Delete Service",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]
                    else if(_selectedItem == 1)...[
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
                          child: Text(
                            "Do you want to delete this serivce?",
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
                                delete_service();
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
                                      color: Colors.red, fontWeight: FontWeight.bold),
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
                              "https://vendorhive360.com/vendor/serviceimage/" +
                                  widget.serviceimg,
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
                    ]else if(_selectedItem == 2)...[
                      Container(
                          padding: EdgeInsets.only(left: 10,top: 10),
                          child: Row(
                            children: [
                              Text("Old Price:",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),),
                              const SizedBox(width: 5,),
                              Expanded(
                                child: Text("₦" +widget.serviceoldPrice.replaceAllMapped(
                                    RegExp(
                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},'),style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),),
                              ),
                            ],
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                          child: Row(
                            children: [
                              Text("New Price:",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),),
                              const SizedBox(width: 5,),
                              Expanded(
                                  child: TextField(
                                    controller: _newPrice,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Set New Price...",
                                        contentPadding: EdgeInsets.only(left: 10),
                                        enabledBorder: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder()
                                    ),
                                  )
                              ),
                            ],
                          )
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(_newPrice.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Ensure to enter an amount",style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),)
                                )
                            );
                          }else{
                            update_service_price();
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
                            child: Text("Set Price",style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(priceStatus,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),),
                      )
                    ]
                    else if(_selectedItem == 3)...[
                        Container(
                          padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                          child: Text("Old Description:",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,top: 1,right: 10),
                          child: Text(modify(widget.serviceolddescription),style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15
                          ),),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                          child: Text("New Description:",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,top: 1,right: 10),
                          child: TextField(
                            controller: _newDescription,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: "Set New Description...",
                                contentPadding: EdgeInsets.only(left: 10),
                                enabledBorder: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder()
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(_newDescription.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Ensure to enter a new description!",style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),)
                                  )
                              );
                            }else{
                              update_service_description();
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
                              child: Text("Set Description",style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(descriptionStatus,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic
                          ),),
                        )
                    ]
                    else if(_selectedItem == 4)...[
                        Container(
                          padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                          child: Text("Old Payment Option:",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,top: 1,right: 10),
                          child: Text(modify(widget.payment_option),style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15
                          ),),
                        ),
                        const SizedBox(
                            height: 10,
                          ),
                        Container(
                            padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                            child: Text("Select new payment option:",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
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
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(service_payment_option == "-"){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Select a new payment option!",style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),)
                                  )
                              );
                            }else{
                              update_service_payment_option();
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
                              child: Text("Set Payment Option",style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(paymentOptionStatus,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic
                          ),),
                        )
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
