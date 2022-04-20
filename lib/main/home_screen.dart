import 'package:flutter/material.dart';
import 'package:technonhiptim/addWidget/add_device_page.dart';
import 'package:technonhiptim/addWidget/add_page.dart';
import 'package:technonhiptim/helper/bottom_navigation_bar.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/main/department_list_screen.dart';
import 'package:technonhiptim/main/detail_screen.dart';
import 'package:technonhiptim/main/filter_element_screen.dart';
import 'package:technonhiptim/main/user_profile_page.dart';
import 'package:technonhiptim/main/yeu_cau.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.loginResponse, this.index}) : super(key: key);

  final Map loginResponse;
  final int index;

  @override
  _HomeScreenState createState() => _HomeScreenState(loginResponse);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.loginResponse);

  final Map loginResponse;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int quyen;
  SharedPrefsHelper sharedPrefsHelper;
  String iduser;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = List();
  static List<BottomNavigationBarItem> bottomBarItems = List();
  static List<CustomBottomNavigationItem> items = List();

  @override
  void initState() {
    sharedPrefsHelper = SharedPrefsHelper();
    getSharedPref();
    initBottomBarItems(1);
    initWidgetOptions(1);
    super.initState();
  }

  Future<void> getSharedPref() async {
    iduser = await sharedPrefsHelper.getStringValuesSF('iduser');
  }

  void getPermission() async {
    quyen = 1;
    print(
        '_HomeScreenState.getPermission ${quyen.runtimeType} - $_selectedIndex');
    initBottomBarItems(quyen);
    initWidgetOptions(quyen);
  }

  void initBottomBarItems(int quyen) {
    switch (quyen) {
      case 1:
        bottomBarItems = [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.water_damage,
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wine_bar,
            ),
            label: 'Lõi lọc',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_call,
            ),
            label: 'Yêu cầu',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_rounded,
            ),
            label: 'Tài khoản',
          ),
        ];
        break;
    }
  }

  void initWidgetOptions(int quyen) {
    print('_HomeScreenState.initWidgetOptions');
    switch (quyen) {
      case 1:
        _widgetOptions = <Widget>[
          DetailScreen(),
          DepartmentListScreen(),
          FilterElementScreen(),
          AddScreen(),
        ];
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody2(),
      bottomNavigationBar: bottomBar(),
      // bottomNavigationBar: FABBottomAppBar(
      //   // centerItemText: 'Trang chủ',
      //   color: Colors.black,
      //   backgroundColor: Colors.blueAccent,
      //   selectedColor: Colors.white,
      //   // notchedShape: CircularNotchedRectangle(),
      //   onTabSelected: _onItemTapped,
      //   items: [
      //     FABBottomAppBarItem(iconData: Icons.meeting_room_outlined, text: 'Phòng'),
      //     FABBottomAppBarItem(iconData: Icons.account_circle, text: 'Bệnh nhân'),
      //     FABBottomAppBarItem(iconData: Icons.add, text: 'Thêm'),
      //     FABBottomAppBarItem(iconData: Icons.search, text: 'Tìm kiếm'),
      //   ],
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDeviceScreen()),
          );
        },
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

  Widget buildBody() {
    print('_HomeScreenState.buildBody ${_widgetOptions.length}');
    return Container(
      child: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Widget buildBody2() {
    return PageView(
      controller: _pageController,
      children: [
        DetailScreen(),
        DepartmentListScreen(),
        YeuCau(),
        // AddScreen(),
        UserProfilePage(),
      ],
      onPageChanged: (page) {
        setState(() {
          _selectedIndex = page;
        });
        _pageController.jumpToPage(page);
      },
    );
  }

  Widget bottomBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: Colors.blue,
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: Colors.red,
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: new TextStyle(color: Colors.white),
            ),
      ),
      child: BottomNavigationBar(
        selectedFontSize: 16,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: bottomBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
