import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vendorandroid/screens/payforservice.dart';
import 'package:vendorandroid/screens/servicemsgbubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class ServiceChatMessage{
  String message;
  MessageType type;
  String date;
  String time;
  ServiceChatMessage({required this.message,
    required this.type,
    required this.date,
    required this.time});
}

enum MessageType{
  Sender,
  Receiver,
}

class ServiceMsg extends StatefulWidget {
  String username = "";
  String useremail = "";
  String adminemail = "";
  String idname = "";
  String usertype = "";
  String serviceid = "";
  String servicename = "";
  String logo = "";
  String custname = "";

  ServiceMsg({
    required this.custname,
    required this.username,
    required this.useremail,
    required this.adminemail,
    required this.idname,
    required this.usertype,
  required this.serviceid,
    required this.logo,
  required this.servicename});

  @override
  _ServiceMsgState createState() => _ServiceMsgState();
}

class _ServiceMsgState extends State<ServiceMsg> {
  bool ActiveConnection = false;
  bool sendingdata = true;
  bool uploadingimage = false;
  int? addChat;
  int? secondaddChat;
  int sec =0;
  String filename = '';
  String textt = '';
  bool showchat = false;
  bool cancelTimer = false;

  List? chatdata;
  List? secondchatdata;
  List<ServiceChatMessage> messages = [];

  File? uploadimage;

  final ImagePicker _picker = ImagePicker();

  Future<void> chooseImage() async{
    var chooseImg = await _picker.pickImage(source: ImageSource.camera);
    setState((){
      uploadimage = File(chooseImg!.path);
      filename = chooseImg!.name;
    });
    print(filename);
  }

  Future<void> choosefile() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    final files = result.files; //EDIT: THIS PROBABLY CAUSED YOU AN ERROR
    textt = result.files.first.path.toString();
    filename = result.files.first.name;
    // filetype = result.files.first.extension!;
    // filesize = result.files.first.size.toString();
    uploadimage = File(textt);
  }

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          print('Internet connection');
          loadchats();
        });
      }
    } on SocketException catch (_) {
      setState(() {
        print('No Internet connection');
        ActiveConnection = false;
      });
    }
  }

  Future loadchats() async {
    setState(() {
      showchat = false;
    });
    final response = await http
        .post(Uri.https('adeoropelumi.com', 'vendor/vendorgetchatcustomer.php'), body: {
      'sidname':widget.serviceid,
      'user':widget.useremail,
      'admin':widget.adminemail
    });
    var responsBody = json.decode(response.body);

    chatdata = responsBody;
    addChat = chatdata?.length;
    print('Original Chat Lenght:- $addChat');
    for(int q =0; q<addChat!;q++){
      String users = responsBody[q]['4'].toString();
      String date = responsBody[q]['6'].toString();
      String time = responsBody[q]['7'].toString();
      DateTime date2 = DateTime.parse(date);
      DateTime date3 = DateTime.now();
      Duration difference = date3.difference(date2);
      int days = difference.inDays;
      String nameofday = "";
      print(days);
      String dateandtime = date+" ("+time+")";
      String reply = "";
      if(days==1){
        reply = 'yesterday';
        print(DateFormat('EEEE').format(date2));
        nameofday = DateFormat('EEEE').format(date2);
      }else if(days == 2){
        reply = DateFormat('EEEE').format(date2);
      }else if(days == 3){
        reply = DateFormat('EEEE').format(date2);
      }else if(days == 4){
        reply = DateFormat('EEEE').format(date2);
      }else if(days == 5){
        reply = DateFormat('EEEE').format(date2);
      }else if(days == 6){
        reply = DateFormat('EEEE').format(date2);
      }else{
        reply = date;
      }
      messages.add(ServiceChatMessage(message: modify(responsBody[q]['3'].toString()),
          type: users== 'customer' ?MessageType.Sender:MessageType.Receiver,
          date: date,time: days > 0 ? reply : time),);
    }

    setState(() {
      showchat = true;
      calltimer();
    });

  }

  Future sendimgmsg() async{
    print("processing sending image");
    setState(() {
      uploadingimage = true;
    });
    try{
      List<int> imageBytes = uploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      print(baseimage);

      var sendimg = await http.post(Uri.https('adeoropelumi.com','vendor/vendorsendimg.php'),body: {
        'idname':widget.idname,
        'useremail': widget.useremail,
        'adminemail':widget.adminemail,
        'usertype' : widget.usertype,
        'sidname': widget.serviceid,
        'servicename' : widget.servicename,
        'filename':filename,
        'img': baseimage,
      });

      var message_notify = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendornewmessagenotification.php'),
          body: {
            'name':widget.custname,
            'email':widget.adminemail,
            'message':"Photo was sent",
          });

      if(sendimg.statusCode == 200){
        print('upload almost done');
        if(jsonDecode(sendimg.body)=='true'){
          setState(() {
            calltimer();
            uploadingimage = false;
            uploadimage = null;
            print("Image is uploaded");
          });
        }
      }
    }catch(e){
      print("Error while uploading image "+e.toString());
    }
  }

  Future sendmsg() async{

    setState(() {
      sendingdata = false;
    });

    final sending = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorsendcustomerchat.php'),
        body: {
      'idname':widget.idname,
      'useremail': widget.useremail,
      'adminemail':widget.adminemail,
      'message': replacing(_messages.text),
      'usertype' : widget.usertype,
      'sidname': widget.serviceid,
      'servicename' : widget.servicename
    });

    var message_notify = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendornewmessagenotification.php'),
    body: {
      'name':widget.custname,
      'email':widget.adminemail,
      'message':_messages.text,
    });

    if(sending.statusCode == 200){
      if(jsonDecode(sending.body)=='true'){
        setState((){
          _messages.clear();
          sendingdata = true;
          print(sendingdata);
        });
      }else{
        print("Message not sent");
      }
    }else{
      print("Network Error");
    }

  }

  void showModal(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height/3,
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
                          margin: EdgeInsets.only(bottom: 10,top: 3),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 2
                                )
                            ),
                          ),
                          height:10,
                          width: MediaQuery.of(context).size.width/3,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {

                      });
                    },
                    child: Container(
                      child: Text("Add product",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                        ),),
                      margin: EdgeInsets.only(left: 25,top: 20),
                    ),
                  ),
                  Container(
                    child: Divider(height: 20,thickness: 2,),
                    margin: EdgeInsets.only(left: 20,right: 20),
                  ),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      child: Text("Add service",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                        ),),
                      margin: EdgeInsets.only(left: 25,top: 20),
                    ),
                  ),
                  Container(
                    child: Divider(height: 20,thickness: 2,),
                    margin: EdgeInsets.only(left: 20,right: 20),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5,top: 10),
                    child: Center(
                      child: Text("Vendorhive360",style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  void calltimer() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      sec++;
      if (mounted) {
        onthegochat();
      }
      if (cancelTimer) {
        timer.cancel();
        print(sec);
      }
    });
  }

  void stopcalltimer() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      timer.cancel();
      print(sec);
    });
  }

  Future onthegochat() async {

    final response = await http
        .post(Uri.https('adeoropelumi.com', 'vendor/vendorgetchatcustomer.php'), body: {
      'sidname':widget.serviceid,
      'user':widget.useremail,
      'admin':widget.adminemail
    });

    var responsBody = json.decode(response.body);
    secondchatdata = responsBody;
    // print(responsBody);
    secondaddChat = secondchatdata?.length;
    print('after 7 seconds Chat Lenght:- $secondaddChat');

    if (chatdata?.length == secondaddChat) {
      print('No new chat');
    } else {

      print('New Chat Lenght:- $secondaddChat');
      //Chat Message after 7 seconds
      print('chat after 7 seconds is printed');

      for(int? q = chatdata?.length; q! <secondaddChat!; q++){
        String users = responsBody[q]['4'].toString();
        String date = responsBody[q]['6'].toString();
        String time = responsBody[q]['7'].toString();
        DateTime date2 = DateTime.parse(date);
        DateTime date3 = DateTime.now();
        Duration difference = date3.difference(date2);
        int days = difference.inDays;
        String nameofday = "";
        print(days);
        String dateandtime = date+" ("+time+")";
        String reply = "";
        if(days==1){
          reply = 'yesterday';
          print(DateFormat('EEEE').format(date2));
          nameofday = DateFormat('EEEE').format(date2);
        }else if(days == 2){
          reply = DateFormat('EEEE').format(date2);
        }else if(days == 3){
          reply = DateFormat('EEEE').format(date2);
        }else if(days == 4){
          reply = DateFormat('EEEE').format(date2);
        }else if(days == 5){
          reply = DateFormat('EEEE').format(date2);
        }else if(days == 6){
          reply = DateFormat('EEEE').format(date2);
        }else{
          reply = date;
        }

        messages.add(ServiceChatMessage(message: modify(responsBody[q]['3'].toString()),
            type: users== 'customer' ?MessageType.Sender:MessageType.Receiver,
            date: date,
            time: days > 0 ? reply : time),);
      }

      //update new length of chatdata
      setState(() {
        chatdata = secondchatdata;
      });
    }

    setState(() {
      showchat = true;
    });

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

  TextEditingController _messages = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckUserConnection();
    print("Login id "+widget.idname);
    print("Logged in email "+widget.useremail);
    print("Admin email of product "+widget.adminemail);
    print("Service Id "+widget.serviceid);
    print("Service name "+widget.servicename);
    print("User type "+widget.usertype);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: Row(
                children: [
                  //Vendorhive360 logo
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FadeInImage(
                            image: NetworkImage(
                              "https://www.adeoropelumi.com/vendor/blogo/"+widget.logo,
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

                  //service name + vendro email
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //service name
                          Container(
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                          //vendor email
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              widget.servicename,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  //back button
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                print("pay vendor");
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return PayforService(idname: widget.idname,
                    sidname: widget.serviceid,
                    useremail: widget.useremail,
                    adminemail: widget.adminemail,
                    servicename: widget.servicename);
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orangeAccent
                  ),
                  color: Colors.green
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.only(top: 3),
                child: Row(
                  children: [
                    Expanded(child: Text("Pay Vendor",textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),))
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: Text("Pay Vendor helps you pend a payment in a vendors wallet not until a service has been rendered/provided to you, before you finally release Payment & also giving you the control to rate & review a service rendered.",
              style:TextStyle(
                fontSize: 10,
              ),textAlign: TextAlign.center,),
            ),
            Divider(),
            Flexible(
                child: ListView(
                  children: [
                    uploadimage == null ?
                    showchat
                        ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: messages.length,
                        itemBuilder: (context,index){
                          return MessageBubble(message: messages[index],);
                        })
                        :
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text("loading..."),
                      ),
                    )
                    :
                    Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height/2.5,
                            margin: EdgeInsets.only(left: 10,top: 10),
                            child:Image.file(uploadimage!)
                        ),
                       uploadingimage ? Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Center(
                            child: Text('sending image...',style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14
                            ),),
                          ),
                        ):Container()
                      ],
                    ),
                  ],
                )
            ),
          uploadimage == null ?
          Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      choosefile();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      child: RotationTransition(
                          turns: AlwaysStoppedAnimation(310 / 360),
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Icon(Icons.attachment_outlined,color: Colors.grey,size: 30,)
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      chooseImage();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Icon(Icons.camera_alt_outlined,color: Colors.grey,size: 30,),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _messages,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: .5,
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(
                                width: .5,
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(_messages.text.isEmpty){
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text('Enter a message'),
                            ));
                      }else{
                        if(sendingdata){
                          sendmsg();
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 5,left: 5),
                      child: Icon(Icons.send, color: sendingdata?Colors.grey:Colors.deepOrange, size: 30,),
                    ),
                  ),
                ],
              ),
            )
              :
           Container(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            uploadimage = null;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text('Cancel',style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),),
                          )
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          sendimgmsg();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text('Send Image',style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),),
                          )
                        ),
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
