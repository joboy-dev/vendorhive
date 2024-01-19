import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:vendorandroid/screens/chatbubble.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatMessage{
  String message;
  MessageType type;
  String date;
  String time;
  ChatMessage({required this.message, required this.type,required this.date,required this.time});
}

enum MessageType{
  Sender,
  Receiver,
}


class ChatMsg extends StatefulWidget {
  String sidname = "";
  String useremail = "";
  String adminemail = "";
  String idname = "";
  String usertype = "";
  String servicename = "";
  String username = "";
  String sender_name = "";

  ChatMsg({required this.sender_name, required this.username,required this.sidname,
    required this.useremail, required this.adminemail,
    required this.idname,required this.usertype,
  required this.servicename});

  @override
  _ChatMsgState createState() => _ChatMsgState();
}

class _ChatMsgState extends State<ChatMsg> {
  bool ActiveConnection = false;
  bool showchat = false;
  int sec = 0;
  bool cancelTimer = false;
  int? addChat;
  int? secondaddChat;
  List? chatdata;
  List? secondchatdata;
  bool sendingdata = true;
  File? uploadimage;
  String filename = '';
  bool uploadingimage = false;
  TextEditingController _messages = new TextEditingController();
  final ImagePicker _picker = ImagePicker();


  List<ChatMessage> chatMessage = [];

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

  Future loadchats() async {
    final response = await http
        .post(Uri.https('vendorhive360.com', 'vendor/vendorgetchat.php'), body: {
      "sidname": widget.sidname,
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
      chatMessage.add(ChatMessage(message: modify(responsBody[q]['3'].toString()),
          type: users== 'business' ?MessageType.Sender:MessageType.Receiver,
      date: date,time: days > 0 ? reply : time),);
    }

    setState(() {
      showchat = true;
      calltimer();
    });

  }

  Future onthegochat() async {

    final response = await http
        .post(Uri.https('vendorhive360.com', 'vendor/vendorgetchat.php'), body: {
      "sidname": widget.sidname,
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

        chatMessage.add(ChatMessage(message: modify(responsBody[q]['3'].toString()),
            type: users== 'business' ?MessageType.Sender:MessageType.Receiver,
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

  Future sendmsg() async{

    setState(() {
      sendingdata = false;
    });

    final sending = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorsendchat.php'),body: {
      'idname':widget.idname,
      'useremail': widget.useremail,
      'adminemail':widget.adminemail,
      'message': replacing(_messages.text),
      'usertype' : widget.usertype,
      'sidname': widget.sidname,
      'servicename': widget.servicename
    });

    var message_notify = await http.post(
        Uri.https('vendorhive360.com','vendor/vendornewmessagenotification.php'),
        body: {
          'name':widget.sender_name,
          'email':widget.useremail,
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

  Future<void> chooseImage() async{
    var chooseImg = await _picker.pickImage(source: ImageSource.camera);
    setState((){
      uploadimage = File(chooseImg!.path);
      filename = chooseImg!.name;
    });
    print(filename);
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
      var sendimg = await http.post(Uri.https('vendorhive360.com','vendor/vendorsendimg.php'),body: {
        'idname':widget.idname,
        'useremail': widget.useremail,
        'adminemail':widget.adminemail,
        'usertype' : widget.usertype,
        'sidname': widget.sidname,
        'servicename' : widget.servicename,
        'filename':filename,
        'img': baseimage,
      });

      var message_notify = await http.post(
          Uri.https('vendorhive360.com','vendor/vendornewmessagenotification.php'),
          body: {
            'name':widget.sender_name,
            'email':widget.useremail,
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
  initState(){
    super.initState();
    print("Admin mail/ User mail "+widget.adminemail);
    print("Customer mail "+widget.useremail);
    print("User id "+widget.idname);
    print("Usertype "+widget.usertype);
    CheckUserConnection();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                      child: Image.asset("assets/vendo.png"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
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
            Flexible(
              child: ListView(
                children: [
                  uploadimage == null ?
                  showchat
                      ?
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: chatMessage.length,
                      itemBuilder: (context,index){
                        return Chatbubble(chatMessage: chatMessage[index],);
                      })
                      :
                  Container(
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
                  Container(
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
                          suffixIcon: Image.asset("assets/emoji.png"),
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
