import 'package:flutter/material.dart';
import 'package:technonhiptim/helper/media_query_helper.dart';

class YeuCau extends StatefulWidget {
  const YeuCau({Key key}) : super(key: key);

  @override
  _YeuCauState createState() => _YeuCauState();
}

class _YeuCauState extends State<YeuCau> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        title: Text(
          'Liên hệ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/cres_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'Chức năng đang phát triển',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenHelper.getWidth(context) * .05,
            ),
          ),
        ),
      ),
    );
  }
}
