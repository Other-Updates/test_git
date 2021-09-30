import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/models/devices_model.dart';
import 'package:iot_app/models/rooms_model.dart';
import 'package:iot_app/remotescreen/tvremotescreen.dart';
import 'package:iot_app/screens/Menudrawer.dart';
import 'package:iot_app/screens/NotificationScreen.dart';
import 'package:iot_app/screens/detail_screen.dart';
import 'package:iot_app/widgets/cate_container.dart';
import 'package:iot_app/widgets/devices.dart';
import 'package:iot_app/widgets/top_header.dart';
class HomeScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  List<RoomsModel> _listRooms = [
    RoomsModel(image: 'assets/images/kitchen.jpg', name: 'Kitchen', temp: '24'),
    RoomsModel(
        image: 'assets/images/livingroom.jpg', name: 'Living room', temp: '25'),
    RoomsModel(image: 'assets/images/bedroom.jpg', name: 'Bedroom', temp: '28'),
    RoomsModel(
        image: 'assets/images/bathroom.jpg', name: 'Bathroom', temp: '27'),
  ];
  List<DevicesModel> _listDevices = [
    DevicesModel(image: 'assets/images/microwave.png', name: 'Microwave'),
    DevicesModel(image: 'assets/images/range_hood.png', name: 'Range hood'),
    DevicesModel(image: 'assets/images/tv.png', name: 'TV'),
    DevicesModel(image: 'assets/images/refrigerator.png', name: 'Refrigerator'),
    DevicesModel(image: 'assets/images/setupbox.png',name: 'SetupBox'),
    DevicesModel(image: 'assets/images/Acimage.png',name: 'AC'),
    DevicesModel(image: 'assets/images/fans.jpg',name: 'FAN'),
    DevicesModel(image: 'assets/images/DVDplayer.png',name: 'DVD'),
    DevicesModel(image: 'assets/images/AVreceiver.png',name: 'AV Receiver'),
    DevicesModel(image: 'assets/images/camera.png',name: 'Camera'),
    DevicesModel(image: 'assets/images/Projector.png',name: 'Projector'),
    DevicesModel(image: 'assets/images/Smartbox.png',name: 'Smartbox'),

  ];
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      //   drawer: SideDrawer(),
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90.0,
        leading:  GestureDetector(
      //   padding: EdgeInsets.only(left:15,top: 20),
      // alignment: Alignment.topLeft,
      child: new Icon(
      Icons.menu,
        color: Colors.black,
        size: 30.0,
      ),

      onTap: () {
        _key.currentState!.openDrawer();
      },
    ),
actions: [
      Padding(
      padding: EdgeInsets.only(top: 10, right: 16,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Stack(
            overflow: Overflow.visible,
            children: [
              ClipRRect(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));

                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: _width*0.16,
                      height: _height*0.09,
                      child: Image.asset('assets/images/man.jpg',fit: BoxFit.cover,),
                    ),
                  )),
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent.shade400,
                      shape: BoxShape.circle
                  ),
                  child: Center(child: Text('4',style: TextStyle(color: Colors.white),)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: _height * 0.05,
              ),
              textCate(nameCate: 'Rooms'),
              SizedBox(height: 16,),
              Container(
                height: _height * 0.45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _listRooms.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CateContainer(
                        image: _listRooms[index].image,
                        name: _listRooms[index].name,
                        temp: _listRooms[index].temp,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(title: _listRooms[index].name,)));
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              textCate(nameCate: 'Devices'),
              SizedBox(
                height: 16,
              ),
              Container(
                height: _height * 0.5,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: _listDevices.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top : 16.0),
                      child: Center(
                        child: Devices(
                          image: _listDevices[index].image,
                          name: _listDevices[index].name,
                          onTap: () {
                           // Navigator.push(context, MaterialPageRoute(builder: (context)=>tvremotescreen(width: 0, context: context)));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget textCate({nameCate}) {
    return Text(
      nameCate,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
