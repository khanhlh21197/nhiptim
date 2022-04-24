import 'package:flutter/material.dart';
import 'package:technonhiptim/helper/media_query_helper.dart';

class LienHe extends StatefulWidget {
  const LienHe({Key key}) : super(key: key);

  @override
  _LienHeState createState() => _LienHeState();
}

class _LienHeState extends State<LienHe> {
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
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 5,
                  shadowColor: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      child: Column(
                        children: [
                          deviceInfoItem(
                              'Công ty: ', 'Techno Corp', Colors.green),
                          deviceInfoItem('Email: ', 'Email', Colors.green),
                          deviceInfoItem(
                              'Số điện thoại: ', '0912345678', Colors.green),
                          deviceInfoItem('Địa chỉ: ', 'Hà Nội', Colors.green),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }

  Widget deviceInfoItem(String label, String content, Color color) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, textAlign: TextAlign.left),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(content,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: ScreenHelper.getWidth(context) * .04,
                  color: color,
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
    );
  }
}
