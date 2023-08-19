// import 'dart:convert';
//
// import 'package:vendorandroid/screens/activeproductorders.dart';
// import 'package:vendorandroid/screens/checkout.dart';
// import 'package:vendorandroid/screens/contactsupport.dart';
// import 'package:vendorandroid/screens/editprofile.dart';
// import 'package:vendorandroid/screens/listing.dart';
// import 'package:vendorandroid/screens/myorders.dart';
// import 'package:vendorandroid/screens/packages.dart';
// import 'package:vendorandroid/screens/paidservices.dart';
// import 'package:vendorandroid/screens/payforservice.dart';
// import 'package:vendorandroid/screens/refer.dart';
// import 'package:vendorandroid/screens/servicemsg.dart';
// import 'package:vendorandroid/screens/settings.dart';
// import 'package:vendorandroid/screens/viewproduct.dart';
// import 'package:vendorandroid/screens/viewservice.dart';
// import 'package:flutter/material.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:vendorandroid/screens/cart.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
//
// class Lilo{
//   String name= "";
//   String amount = "";
//   Lilo({required this.name,required this.amount});
// }
//
// class Products{
//   String idname = "";
//   String pidname = "";
//   String useremail = "";
//   String productname = "";
//   String productdesc = "";
//   String productprice = "";
//   String paymentoption = "";
//   String productimage = "";
//   String productdeliveryprice = '';
//   String location = '';
//   Products({required this.idname, required this.pidname, required this.useremail,
//     required this.productname ,required this.productdesc,
//     required this.productprice, required this.paymentoption, required this.productimage,
//   required this.productdeliveryprice, required this.location});
// }
//
// class Service{
//   String idname = "";
//   String sidname = "";
//   String useremail = "";
//   String servicename = "";
//   String servicedesc = "";
//   String serviceprice = "";
//   String paymentoption = "";
//   String serviceimage = "";
//   Service({required this.idname, required this.sidname, required this.useremail,
//     required this.servicename ,required this.servicedesc,
//     required this.serviceprice, required this.paymentoption, required this.serviceimage});
// }
//
// class SearchGridView extends StatefulWidget {
//   String idname = "";
//   String useremail = "";
//   String packagename = "";
//   String usertype = "";
//   int pagenumber = 0;
//   SearchGridView({required this.idname, required this.useremail,
//     required this.packagename, required this.usertype,required this.pagenumber});
//
//   @override
//   _SearchGridViewState createState() => _SearchGridViewState();
// }
//
// class _SearchGridViewState extends State<SearchGridView> {
//   int _selectedIndex = 0;
//   double totalsum = 0;
//   double totalsumplusdelivery = 0;
//   double deliverysum = 0;
//   bool showproducts = false;
//   bool showservice = false;
//   int itemselected = 1;
//   bool showcontactlist = false;
//   TextEditingController _Controller = new TextEditingController();
//   TextEditingController _serviceController = new TextEditingController();
//
//   List<Lilo>? listItemSearch;
//   List? rawproduct;
//   List? rawservice;
//   List<Products>? productlistserch;
//   List? servicelisttry;
//   List<Service>? servicelistserch;
//
//
//   List<Lilo> listItems = [
//     Lilo(name: "Arts", amount: "N10,000"),
//     Lilo(name: "Design", amount: "N20,000"),
//     Lilo(name: "Entertainment", amount: "N1,000"),
//     Lilo(name: "Sports", amount: "N100,000"),
//     Lilo(name: "Building", amount: "N40,000"),
//     Lilo(name: "Business", amount: "N90,000"),
//     Lilo(name: "Education", amount: "N200,000"),
//     Lilo(name: "Training", amount: "N5,000"),
//     Lilo(name: "Farming", amount: "N6,000"),
//     Lilo(name: "Fishing", amount: "N8,000"),
//     Lilo(name: "Food", amount: "N9,000"),
//     Lilo(name: "Healthcare", amount: "N10,000"),
//     Lilo(name: "Legal", amount: "N45,000"),
//     Lilo(name: "Management", amount: "N23,000"),
//     Lilo(name: "Production", amount: "N34,000"),
//     Lilo(name: "Sales", amount: "N78,000"),
//     Lilo(name: "Biostatistics", amount: "N29,000"),
//     Lilo(name: "Developers", amount: "N67,000"),
//   ];
//
//   List<String>? itemsListSearch;
//   List<String> lastmsg = [];
//   List<String> servicenamelist = [];
//   List<String> adminemaillist = [];
//   List<String> chatcontactlist = [];
//   List<String> appcontactlist = [];
//
//   Future chatcontact() async{
//
//     setState(() {
//       showcontactlist = false;
//     });
//
//     print('chat contacts');
//     final chatcontact = await http.post(Uri.https('adeoropelumi.com','vendor/vendorchatcontactscustomer.php'),body: {
//       'useremail': widget.useremail,
//     });
//
//     if(chatcontact.statusCode == 200){
//       chatcontactlist.clear();
//       appcontactlist.clear();
//       lastmsg.clear();
//       adminemaillist.clear();
//       servicenamelist.clear();
//       unreadmsgscust.clear();
//
//       print(jsonDecode(chatcontact.body));
//       jsonDecode(chatcontact.body).forEach((s)=>chatcontactlist.add(s['bstatus']));
//
//       print(chatcontactlist.length);
//
//       appcontactlist = chatcontactlist.toSet().toList();
//       print("Filtered list ${appcontactlist.length}");
//
//       for(int o = 0; o<chatcontactlist.length; o++){
//         print(chatcontactlist[o]);
//       }
//
//       for(int o =0; o<appcontactlist.length; o++){
//
//         var adminemail = await http.post(Uri.https('adeoropelumi.com','vendor/vendorgetadminemailcust.php'),body: {
//           'sidname': appcontactlist[o],
//         });
//
//         var servicename = await http.post(Uri.https('adeoropelumi.com','vendor/vendorservicenamecust.php'),body: {
//           'sidname':appcontactlist[o],
//         });
//
//         final getlastmsg = await http.post(Uri.https('adeoropelumi.com','vendor/vendorgetlastmsgcust.php'),body: {
//           'sidname':appcontactlist[o],
//         });
//
//         final unread = await http.post(Uri.https('adeoropelumi.com','vendor/vendorgetnumberofunreadcust.php'),body: {
//           'sidname':appcontactlist[o],
//         });
//
//         print(jsonDecode(unread.body));
//
//         if(unread.statusCode ==200){
//           print(appcontactlist[o]);
//           print(jsonDecode(servicename.body));
//           print(jsonDecode(adminemail.body));
//           print(jsonDecode(getlastmsg.body));
//           print(jsonDecode(unread.body));
//           adminemaillist.add(jsonDecode(adminemail.body));
//           servicenamelist.add(jsonDecode(servicename.body));
//           lastmsg.add(jsonDecode(getlastmsg.body));
//           unreadmsgscust.add(jsonDecode(unread.body).toString());
//         }
//       }
//
//       setState(() {
//         showcontactlist = true;
//       });
//
//     }
//   }
//
//   Future viewproduct() async{
//
//     if(widget.pagenumber == 0){
//
//       setState((){
//         showproducts = false;
//       });
//
//       productlist.clear();
//       print("Print Products");
//
//       final views = await http.post(Uri.https('adeoropelumi.com','vendor/vendorviewproduct.php'),body: {
//         'users':widget.useremail
//       });
//
//       if(views.statusCode == 200){
//
//         rawproduct = jsonDecode(views.body);
//         var values = jsonDecode(views.body);
//         print(rawproduct!.length);
//         print(jsonDecode(views.body));
//
//         for(int o = 0; o < rawproduct!.length; o++){
//
//           print(values[o]["idname"]);
//           print(values[o]["pidname"]);
//           print(values[o]["useremail"]);
//           print(values[o]["productname"]);
//           print(values[o]["productdescription"]);
//           print(values[o]["productprice"]);
//
//           final getdeliveryoption = await http.post(Uri.https('adeoropelumi.com','vendor/vendorgetdeliveryoption.php'),body: {
//             'pidname': jsonDecode(views.body)[o]["pidname"]
//           });
//
//           final productimage = await http.post(Uri.https('adeoropelumi.com','vendor/vendorproductimageone.php'),body: {
//             'pidname': jsonDecode(views.body)[o]["pidname"]
//           });
//
//           if(productimage.statusCode == 200){
//
//             print(jsonDecode(getdeliveryoption.body));
//             print(jsonDecode(productimage.body));
//
//             productlist.add(Products(idname: jsonDecode(views.body)[o]["idname"],
//                 pidname: jsonDecode(views.body)[o]["pidname"],
//                 useremail: jsonDecode(views.body)[o]["useremail"],
//                 productname: jsonDecode(views.body)[o]["productname"],
//                 productdesc: jsonDecode(views.body)[o]["productdescription"],
//                 productprice: jsonDecode(views.body)[o]["productprice"],
//                 paymentoption: jsonDecode(getdeliveryoption.body),
//                 productimage: jsonDecode(productimage.body) ,
//             productdeliveryprice: jsonDecode(views.body)[o]["deliveryprice"],
//             location: jsonDecode(views.body)[o]["location"],));
//
//             setState((){
//               showproducts = true;
//             });
//
//           }
//
//         }
//       }
//     }
//     else{
//       setState((){
//         showproducts = true;
//       });
//     }
//
//   }
//
//   Future _refresh() async{
//     // setState((){
//     //   showproducts = false;
//     // });
//
//     setState((){
//       productlist.clear();
//     });
//     print("Print Products");
//
//     final views = await http.post(Uri.https('adeoropelumi.com','vendor/vendorviewproduct.php'),body: {
//       'users':widget.useremail
//     });
//
//     if(views.statusCode == 200){
//       // setState((){
//       //   showproducts = false;
//       // });
//       rawproduct = jsonDecode(views.body);
//       print(rawproduct!.length);
//       print(jsonDecode(views.body));
//       for(int o = 0; o < rawproduct!.length; o++){
//
//         print(jsonDecode(views.body)[o]["idname"]);
//         print(jsonDecode(views.body)[o]["pidname"]);
//         print(jsonDecode(views.body)[o]["useremail"]);
//         print(jsonDecode(views.body)[o]["productname"]);
//         print(jsonDecode(views.body)[o]["productdescription"]);
//         print(jsonDecode(views.body)[o]["productprice"]);
//
//         final getdeliveryoption = await http.post(Uri.https('adeoropelumi.com','vendor/vendorgetdeliveryoption.php'),body: {
//           'pidname': jsonDecode(views.body)[o]["pidname"]
//         });
//
//         final productimage = await http.post(Uri.https('adeoropelumi.com','vendor/vendorproductimageone.php'),body: {
//           'pidname': jsonDecode(views.body)[o]["pidname"]
//         });
//
//         if(productimage.statusCode == 200){
//
//           print(jsonDecode(getdeliveryoption.body));
//           print(jsonDecode(productimage.body));
//
//           setState(() {
//             productlist.add(Products(idname: jsonDecode(views.body)[o]["idname"],
//                 pidname: jsonDecode(views.body)[o]["pidname"],
//                 useremail: jsonDecode(views.body)[o]["useremail"],
//                 productname: jsonDecode(views.body)[o]["productname"],
//                 productdesc: jsonDecode(views.body)[o]["productdescription"],
//                 productprice: jsonDecode(views.body)[o]["productprice"],
//                 paymentoption: jsonDecode(getdeliveryoption.body),
//                 productimage: jsonDecode(productimage.body) ,
//               productdeliveryprice: jsonDecode(views.body)[o]["deliveryprice"],
//               location: jsonDecode(views.body)[o]["location"],));
//           });
//
//           // setState((){
//           //   showproducts = true;
//           // });
//
//         }
//
//       }
//     }
//   }
//
//   Future _refreshservice() async{
//     // setState((){
//     //   showproducts = false;
//     // });
//
//     setState((){
//       servicelist.clear();
//     });
//
//     print("Print services");
//
//     final views = await http.post(Uri.https('adeoropelumi.com','vendor/vendorviewservice.php'),body: {
//       'users':widget.useremail
//     });
//
//     if(views.statusCode == 200){
//
//       setState((){
//         showservice = false;
//       });
//
//       rawservice = jsonDecode(views.body);
//       print(rawservice!.length);
//       print(jsonDecode(views.body));
//       servicelisttry = jsonDecode(views.body);
//       print(servicelisttry![0]['idname']);
//       for(int o = 0; o < rawservice!.length; o++){
//
//         print(jsonDecode(views.body)[o]["idname"]);
//         print(jsonDecode(views.body)[o]["sidname"]);
//         print(jsonDecode(views.body)[o]["useremail"]);
//         print(jsonDecode(views.body)[o]["name"]);
//         print(jsonDecode(views.body)[o]["desription"]);
//         print(jsonDecode(views.body)[o]["price"]);
//         print(jsonDecode(views.body)[o]["paymentoption"]);
//
//
//         final serviceimage = await http.post(Uri.https('adeoropelumi.com','vendor/vendorserviceimageone.php'),body: {
//           'sidname': jsonDecode(views.body)[o]["sidname"]
//         });
//
//         if(serviceimage.statusCode == 200){
//
//           print(jsonDecode(serviceimage.body));
//
//           setState((){
//             servicelist.add(Service(idname: jsonDecode(views.body)[o]["idname"],
//                 sidname: jsonDecode(views.body)[o]["sidname"],
//                 useremail: jsonDecode(views.body)[o]["useremail"],
//                 servicename: jsonDecode(views.body)[o]["name"],
//                 servicedesc: jsonDecode(views.body)[o]["desription"],
//                 serviceprice: jsonDecode(views.body)[o]["price"],
//                 paymentoption: jsonDecode(views.body)[o]["paymentoption"],
//                 serviceimage: jsonDecode(serviceimage.body) ));
//             showservice = true;
//           });
//
//         }
//
//       }
//     }
//   }
//
//   Future viewservice() async{
//
//     if(widget.pagenumber == 0){
//
//       setState((){
//         showservice = false;
//       });
//
//       servicelist.clear();
//       print("Print services");
//
//       final views = await http.post(Uri.https('adeoropelumi.com','vendor/vendorviewservice.php'),body: {
//         'users':widget.useremail
//       });
//
//       if(views.statusCode == 200){
//
//         rawservice = jsonDecode(views.body);
//         print(rawservice!.length);
//         print(jsonDecode(views.body));
//         for(int o = 0; o < rawservice!.length; o++){
//
//           print(jsonDecode(views.body)[o]["idname"]);
//           print(jsonDecode(views.body)[o]["sidname"]);
//           print(jsonDecode(views.body)[o]["useremail"]);
//           print(jsonDecode(views.body)[o]["name"]);
//           print(jsonDecode(views.body)[o]["desription"]);
//           print(jsonDecode(views.body)[o]["price"]);
//           print(jsonDecode(views.body)[o]["paymentoption"]);
//
//
//           final serviceimage = await http.post(Uri.https('adeoropelumi.com','vendor/vendorserviceimageone.php'),body: {
//             'sidname': jsonDecode(views.body)[o]["sidname"]
//           });
//
//           if(serviceimage.statusCode == 200){
//
//             print(jsonDecode(serviceimage.body));
//
//             servicelist.add(Service(idname: jsonDecode(views.body)[o]["idname"],
//                 sidname: jsonDecode(views.body)[o]["sidname"],
//                 useremail: jsonDecode(views.body)[o]["useremail"],
//                 servicename: jsonDecode(views.body)[o]["name"],
//                 servicedesc: jsonDecode(views.body)[o]["desription"],
//                 serviceprice: jsonDecode(views.body)[o]["price"],
//                 paymentoption: jsonDecode(views.body)[o]["paymentoption"],
//                 serviceimage: jsonDecode(serviceimage.body) ));
//
//             setState((){
//               showservice = true;
//             });
//
//           }
//
//         }
//       }
//     }else{
//       setState(() {
//         showservice = true;
//       });
//     }
//   }
//
//   void totalsumofitem(){
//     totalsum = 0;
//     for( int i = 0; i <cartitems.length; i++ ){
//       totalsum += (cartitems[i].amount * cartitems[i].quantity);
//     }
//   }
//
//   void newtotalsum(){
//     totalsum = 0;
//     for( int i = 0; i <cartitems.length; i++ ){
//       totalsum += (cartitems[i].amount * cartitems[i].quantity);
//     }
//   }
//
//   void newtotalsumplusdelivery(){
//     totalsumplusdelivery = 0;
//     deliverysum = 0;
//     for( int i = 0; i <cartitems.length; i++ ){
//       deliverysum += ((cartitems[i].amount * cartitems[i].quantity)+ cartitems[i].deliveryprice);
//       totalsumplusdelivery = deliverysum ;
//     }
//   }
//
//   void starttotalsumplusdelivery(){
//     totalsumplusdelivery = 0;
//     deliverysum = 0;
//     for( int i = 0; i <cartitems.length; i++ ){
//       deliverysum += ((cartitems[i].amount * cartitems[i].quantity)+ cartitems[i].deliveryprice);
//       totalsumplusdelivery = deliverysum ;
//     }
//   }
//
//   String modify(String word) {
//     word = word.replaceAll("{(L!I_0)}", "'");
//     word = word.replaceAll(r'\', r'\\');
//     return word;
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     totalsumofitem();
//     starttotalsumplusdelivery();
//
//
//     _selectedIndex = widget.pagenumber;
//
//     viewproduct();
//     viewservice();
//
//     print(widget.idname);
//     print(widget.useremail);
//     print(widget.packagename);
//     print(widget.usertype);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, designSize: const Size(360, 712));
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.white
//         ),
//         child: Column(
//           children: [
//             if(_selectedIndex == 0)...[
//               SafeArea(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(217, 217, 217, .5),
//                   ),
//                   padding: EdgeInsets.only(top: 10, bottom: 10),
//                   child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text("Welcome, "+widget.useremail,style: TextStyle(
//                               fontSize: 15.sp
//                             ),),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(right: 10),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: MediaQuery.of(context).size.width/14,
//                                   child: Image.asset("assets/bells.png"),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                   child: Image.asset("assets/face.png"),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                 ),
//               ),
//               if(itemselected == 0)...[
//                 Container(
//                   padding: EdgeInsets.only(top: 15,left: 10,right: 10,bottom: 10),
//                   child: TextField(
//                       controller: _Controller,
//                       decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.search,color: Colors.black,),
//                           hintText: 'I am looking for ...',
//                           suffixIcon: Icon(Icons.filter_alt_outlined,color: Colors.black,),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20)
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20)
//                           )
//                       ),
//                       onChanged: (value){
//                         setState((){
//                           // listItemSearch = listItems.where((element) => element.name.
//                           // toLowerCase()
//                           //     .contains(value.toLowerCase())
//                           // ).toList();
//                           // if(_Controller!.text.isNotEmpty && listItemSearch!.isNotEmpty){
//                           //   print('itemsListSearch lenght ${listItemSearch!.length}');
//                           // }
//                           productlistserch = productlist.where((element) => element.productname.
//                           toLowerCase()
//                               .contains(value.toLowerCase())
//                           ).cast<Products>().toList();
//                           if(_Controller!.text.isNotEmpty && productlistserch!.isNotEmpty){
//                             print('itemsListSearch lenght ${productlistserch!.length}');
//                           }
//                         });
//                       }
//                   ),
//                 ),
//               ]else if(itemselected == 1)...[
//                 Container(
//                   padding: EdgeInsets.only(top: 15,left: 10,right: 10,bottom: 10),
//                   child: TextField(
//                       controller: _serviceController,
//                       decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.search,color: Colors.black,),
//                           hintText: 'I am looking for ...',
//                           suffixIcon: Icon(Icons.filter_alt_outlined,color: Colors.black,),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20)
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20)
//                           )
//                       ),
//                       onChanged: (value){
//                         setState((){
//                           // listItemSearch = listItems.where((element) => element.name.
//                           // toLowerCase()
//                           //     .contains(value.toLowerCase())
//                           // ).toList();
//                           // if(_Controller!.text.isNotEmpty && listItemSearch!.isNotEmpty){
//                           //   print('itemsListSearch lenght ${listItemSearch!.length}');
//                           // }
//                           servicelistserch = servicelist.where((element) => element.servicename.
//                           toLowerCase()
//                               .contains(value.toLowerCase())
//                           ).cast<Service>().toList();
//                           if(_serviceController!.text.isNotEmpty && servicelistserch!.isNotEmpty){
//                             print('itemsListSearch lenght ${servicelistserch!.length}');
//                           }
//                         });
//                       }
//                   ),
//                 ),
//               ],
//
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: (){
//                           setState(() {
//                             itemselected = 1;
//                           });
//                         },
//                         child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 10),
//                             margin: EdgeInsets.only(bottom: 5),
//                             decoration: BoxDecoration(
//                                 color: itemselected == 1 ? Colors.green : Colors.white,
//                                 borderRadius: BorderRadius.circular(10)
//                             ),
//                             child: Center(child: Text("Services",
//                               style: TextStyle(
//                                   color: itemselected == 1 ? Colors.white : Colors.black
//                               ),))
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         child: GestureDetector(
//                       onTap: (){
//                         setState(() {
//                           itemselected = 0;
//                         });
//                       },
//                       child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 10),
//                           margin: EdgeInsets.only(bottom: 5),
//                           decoration: BoxDecoration(
//                               color: itemselected == 0 ? Colors.green : Colors.white,
//                             borderRadius: BorderRadius.circular(10)
//                           ),
//                           child: Center(child: Text("Products",style: TextStyle(
//                             color: itemselected == 0 ? Colors.white : Colors.black
//                           ),))
//                       ),
//                     )
//                     ),
//                   ],
//                 ),
//               ),
//
//               if(itemselected == 0)...[
//
//                 showproducts == true
//
//                     ?
//
//                 Flexible(
//                   child:_Controller!.text.isNotEmpty && productlistserch!.isEmpty
//
//                       ?
//
//                   ListView(
//                     children: [
//                       Center(
//                           child: Padding (
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                   children : [
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Image.asset("assets/search.png",width: MediaQuery.of(context).size.width/2,),
//                                     ),
//                                     Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Text("No results to show", textAlign: TextAlign.center, style: TextStyle(
//                                             fontSize:26, fontWeight: FontWeight.w600
//                                         ))
//                                     ),
//                                     Padding(padding: EdgeInsets.all(8.0),
//                                       child: Text("Please check spelling or use different keywords",textAlign: TextAlign.center,),)
//                                   ]
//                               )
//                           )
//                       )
//                     ],
//                   )
//
//                       :
//
//                   Container(
//                     margin: EdgeInsets.only(left: 10,right: 10),
//                     child: _Controller!.text.isNotEmpty && productlistserch!.length > 0
//
//                         ?
//
//                     ListView.builder(
//                         padding: EdgeInsets.only(top: 15),
//                         itemCount: _Controller!.text.isNotEmpty
//                             ? productlistserch!.length
//                             : productlist.length,
//                         itemBuilder:(ctx, index){
//                           return GestureDetector(
//                             onTap: (){
//                               print(index);
//                               Navigator.push(context, MaterialPageRoute(builder: (context){
//                                 return ViewProduct(name: _Controller!.text.isNotEmpty
//                                     ? productlistserch![index].productname
//                                     : productlist[index].productname,amount: _Controller!.text.isNotEmpty
//                                     ? productlistserch![index].productprice
//                                     : productlist[index].productprice,
//                                   imagename: _Controller!.text.isNotEmpty
//                                       ? productlistserch![index].productimage
//                                       : productlist[index].productimage,
//                                 description: _Controller!.text.isNotEmpty
//                                     ? productlistserch![index].productdesc
//                                     : productlist[index].productdesc,
//                                 idname: widget.idname,useremail: widget.useremail,
//                                 usertype: widget.usertype,packagename: widget.packagename,
//                                 prodid: _Controller!.text.isNotEmpty
//                                     ? productlistserch![index].pidname
//                                     : productlist[index].pidname,
//                                 adminemail: _Controller!.text.isNotEmpty
//                                     ? productlistserch![index].useremail
//                                     : productlist[index].useremail,
//                                 deliveryprice: _Controller!.text.isNotEmpty
//                                     ? double.parse(productlistserch![index].productdeliveryprice)
//                                     : double.parse(productlist[index].productdeliveryprice),
//                                 location: _Controller!.text.isNotEmpty
//                                     ? productlistserch![index].location
//                                     : productlist[index].location,);
//                               }));
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white
//                               ),
//                               margin: EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     margin: EdgeInsets.only(left: 10),
//                                     width: 50,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                         color: Colors.grey
//                                     ),
//                                     child: Image.network("https://adeoropelumi.com/vendor/productimage/"+productlistserch![index].productimage,),
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       margin: EdgeInsets.only(left: 10),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             child: Text(_Controller!.text.isNotEmpty
//                                                 ? productlistserch![index].productname
//                                                 : productlist[index].productname),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(top: 5),
//                                             child: Text("Vendorhirve360",style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 13,
//                                                 fontStyle: FontStyle.italic
//                                             ),),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           child: Text(_Controller!.text.isNotEmpty
//                                               ? "₦"+productlistserch![index].productprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
//                                               : "₦"+productlist[index].productprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),),
//                                         ),
//                                         Container(
//                                           child: Text(_Controller!.text.isNotEmpty
//                                               ? productlistserch![index].paymentoption
//                                               :productlist![index].paymentoption,
//                                             style: TextStyle(
//                                                 fontSize: 12
//                                             ),),
//                                         )
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         })
//
//                         :
//
//                     RefreshIndicator(
//                       onRefresh: _refresh,
//                       child: GridView.builder(
//                           padding: EdgeInsets.only(top: 10),
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio : 2/3,
//                             crossAxisSpacing: 10,
//                           ),
//                           itemCount: _Controller!.text.isNotEmpty
//                               ? productlistserch!.length
//                               : productlist.length,
//                           itemBuilder: (ctx, index){
//                             return GestureDetector(
//                               onTap: (){
//                                 print(index);
//                                 Navigator.push(context, MaterialPageRoute(builder: (context){
//                                   return ViewProduct(name: _Controller!.text.isNotEmpty
//                                       ? productlistserch![index].productname
//                                       : productlist[index].productname,amount: _Controller!.text.isNotEmpty
//                                       ? productlistserch![index].productprice
//                                       : productlist[index].productprice,
//                                     imagename: _Controller!.text.isNotEmpty
//                                         ? productlistserch![index].productimage
//                                         : productlist[index].productimage,
//                                     description: _Controller!.text.isNotEmpty
//                                         ? productlistserch![index].productdesc
//                                         : productlist[index].productdesc,
//                                     idname: widget.idname,useremail: widget.useremail,
//                                     usertype: widget.usertype,packagename: widget.packagename,
//                                     prodid: _Controller!.text.isNotEmpty
//                                         ? productlistserch![index].pidname
//                                         : productlist[index].pidname,
//                                   adminemail: _Controller!.text.isNotEmpty
//                                       ? productlistserch![index].useremail
//                                       : productlist[index].useremail,
//                                     deliveryprice: _Controller!.text.isNotEmpty
//                                         ? double.parse(productlistserch![index].productdeliveryprice)
//                                         : double.parse(productlist[index].productdeliveryprice),
//                                     location: _Controller!.text.isNotEmpty
//                                         ? productlistserch![index].location
//                                         : productlist[index].location,);
//                                 }));
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(bottom: 10,),
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey,
//                                     borderRadius: BorderRadius.circular(10)
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding:EdgeInsets.only(top: 0,bottom: 10),
//                                       child: LayoutBuilder(
//                                           builder: (BuildContext context, BoxConstraints constraints) {
//                                             return Center(
//                                                 child: _Controller!.text.isNotEmpty
//                                                     ?
//                                                 Image.network("https://adeoropelumi.com/vendor/productimage/"+productlistserch![index].productimage,width: constraints.maxWidth/2,)
//                                                     :
//                                                 Image.network("https://adeoropelumi.com/vendor/productimage/"+productlist[index].productimage,width: constraints.maxWidth/2,)
//                                             );
//                                           }
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.only(left: 5,top: 5),
//                                       child: Text(_Controller!.text.isNotEmpty
//                                           ? productlistserch![index].productname
//                                           : productlist[index].productname,style: TextStyle(
//                                           color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16
//                                       ),),
//                                     ),
//                                     Flexible(
//                                       child: Container(
//                                         padding: EdgeInsets.only(left: 5,top: 5),
//                                         child: Text(_Controller!.text.isNotEmpty
//                                             ? "₦"+productlistserch![index].productprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
//                                             : "₦"+productlist[index].productprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
//                                             color: Colors.white
//                                         ),),
//                                       ),
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//                       ),
//                     ),
//                   ),
//
//
//                 )
//
//                     :
//
//                 Flexible(
//                   child: SafeArea(
//                     child: Container(
//                       child: Center(
//                         child: Text('loading...',
//                           style: TextStyle(
//                               fontStyle: FontStyle.italic,
//                               fontSize: 14
//                           ),),
//                       ),
//                     ),
//                   ),
//                 ),
//
//               ]else if(itemselected == 1)...[
//                 showservice == true
//
//                     ?
//
//                 Flexible(
//                   child:_serviceController!.text.isNotEmpty && servicelistserch!.isEmpty
//
//                       ?
//
//                   ListView(
//                     children: [
//                       Center(
//                           child: Padding (
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                   children : [
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Image.asset("assets/search.png",width: MediaQuery.of(context).size.width/2,),
//                                     ),
//                                     Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Text("No results to show", textAlign: TextAlign.center, style: TextStyle(
//                                             fontSize:26, fontWeight: FontWeight.w600
//                                         ))
//                                     ),
//                                     Padding(padding: EdgeInsets.all(8.0),
//                                       child: Text("Please check spelling or use different keywords",textAlign: TextAlign.center,),)
//                                   ]
//                               )
//                           )
//                       )
//                     ],
//                   )
//
//                       :
//
//                   Container(
//                     margin: EdgeInsets.only(left: 10,right: 10),
//                     child: _serviceController!.text.isNotEmpty && servicelistserch!.length > 0
//
//                         ?
//
//                     ListView.builder(
//                         padding: EdgeInsets.only(top: 15),
//                         itemCount: _serviceController!.text.isNotEmpty
//                             ? servicelistserch!.length
//                             : servicelist.length,
//                         itemBuilder:(ctx, index){
//                           return GestureDetector(
//                             onTap: (){
//                               print(index);
//                               Navigator.push(context, MaterialPageRoute(builder: (context){
//                                 return ViewService(name: _serviceController!.text.isNotEmpty
//                                     ? servicelistserch![index].servicename
//                                     : servicelist[index].servicename,
//                                   amount: _serviceController!.text.isNotEmpty
//                                     ? servicelistserch![index].serviceprice
//                                     : servicelist[index].serviceprice,
//                                   imagename: _serviceController!.text.isNotEmpty
//                                       ? servicelistserch![index].serviceimage
//                                       : servicelist[index].serviceimage,
//                                 description: _serviceController!.text.isNotEmpty
//                                     ? servicelistserch![index].servicedesc
//                                     : servicelist[index].servicedesc,
//                                   idname: widget.idname,useremail: widget.useremail,
//                                   usertype: widget.usertype,packagename: widget.packagename,
//                                 serviceid: _serviceController!.text.isNotEmpty
//                                     ? servicelistserch![index].sidname
//                                     : servicelist[index].sidname,
//                                 adminemail: _serviceController!.text.isNotEmpty
//                                     ? servicelistserch![index].useremail
//                                     : servicelist[index].useremail,);
//                               }));
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white
//                               ),
//                               margin: EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     margin: EdgeInsets.only(left: 10),
//                                     width: 50,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                         color: Colors.grey
//                                     ),
//                                     child: Image.network("https://adeoropelumi.com/vendor/serviceimage/"+servicelistserch![index].serviceimage,),
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       margin: EdgeInsets.only(left: 10),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             child: Text(_serviceController!.text.isNotEmpty
//                                                 ? servicelistserch![index].servicename
//                                                 : servicelist[index].servicename),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(top: 5),
//                                             child: Text("Vendorhirve360",style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 13,
//                                                 fontStyle: FontStyle.italic
//                                             ),),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           child: Text(_serviceController!.text.isNotEmpty
//                                               ? "₦"+servicelistserch![index].serviceprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
//                                               : "₦"+servicelist[index].serviceprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),),
//                                         ),
//
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         })
//
//                         :
//
//                     RefreshIndicator(
//                       onRefresh: _refreshservice,
//                       child: GridView.builder(
//                           padding: EdgeInsets.only(top: 10),
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio : 2/3,
//                             crossAxisSpacing: 10,
//                           ),
//                           itemCount: _serviceController!.text.isNotEmpty
//                               ? servicelistserch!.length
//                               : servicelist.length,
//                           itemBuilder: (ctx, index){
//                             return GestureDetector(
//                               onTap: (){
//                                 print(index);
//                                 Navigator.push(context, MaterialPageRoute(builder: (context){
//                                   return ViewService(name: _serviceController!.text.isNotEmpty
//                                       ? servicelistserch![index].servicename
//                                       : servicelist[index].servicename,
//                                     amount: _serviceController!.text.isNotEmpty
//                                       ? servicelistserch![index].serviceprice
//                                       : servicelist[index].serviceprice,
//                                     imagename: _serviceController!.text.isNotEmpty
//                                         ? servicelistserch![index].serviceimage
//                                         : servicelist[index].serviceimage,
//                                   description: _serviceController!.text.isNotEmpty
//                                       ? servicelistserch![index].servicedesc
//                                       : servicelist[index].servicedesc,
//                                     idname: widget.idname,
//                                     useremail: widget.useremail,
//                                     usertype: widget.usertype,
//                                     packagename: widget.packagename,
//                                     serviceid: _serviceController!.text.isNotEmpty
//                                         ? servicelistserch![index].sidname
//                                         : servicelist[index].sidname,
//                                   adminemail: _serviceController!.text.isNotEmpty
//                                       ? servicelistserch![index].useremail
//                                       : servicelist[index].useremail,);
//                                 }));
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(bottom: 10,),
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey,
//                                     borderRadius: BorderRadius.circular(10)
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding:EdgeInsets.only(top: 0,bottom: 10),
//                                       child: LayoutBuilder(
//                                           builder: (BuildContext context, BoxConstraints constraints) {
//                                             return Center(
//                                                 child: _serviceController!.text.isNotEmpty
//                                                     ?
//                                                 Image.network("https://adeoropelumi.com/vendor/serviceimage/"+servicelistserch![index].serviceimage,width: constraints.maxWidth/2,)
//                                                     :
//                                                 Image.network("https://adeoropelumi.com/vendor/serviceimage/"+servicelist[index].serviceimage,width: constraints.maxWidth/2,)
//                                             );
//                                           }
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.only(left: 5,top: 5),
//                                       child: Text(_serviceController!.text.isNotEmpty
//                                           ? servicelistserch![index].servicename
//                                           : servicelist[index].servicename,style: TextStyle(
//                                           color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16
//                                       ),),
//                                     ),
//                                     Flexible(
//                                       child: Container(
//                                         padding: EdgeInsets.only(left: 5,top: 5),
//                                         child: Text(_serviceController!.text.isNotEmpty
//                                             ? "₦"+servicelistserch![index].serviceprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
//                                             : "₦"+servicelist[index].serviceprice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
//                                             color: Colors.white
//                                         ),),
//                                       ),
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//                       ),
//                     ),
//                   ),
//
//
//                 )
//
//                     :
//
//                 Flexible(
//                   child: SafeArea(
//                     child: Container(
//                       child: Center(
//                         child: Text('loading...',
//                           style: TextStyle(
//                               fontStyle: FontStyle.italic,
//                               fontSize: 14
//                           ),),
//                       ),
//                     ),
//                   ),
//                 ),
//               ]
//
//
//             ]else if(_selectedIndex == 2)...[
//               //cart
//               Flexible(
//                   child: SafeArea(
//                     child: Container(
//                       margin: EdgeInsets.only(top: 30),
//                       child: CustomScrollView(
//                       slivers:[
//                         SliverList(
//                             delegate: SliverChildBuilderDelegate(
//                                     (BuildContext context, int index) {
//
//                                   return cartitems.length < 1
//                                       ?
//                                   Container(
//                                     width: MediaQuery.of(context).size.width/4,
//                                     height: MediaQuery.of(context).size.width/4,
//                                     child: Image.asset("assets/emptycart.png")
//                                   )
//                                   :
//                                       Container()
//                                   ;
//                                 },
//                                 childCount: 1
//                             )
//                         ),
//                         SliverList(
//                             delegate: SliverChildBuilderDelegate(
//                             (BuildContext context, int index) {
//                               double finalquantity = cartitems[index].quantity * cartitems[index].amount;
//
//                               return Container(
//                                 margin: EdgeInsets.only(left: 10,right: 10,bottom: 15,),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       child: Image.network("https://adeoropelumi.com/vendor/productimage/"+cartitems[index].imagename,),
//                                       width: MediaQuery.of(context).size.width/8,
//                                       height: MediaQuery.of(context).size.width/8,
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                         margin: EdgeInsets.only(left: 10),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               child: Text(cartitems[index].name,style: TextStyle(
//                                                   fontSize: 17,
//                                                   fontWeight: FontWeight.w500
//                                               ),),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Container(
//                                               child: Text("Solid Fiction",style: TextStyle(
//                                                 color: Colors.grey,
//
//                                               ),),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Container(
//                                               child: Text(
//                                                 "N"+"$finalquantity".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontWeight: FontWeight.w500
//                                               ),),
//                                             ),
//                                             SizedBox(height: 2,),
//                                             Container(
//                                               child: Text("N3,500 per unit",style: TextStyle(
//                                                   color: Colors.grey
//                                               ),),
//                                             )
//
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       child:Column(
//                                         children: [
//                                           Container(
//                                             decoration: BoxDecoration(
//                                                 border: Border.all(),
//                                                 borderRadius: BorderRadius.circular(5)
//                                             ),
//                                             child: Row(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap:(){
//                                                     setState(() {
//                                                       cartitems[index].quantity--;
//
//                                                       if(cartitems[index].quantity == 0){
//                                                         cartitems[index].quantity = 1;
//                                                       }
//
//                                                       newtotalsum();
//                                                       newtotalsumplusdelivery();
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     padding: EdgeInsets.only(left: 5,right: 15),
//                                                     child: Icon(Icons.remove),),
//                                                 ),
//                                                 Container(
//                                                   child: Text("${cartitems[index].quantity}"),
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap:(){
//                                                     setState(() {
//
//                                                       cartitems[index].quantity++;
//                                                       newtotalsum();
//                                                       newtotalsumplusdelivery();
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     padding: EdgeInsets.only(left: 15,right: 5),
//                                                     child: Icon(Icons.add),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           GestureDetector(
//                                             onTap: (){
//                                               setState(() {
//                                                 cartitems.removeWhere((i) =>
//                                                 i.id ==
//                                                     cartitems[index].id);
//
//                                                 newtotalsum();
//                                                 newtotalsumplusdelivery();
//                                               });
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(),
//                                                   borderRadius: BorderRadius.circular(5)
//                                               ),
//                                               margin:EdgeInsets.only(top: 10),
//                                               padding: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 2),
//                                               child: Text("Remove"),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             },
//                               childCount: cartitems.length
//                           )
//                         ),
//                         SliverList(
//                             delegate: SliverChildBuilderDelegate(
//                               (context, index) {
//                                 return Container(
//                                   margin: EdgeInsets.only(left: 10,right: 10,top: 20),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         margin: EdgeInsets.only(bottom: 15),
//                                         decoration: BoxDecoration(
//                                             color: Color.fromRGBO(238, 252, 233, 1),
//                                             borderRadius: BorderRadius.circular(20)
//                                         ),
//
//                                         child: DottedBorder(
//                                           // decoration: BoxDecoration(
//                                           //   color: Color.fromRGBO(238, 252, 233, 1),
//                                           //   borderRadius: BorderRadius.circular(20)
//                                           // ),
//                                           borderType: BorderType.RRect,
//                                           radius: Radius.circular(20),
//                                           padding: EdgeInsets.only(bottom: 15,top: 15),
//                                           color: Colors.black26,
//                                           // margin: EdgeInsets.only(left: 20,right: 20),
//                                           child: ClipRRect(
//                                             // borderRadius: BorderRadius.all(Radius.circular(20)),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   child: Container(
//                                                     margin: EdgeInsets.only(left: 15),
//                                                     child: Text("Coupon Code",style: TextStyle(
//                                                         color: Colors.black26,
//                                                         fontSize: 17
//                                                     ),),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                       color: Color.fromRGBO(14, 44, 3, 1),
//                                                       borderRadius: BorderRadius.circular(20)
//                                                   ),
//                                                   padding: EdgeInsets.only(top: 10,right: 15,left: 15,bottom: 10),
//                                                   margin: EdgeInsets.only(right: 10),
//                                                   child: Text("Apply",style: TextStyle(
//                                                     color: Colors.white
//                                                   ),),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         margin:EdgeInsets.only(bottom: 10),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                               child: Text("Subtotal",style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 12
//                                               ),),
//                                             ),
//                                             Container(
//                                               child: Text("N"+"${totalsum}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 12
//                                               ),),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: EdgeInsets.only(bottom: 10),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                               child: Text("Delivery",style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 12
//                                               ),),
//                                             ),
//                                             Container(
//                                               child: Text("Enter Shipping Address ",style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 12,
//                                                 decoration: TextDecoration.underline
//                                               ),),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: EdgeInsets.only(bottom: 15),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                               child: Text("Total",style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 12,
//                                                 fontWeight: FontWeight.w500
//                                               ),),
//                                             ),
//                                             Container(
//                                               child: Text("N"+"${totalsumplusdelivery}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 12,
//                                                 fontWeight: FontWeight.w500
//                                               ),),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap: (){
//                                           setState(() {
//                                             cartitems.clear();
//                                             newtotalsum();
//                                             newtotalsumplusdelivery();
//                                             ScaffoldMessenger.of(this.context).showSnackBar(
//                                                 SnackBar(
//                                                   content: Text('You emptied cart!'),
//                                                 ));
//                                           });
//                                         },
//                                         child: Container(
//                                           margin: EdgeInsets.only(bottom: 10),
//                                           padding: EdgeInsets.symmetric(vertical: 15),
//                                           decoration: BoxDecoration(
//                                             color: Color.fromRGBO(14, 44, 3, 1),
//                                             borderRadius: BorderRadius.circular(10)
//                                           ),
//                                           child: Center(
//                                             child: Text("Empty Cart",style: TextStyle(
//                                               color: Colors.white
//                                             ),),
//                                           ),
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap:(){
//                                           if(cartitems.length < 1){
//                                             ScaffoldMessenger.of(this.context).showSnackBar(
//                                                 SnackBar(
//                                                   content: Text('Cart is empty'),
//                                                 ));
//                                           }else{
//                                             Navigator.push(context, MaterialPageRoute(builder: (context){
//                                               return Checkout(totalamount: totalsum,totalamountplusdelivery: totalsumplusdelivery,
//                                                 useremail: widget.useremail,idname: widget.idname,);
//                                             }));
//                                           }
//                                         },
//                                         child: Container(
//                                           margin: EdgeInsets.only(bottom: 10),
//                                           padding: EdgeInsets.symmetric(vertical: 15),
//                                           decoration: BoxDecoration(
//                                               color: Color.fromRGBO(246, 123, 55, 1),
//                                               borderRadius: BorderRadius.circular(10)
//                                           ),
//                                           child: Center(
//                                             child: Text("Proceed to Checkout",style: TextStyle(
//                                                 color: Colors.black
//                                             ),),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               },
//                               childCount: 1,
//                             )
//                         )
//                       ]
//               ),
//                     ),
//                   )
//               )
//
//             ]else if(_selectedIndex == 3)...[
//               SafeArea(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(217, 217, 217, .5),
//                   ),
//                   padding: EdgeInsets.only(top: 10, bottom: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: (){
//                           setState(() {
//                             _selectedIndex = 0;
//                           });
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(left: 10),
//                           child: Text("Back",style: TextStyle(
//                               fontSize: 15.sp
//                           ),),
//                         ),
//                       ),
//                       Container(
//                         child: Text("Messages"),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(right: 10),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width/14,
//                               child: Image.asset("assets/bells.png"),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(
//                               child: Image.asset("assets/face.png"),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Flexible(
//                   child:
//               ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   //messages
//                   showcontactlist
//
//                       ?
//
//                   ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: appcontactlist.length,
//                       padding: EdgeInsets.zero,
//                       itemBuilder: (context,index){
//                         return GestureDetector(
//                           onTap: (){
//                             setState(() {
//                               unreadmsgscust[index] = "0";
//                             });
//                             Navigator.push(context, MaterialPageRoute(builder: (context){
//                               return ServiceMsg(adminemail:adminemaillist[index],
//                                   servicename:servicenamelist[index],
//                                   serviceid:appcontactlist[index],
//                                   useremail: widget.useremail,
//                                   idname: widget.idname,
//                                   usertype: widget.usertype);
//                             }));
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(top: 10),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       margin: EdgeInsets.only(left: 10),
//                                       child: CircleAvatar(
//                                         backgroundColor:
//                                         Color.fromRGBO(217, 217, 217, 1),
//                                         radius: 30,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.white
//                                         ),
//                                         margin: EdgeInsets.only(left: 10),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               margin: EdgeInsets.only(bottom: 5),
//                                               child: Text(
//                                                 servicenamelist[index],
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.w500),
//                                               ),
//                                             ),
//                                             Container(
//                                               child: lastmsg[index].contains("https://adeoropelumi.com/vendor/chatsimg/")?
//                                               Container(
//                                                 child: Icon(Icons.image),
//                                               ):
//                                               Text(
//                                                 modify(lastmsg[index]),
//                                                 style: TextStyle(fontSize: 12),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     unreadmsgscust[index] == "0"
//                                         ?
//                                     Container()
//                                         :
//                                     Container(
//                                       margin: EdgeInsets.only(right: 10, left: 5),
//                                       child: CircleAvatar(
//                                         radius: 15,
//                                         backgroundColor:
//                                         Color.fromRGBO(243, 207, 198, 1),
//                                         child: Text(
//                                           unreadmsgscust[index],
//                                           style: TextStyle(color: Colors.black),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 GestureDetector(
//                                   onTap: (){
//                                     print("pay vendor");
//                                     Navigator.push(context, MaterialPageRoute(builder: (context){
//                                       return PayforService(idname: widget.idname,
//                                           sidname: appcontactlist[index],
//                                           useremail: widget.useremail,
//                                           adminemail: adminemaillist[index],
//                                           servicename: servicenamelist[index],);
//                                     }));
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: Colors.orangeAccent
//                                         ),
//                                         color: Colors.green
//                                     ),
//                                     padding: EdgeInsets.symmetric(vertical: 10),
//                                     margin: EdgeInsets.only(top: 3),
//                                     child: Row(
//                                       children: [
//                                         Expanded(child: Text("Pay Vendor",textAlign: TextAlign.center,style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold
//                                         ),))
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Divider(),
//                               ],
//                             ),
//                           ),
//                         );
//                       })
//
//                       :
//
//                   Container(
//                     margin: EdgeInsets.only(top: 20),
//                     child: Center(
//                       child: Text("loading...",style: TextStyle(
//                           fontStyle: FontStyle.italic,
//                           fontSize: 14
//                       ),),
//                     ),
//                   )
//                 ],
//               )
//               )
//             ]else if(_selectedIndex == 4)...[
//               Container(
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(217, 217, 217, .5),
//                 ),
//                 padding: EdgeInsets.only(top: 10, bottom: 10),
//                 child: SafeArea(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 10),
//                           child: Text("Profile"),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(right: 10),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width/14,
//                                 child: Image.asset("assets/bells.png"),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Container(
//                                 child: Image.asset("assets/face.png"),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     )),
//               ),
//               Flexible(child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return Editprofile();
//                       }));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: 10,top: 10),
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.grey,
//                                   width: .5
//                               )
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width/8,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Image.asset("assets/editingprofile.png",color: Color.fromRGBO(246, 123, 55, 1)),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 15),
//                             child: Text("Edit Profile",style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return ActiveProductOrders(useremail: widget.useremail, idname: widget.idname,);
//                       }));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: 10,top: 10),
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.grey,
//                                   width: .5
//                               )
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width/8,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Image.asset("assets/clipboard.png",color: Color.fromRGBO(246, 123, 55, 1),),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 15),
//                             child: Text("My Orders",style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return PaidServices(useremail: widget.useremail, idname: widget.idname,);
//                       }));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: 10,top: 10),
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.grey,
//                                   width: .5
//                               )
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width/8,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Image.asset("assets/services.png",color: Color.fromRGBO(246, 123, 55, 1),),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 15),
//                             child: Text("Paid Services",style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return Refers();
//                       }));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: 10,top: 10),
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.grey,
//                                   width: .5
//                               )
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width/8,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Image.asset("assets/people.png",),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 15),
//                             child: Text("Refer your friends",style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return Packages();
//                       }));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: 10,top: 10),
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.grey,
//                                   width: .5
//                               )
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width/8,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Image.asset("assets/businessupgrade.png",color: Color.fromRGBO(246, 123, 55, 1),),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 15),
//                             child: Text("Upgrade to Pro User",style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Container(
//                   //   padding: EdgeInsets.only(bottom: 10,top: 10),
//                   //   decoration: BoxDecoration(
//                   //       border: Border(
//                   //           bottom: BorderSide(
//                   //               color: Colors.grey,
//                   //               width: .5
//                   //           )
//                   //       )
//                   //   ),
//                   //   child: Row(
//                   //     children: [
//                   //       Container(
//                   //         margin: EdgeInsets.only(left: 10),
//                   //         child: Image.asset("assets/switch.png",color: Color.fromRGBO(246, 123, 55, 1),),
//                   //       ),
//                   //       Container(
//                   //         margin: EdgeInsets.only(left: 15),
//                   //         child: Text("Switch to Customer Profile",style: TextStyle(
//                   //             fontWeight: FontWeight.w500,
//                   //             fontSize: 16
//                   //         ),),
//                   //       )
//                   //     ],
//                   //   ),
//                   // ),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return ContactSupport(idname: widget.idname,mail: widget.useremail,);
//                       }));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: 10,top: 10),
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.grey,
//                                   width: .5
//                               )
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width/8,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Image.asset("assets/customer-support.png",color: Color.fromRGBO(246, 123, 55, 1),),
//                           ),
//                           Container(
//
//                             margin: EdgeInsets.only(left: 15),
//                             child: Text("Contact Support",style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return Settings();
//                       }));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: 10,top: 10),
//                       decoration: BoxDecoration(
//                           border: Border(
//                               bottom: BorderSide(
//                                   color: Colors.grey,
//                                   width: .5
//                               )
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width/8,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Image.asset("assets/setts.png",color: Color.fromRGBO(246, 123, 55, 1),),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(left: 15),
//                             child: Text("Settings",style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ))
//             ],
//
//             //bottom navigation
//             Container(
//               padding: EdgeInsets.only(bottom: 10,top: 5),
//               margin: EdgeInsets.only(left: 10,right: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: (){
//                       setState(() {
//                         _selectedIndex = 0;
//                       });
//                     },
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Container(child: Icon(Icons.home,size: 35,
//                           color: _selectedIndex == 0 ? Colors.black : Colors.grey,
//                           )),
//                           Container(
//                             child: Text("Home",style: TextStyle(
//                               fontSize: 10,
//                               color: _selectedIndex == 0 ? Colors.black : Colors.grey
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       setState(() {
//
//                       });
//                     },
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Container(child: Icon(Icons.account_balance_wallet_rounded,size: 35,
//                           color: _selectedIndex == 1 ? Colors.black : Colors.grey,
//                           )),
//                           Container(
//                             child: Text("Wallet",style: TextStyle(
//                                 fontSize: 10,
//                               color: _selectedIndex == 1 ? Colors.black : Colors.grey
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       setState(() {
//                         _selectedIndex = 2;
//                       });
//                     },
//                     child: CircleAvatar(
//                       radius: 23,
//                       backgroundColor: Color.fromRGBO(246, 123, 55, 1),
//                       child: Icon(Icons.shopping_cart,color: Colors.white,size: 30,)
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       chatcontact();
//                       setState(() {
//                         _selectedIndex = 3;
//                       });
//                     },
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Container(child: Icon(Icons.message,size: 35,
//                           color: _selectedIndex == 3 ? Colors.black : Colors.grey,
//                           )),
//                           Container(
//                             child: Text("Messages",style: TextStyle(
//                                 fontSize: 10,
//                               color: _selectedIndex == 3 ? Colors.black : Colors.grey
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       setState(() {
//                         _selectedIndex = 4;
//                       });
//                     },
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Container(child: Icon(Icons.person,size: 35,
//                           color: _selectedIndex == 4 ? Colors.black : Colors.grey,
//                           )),
//                           Container(
//                             child: Text("Profile",style: TextStyle(
//                                 fontSize: 10,
//                               color: _selectedIndex == 4 ? Colors.black : Colors.grey
//                             ),),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
