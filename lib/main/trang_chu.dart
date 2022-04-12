import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:technonhiptim/addWidget/add_page.dart';
import 'package:technonhiptim/main/department_list_screen.dart';
import 'package:technonhiptim/main/tra_cuu_screen.dart';

import 'device_list_screen.dart';

class TrangChu extends StatefulWidget {
  TrangChu({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TrangChuState createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  int _selectedPos = 0;

  double bottomNavBarHeight = 60;

  static List<Widget> _widgetOptions = List();


   PageController _pageController;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.meeting_room_outlined, "Phòng", Colors.blueAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,)),
    new TabItem(Icons.account_circle, "Bệnh nhân", Colors.blueAccent,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    new TabItem(Icons.add, "Thêm", Colors.blueAccent, labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    new TabItem(Icons.search, "Tìm kiếm", Colors.blueAccent,labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
  ]);

  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    initWidgetOptions(1);
    super.initState();
    _navigationController = new CircularBottomNavigationController(_selectedPos);
    _pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomNav(),
          )
        ],
      ),
    );
  }

  void initWidgetOptions(int quyen) {
    print('_HomeScreenState.initWidgetOptions');
    switch (quyen) {
      case 1:
        _widgetOptions = <Widget>[
          DepartmentListScreen(),
          DeviceListScreen(),
          AddScreen(),
          TraCuuScreen(),
        ];
        break;
    }
  }


  Widget bodyContainer() {

    return Container(
      child: Center(
        child: _widgetOptions.elementAt(_selectedPos),
      ),
    );

    // return PageView(
    //   controller: _pageController,
    //   children: [
    //     DepartmentListScreen(),
    //     DeviceListScreen(),
    //     AddScreen(),
    //     TraCuuScreen(),
    //   ],
    //   onPageChanged: (page) {
    //     setState(() {
    //       _selectedPos = page;
    //       print('_TrangChuState.bodyContainer: $_selectedPos');
    //     });
    //     _pageController.jumpToPage(page);
    //
    //   },
    // );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      selectedPos: _selectedPos,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          _selectedPos = selectedPos;
          print(' abc: $_selectedPos');
        });
        _pageController.jumpToPage(selectedPos);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _navigationController.dispose();
  }
}
