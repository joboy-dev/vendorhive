import 'package:flutter/material.dart';

class Profiles extends StatefulWidget {
  List names = [];
  Profiles({Key? key, required this.names}) : super(key: key);

  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  @override
  Widget build(BuildContext context) {
    return widget.names.length > 0 ? SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.names.length,
          itemBuilder: (context, index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200]
              ),
              child: Image.asset('assets/vendo.png'),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.names[index]['fullname'],
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13
            ),)
          ],
        );
      }),
    ) : SizedBox(width: 0,height: 5,);
  }
}
