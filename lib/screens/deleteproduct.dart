import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/successdeleteproduct.dart';

import 'faileddelete.dart';

class DeleteProduct extends StatefulWidget {
  String pidname = "";
  String email = "";
  String productimg = "";
  String productPrice = "";
  String productdescription = "";

  DeleteProduct(
      {required this.pidname,
      required this.email,
      required this.productimg,
      required this.productPrice,
      required this.productdescription,
      Key? key})
      : super(key: key);

  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  int _loadIndex = 0;
  int _selectedItem = 0;

  Future delete_product() async {
    setState(() {
      _loadIndex = 1;
    });
    var response = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/delete_product.php'),
        body: {'pidname': widget.pidname});
    if(response.statusCode == 200){
      if(jsonDecode(response.body)=="true"){
        setState(() {
          _loadIndex = 0;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SuccessDeleteProduct();
        }));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return FailedDelete();
        }));
      }
    }
  }

  @override
  void initState() {
    print(widget.pidname);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _loadIndex == 0
          ? Column(
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
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Product Settings",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
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
                ]
                else if (_selectedItem == 1)...[
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
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
                          "https://adeoropelumi.com/vendor/productimage/" +
                              widget.productimg,
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
                ]
                else if(_selectedItem == 2)...[
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
                            child: Text("₦" +widget.productPrice.replaceAllMapped(
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
                    child: Text("₦" +widget.productdescription,style: TextStyle(
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
                          keyboardType: TextInputType.number,
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
                ],
              ],
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
