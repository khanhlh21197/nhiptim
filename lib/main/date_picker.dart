import 'package:flutter/material.dart';

class DatePickerDemo extends StatefulWidget {

  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                "${selectedDate.toLocal().toString()}".split(' ')[0],
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 1,
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  'Chọn ngày',
                  style:
                  TextStyle(color: Colors.black,),
                ),
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
