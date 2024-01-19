import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VendorProfile extends StatefulWidget {
  const VendorProfile({Key? key}) : super(key: key);

  @override
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
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

  @override
  void initState() {
    getvendors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: vendors.length > 0 ?GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 2/ 3),
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            return LayoutBuilder(builder: (context, constrainy) {
              return InkWell(
                onTap: () {
                  print(MediaQuery.of(context).size.width);
                  print(MediaQuery.of(context).size.height);
                  print(constrainy.maxWidth);
                  print(constrainy.maxHeight);
                },
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AspectRatio(
                          aspectRatio: 1/1,
                          child: FittedBox(
                            fit: BoxFit.cover,
                              child: Image.asset('assets/vendo.png'))),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 0.5),
                            decoration: BoxDecoration(),
                            child:  Text(
                              vendors[index]['fullname'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            )
                        ),
                      ),
                      Flexible(
                        child: Container(
                            padding: EdgeInsets.only(bottom: 0.5),
                            decoration: BoxDecoration(),
                            child:  Text(
                              vendors[index]['email'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            )
                        ),
                      ),
                      Flexible(
                        child: Container(
                            decoration: BoxDecoration(),
                            child:  Text(
                              vendors[index]['phonenumber'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            )
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
          })
      :
      Container(
        child: Center(
          child: SpinKitSpinningLines(
            color: Colors.orange,
            size: 90,
          ),
        ),
      ),
    );
  }
}
