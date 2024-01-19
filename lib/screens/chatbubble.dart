import 'package:flutter/material.dart';
import 'package:vendorandroid/screens/chatmessage.dart';

class Chatbubble extends StatefulWidget {
  ChatMessage chatMessage;
  Chatbubble({required this.chatMessage});


  @override
  _ChatbubbleState createState() => _ChatbubbleState();
}

class _ChatbubbleState extends State<Chatbubble> {
  @override
  Widget build(BuildContext context) {
    return
    Align(
      alignment: widget.chatMessage.type == MessageType.Receiver ? Alignment.topLeft:Alignment.topRight,
      child: widget.chatMessage.type == MessageType.Receiver
        ?
      widget.chatMessage.message.contains("https://vendorhive360.com/vendor/chatsimg/")?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10,top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            width: MediaQuery.of(context).size.width/3,
            child: FadeInImage(
              image: NetworkImage(widget.chatMessage!.message),
              placeholder: AssetImage(
                  "assets/image.png"),
              imageErrorBuilder:
                  (context, error, stackTrace) {
                return Image.asset(
                    'assets/error.jpg',
                    fit: BoxFit.fitWidth);
              },
              fit: BoxFit.fitWidth,
            ),
            // child: Image.network(widget.chatMessage.message,),
          ),
          Container(

            padding: EdgeInsets.only(top: 5,left: 10),
            child: Text(widget.chatMessage.time,style: TextStyle(
                fontSize: 10
            ),),
          ),
        ],
      ):
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
                margin: EdgeInsets.only(left:10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child: Text(widget.chatMessage.message),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(widget.chatMessage.time,style: TextStyle(
                              fontSize: 10
                          ),),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                radius: 10,
              ),
            ),
          ],
        ),
      )
      :
      widget.chatMessage.message.contains("https://vendorhive360.com/vendor/chatsimg/")?
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10,top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            width: MediaQuery.of(context).size.width/3,
            child: FadeInImage(
              image: NetworkImage(widget.chatMessage!.message),
              placeholder: AssetImage(
                  "assets/image.png",),
              imageErrorBuilder:
                  (context, error, stackTrace) {
                return Image.asset(
                    'assets/error.jpg',
                    fit: BoxFit.fitWidth);
              },
              fit: BoxFit.fitWidth,
            ),
            // child: Image.network(widget.chatMessage.message,),
          ),
          Container(
            padding: EdgeInsets.only(top: 5,right: 10),
            child: Text(widget.chatMessage.time,style: TextStyle(
                fontSize: 10
            ),),
          ),
        ],
      ):
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(238, 252, 233, 1),
                radius: 10,
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 252, 233, 1),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
                  margin: EdgeInsets.only(right:10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(child: Text(widget.chatMessage.message)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(widget.chatMessage.time,style: TextStyle(
                                fontSize: 10
                            ),),
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
