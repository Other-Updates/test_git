// ignore: file_names
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/screens/AddLeadsScreen.dart';
import 'package:service_app/screens/AddServiceScreen.dart';
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/CusLeadsFragment.dart';
import 'package:service_app/screens/CusProfileFragment.dart';
import 'package:service_app/screens/CusServiceFragment.dart';
import 'package:service_app/screens/CusYoutubeFragment.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:service_app/screens/CustomerProfile.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:service_app/screens/mobilelogin.dart';
import 'LoaderScreen.dart';

class CustomerDashboardScreen extends StatefulWidget {
//  NormalBottomNavBar({Key key}) : super(key: key);
  @override
  _CustomerDashboardScreenState createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  PageController _pageController = PageController(initialPage: 2);
  List<Widget> _Screens = [
    CusLeadsFragment(),
    CusServiceFragment(),
    CusHomeFragment(),
    CusProfileFragment(),
    CusYoutubeFragment(),
  ];
  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedIndex = index;
    });
  }

  List _pages = [
    Text("Leads"),
    Text("Services"),
    Text("Dashboard"),
    Text("Profile"),
    Text("Youtube"),
  ];
  void onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  int _currentIndex = 0;
  List images = [];
  Swiper imageSlider(context) {
    return new Swiper(
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return new Image.network(images[index]['ads_data_link']);
      },
      itemCount: images.length,
      viewportFraction: 0.8,
      scale: 0.9,
      layout: SwiperLayout.DEFAULT,
    );
  }

  adsapi() async {
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //var data = json.encode({"name":usernameController.text,"mobile_number":phonenumberController.text,"email_id":emailController.text,"password":passwordController.text});
    final response = await http.get(BASE_URL + 'get_adverstisment_details',
        headers: {'authorization': basicAuth});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          images = jsonResponse['data'][0]['ads_details'];
        });
        print(images);
        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => CustomerDashboardScreen()), (Route<dynamic> route) => false);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }
  }

  customerlogout() async {
    var data = json.encode({"user_id": 'customer_id', "user_type": "2"});
    final response = await http.post(BASE_URL + 'customer_log_out',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "true") {
        StorageUtil.remove('login_customer_id');
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        // _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      Navigator.pop(context);
      //    _showMessageInScaffold('Contact Admin!!');
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure want to logout?'),
          /*       content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We will be redirected to login page.'),
              ],
            ),
          ),*/
          actions: <Widget>[
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(color: Color(0xff004080)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Color(0xff004080)),
              ),
              onPressed: () {
                customerlogout();
                //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                // Navigate to login
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 2;
    _pageController;
    adsapi();
    //   customerlogout();
  }
  /*@override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // ignore: avoid_unnecessary_containers
        onTap: onItemTapped,
        //_currentIndex = _currentIndex;
        //  onTap: ,
        currentIndex: _currentIndex,
      //  type: BottomNavigationBarType.fixed,
        items: [
        BottomNavigationBarItem(
        backgroundColor: new Color(0xff004080),
      icon:   new Icon(Icons.perm_phone_msg_outlined,
        color:   _selectedIndex == 0 ? Color(0xffff7000):Color(0xff004080),
      ),

      title: new Text('Leads',
        style: TextStyle(
          color: _selectedIndex == 0 ? Color(0xffff7000):Color(0xff004080),

        ),
      ),
    ),
    BottomNavigationBarItem(
    icon: ImageIcon(
    AssetImage('assets/images/paidservice.png'),
    // color: Color(0xFF3A5A98),

    color: _selectedIndex == 1 ? Color(0xffff7000):Color(0xff004080),
    ),

    title: new Text('Services',
    style: TextStyle(
    color: _selectedIndex == 1 ? Color(0xffff7000):Color(0xff004080),
    ),),
    ),
    BottomNavigationBarItem(
    icon: new Icon(Icons.home_outlined,
    color: _selectedIndex == 2 ? Color(0xffff7000):Color(0xff004080),
    ),
    title: new Text('Home',
    style: TextStyle(
    color:_selectedIndex == 2 ? Color(0xffff7000):Color(0xff004080),
    ),),
    ),
    BottomNavigationBarItem(
    icon: new Icon(Icons.person_outline,
    color: _selectedIndex == 3 ? Color(0xffff7000):Color(0xff004080),
    ),
    title: new Text('Profile',
    style: TextStyle(
    color: _selectedIndex == 3 ? Color(0xffff7000):Color(0xff004080),
    ),),
    ),
    BottomNavigationBarItem(
    icon: ImageIcon(
    AssetImage('assets/images/youtube_logo.png'),
    //  color: Color(0xFF3A5A98),
    color: _selectedIndex == 4 ? Color(0xffff7000):Color(0xff004080),
    ),
    title: Text('Youtube',
    style: TextStyle(
    color: _selectedIndex == 4 ? Color(0xffff7000):Color(0xff004080),
    ),)
    )
    ],),
      tabBuilder: (BuildContext context, int index) {
      switch(index){
        case 0:
          return CupertinoTabView(builder: (context){
            return CupertinoPageScaffold(child: CusLeadsFragment(),);

          });
        case 1:
          return CupertinoTabView(builder: (context){
            return CupertinoPageScaffold(child: AddLeadsScreen(),);

          });
        case 2:
          return CupertinoTabView(builder: (context){
            return CupertinoPageScaffold(child: AddServiceScreen(),);

          });

        default :return CupertinoTabView(builder: (context){
          return CupertinoPageScaffold(child: CusLeadsFragment(),);

        });
      }
    },);*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Are you sure want to leave?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            willLeave = false;
                            SystemNavigator.pop();
                          },
                          child: Text('Yes')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No'))
                    ],
                  ));
          return willLeave;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leadingWidth: 110,
            centerTitle: true,
            backgroundColor: new Color(0xff004080),
            leading: Image.asset('assets/images/service_logo.png'),
            title: _pages[_selectedIndex],
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showMyDialog();
                  }),
            ],
          ),
          body: Container(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  Expanded(
                      child: PageView(
                    controller: _pageController,
                    //  children:
                    children: _Screens,

                    onPageChanged: _onPageChanged,
                    physics: NeverScrollableScrollPhysics(),
                  ))
                ])),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: onItemTapped,
            //_currentIndex = _currentIndex;

            //  onTap: ,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                backgroundColor: new Color(0xff004080),
                icon: new Icon(
                  Icons.perm_phone_msg_outlined,
                  color: _selectedIndex == 0
                      ? Color(0xffff7000)
                      : Color(0xff004080),
                ),
                title: new Text(
                  'Leads',
                  style: TextStyle(
                    color: _selectedIndex == 0
                        ? Color(0xffff7000)
                        : Color(0xff004080),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/images/paidservice.png'),
                  // color: Color(0xFF3A5A98),

                  color: _selectedIndex == 1
                      ? Color(0xffff7000)
                      : Color(0xff004080),
                ),
                title: new Text(
                  'Services',
                  style: TextStyle(
                    color: _selectedIndex == 1
                        ? Color(0xffff7000)
                        : Color(0xff004080),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home_outlined,
                  color: _selectedIndex == 2
                      ? Color(0xffff7000)
                      : Color(0xff004080),
                ),
                title: new Text(
                  'Home',
                  style: TextStyle(
                    color: _selectedIndex == 2
                        ? Color(0xffff7000)
                        : Color(0xff004080),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: new Icon(
                  Icons.person_outline,
                  color: _selectedIndex == 3
                      ? Color(0xffff7000)
                      : Color(0xff004080),
                ),
                title: new Text(
                  'Profile',
                  style: TextStyle(
                    color: _selectedIndex == 3
                        ? Color(0xffff7000)
                        : Color(0xff004080),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/images/youtube_logo.png'),
                    //  color: Color(0xFF3A5A98),
                    color: _selectedIndex == 4
                        ? Color(0xffff7000)
                        : Color(0xff004080),
                  ),
                  title: Text(
                    'Youtube',
                    style: TextStyle(
                      color: _selectedIndex == 4
                          ? Color(0xffff7000)
                          : Color(0xff004080),
                    ),
                  ))
            ],
          ),
        ));
  }
}
