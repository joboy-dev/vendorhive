import 'package:flutter/material.dart';

class WelcomeUser extends StatefulWidget {
  const WelcomeUser({Key? key}) : super(key: key);

  @override
  _WelcomeUserState createState() => _WelcomeUserState();
}

class _WelcomeUserState extends State<WelcomeUser> {
  //list item
  List<String> itemsList = [
    'Arts',
    'Design',
    'Entertainment',
    'Sports',
    'Media',
    'Building',
    'Business',
    'Education',
    'Training',
    'Farming',
    'Fishing',
    'Food',
    'Healthcare',
    'Legal',
    'Management',
    'Office',
    'Production',
    'Sales',
    'Biostatistics',
    'Analysts',
    'Clinical',
    'Network',
    'System',
    'Computer',
    'Specialists',
    'Analysts',
    'Software',
    'Developers',
    'Testers',
    'Engineering',
    'Designers',
    'Web',
    'Developers',
    'Game'
  ];

  List<String>? itemsListSearch;

  TextEditingController _Controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SafeArea(
            child: Container(
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
                        child: Text("Welcome, Ciroma"),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset("assets/bell.png"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Image.asset("assets/face.png"),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15,left: 10,right: 10),
            child: TextField(
                controller: _Controller,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,color: Colors.black,),
                    hintText: 'I am looking for ...',
                    suffixIcon: Icon(Icons.filter_alt_outlined,color: Colors.black,),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                onChanged: (value){
                  setState((){
                    itemsListSearch = itemsList
                        .where((element) => element
                        .toLowerCase()
                        .contains(value.toLowerCase())
                    ).toList();
                    if(_Controller!.text.isNotEmpty && itemsListSearch!.isEmpty){
                      print('itemsListSearch lenght ${itemsListSearch!.length}');
                    }
                  });
                }
            ),
          ),
          Flexible(
              child:_Controller!.text.isNotEmpty && itemsListSearch!.isEmpty ? Center(
                  child: Padding (
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          children : [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.search_off,
                                size:160,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("No results found, \nPlease try different keyword", style: TextStyle(
                                    fontSize:30, fontWeight: FontWeight.w600
                                ))
                            ),
                          ]
                      )
                  )
              ) : ListView.builder(
                  itemCount: _Controller.text.isNotEmpty ? itemsListSearch!.length : itemsList.length,
                  itemBuilder: (ctx, index){
                    return Card(
                        margin: EdgeInsets.symmetric(vertical: 1),
                        child : ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                                Icons.work_outline,
                                color: Colors.white
                            ),
                          ),
                          title: Text(_Controller!.text.isNotEmpty ? itemsListSearch![index]
                              : itemsList[index]),
                        )
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}
