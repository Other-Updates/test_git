import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vnr_police/Utils/help_line.dart';
import 'package:share/share.dart';

class FindTrafficInspectors extends StatefulWidget {
  const FindTrafficInspectors({Key? key}) : super(key: key);

  @override
  _FindTrafficInspectorsState createState() => _FindTrafficInspectorsState();
}

class PoliceStation {
  String name;
  String address;
  String phoneNumber;
  String stationNumber;
  String officerNumber;
  String stationOfficeNumber;

  List<double> location;

  PoliceStation(
      {required this.name,
      required this.address,
      required this.phoneNumber,
      required this.location,
      required this.stationNumber,
      required this.officerNumber,
      required this.stationOfficeNumber});
}

class _FindTrafficInspectorsState extends State<FindTrafficInspectors> {
  int _selectedIndex = 0;

  final Set<Marker> _markers = Set();

  final List<PoliceStation> policeStations = [
    PoliceStation(
      name: "Traffic Virudhunagar",
      address: "17th Road, virudhunagar.",
      phoneNumber: "08059113555",
      stationNumber: "89",
      officerNumber: "8946584526",
      stationOfficeNumber: "08059113555",
      location: [9.110194, 6.424357],
    ),
    // PoliceStation(name: "RS puram Police Station", address: "Life Camp,Coimbatore.", phoneNumber: "08059113555", location: [9.710194, 7.824357]),
    // PoliceStation(name: "Rathinapuri Police Station", address: "Arab Road, Coimbatore.", phoneNumber: "095211199", location: [9.410194, 7.624357]),
    // PoliceStation(name: "Bwari Police Station", address: "Bwari, Kubwa, Coimbatore.", phoneNumber: "08075804475", location: [9.310194, 7.924357]),
  ];

  List cardList = [
    {'description': 'James', 'position': 'Constable'},
    {'description': 'Peter', 'position': 'Head-Constable'},
    {'description': 'John', 'position': 'Sub-Inspector'},
    {'description': 'Mike', 'position': 'Inspector'},
    {'description': 'Mark', 'position': 'DSP'},
    {'description': 'Joseph', 'position': 'SP'},
    {'description': 'Justin', 'position': 'DIG'},
    {'description': 'Bieber', 'position': 'IG'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, Routes.POLICESTATION_SCREEN);
            },
          ),
          centerTitle: true,
          title: Text(
            "Find Police Stations",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Palette.PrimaryColor,
          brightness: Brightness.light,
          elevation: 0,
          actions: <Widget>[
            /*         Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0),
              child: DropdownButton<String>(
                value: _selectedState,
                style: TextStyle(color: Colors.white),
                isExpanded: false,
                items: _states.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    //_selectedState = value;
                  });
                },
              ),
            ),*/
          ],
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            indicatorColor: Colors.white70,
            unselectedLabelColor: Colors.white70,
            labelColor: Colors.white70,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.list),
                    Text("    LIST VIEW"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.map),
                    Text("    MAP VIEW"),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.black12,
          child: _selectedIndex == 0
              ? _buildPoliceStationListView()
              : _buildPoliceStationMapView(),
        ),
      ),
    );
  }

  Widget _buildPoliceStationListView() {
    return Container(
        child: Column(children: [
      Column(
        children: policeStations.map((ps) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 4.0, bottom: 2.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Palette.SecondaryColor, width: 1.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          ps.name,
                          style: TextStyle(
                              color: Palette.SecondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          ps.address,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Station number',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            ps.stationNumber,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Station number',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            ps.stationOfficeNumber,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.phone_outlined,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    callNcdc();
                                    //   openAlertBox();
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.blue,
                                ),
                                onPressed: (){
                                  Share.share(
                                      "Download the VNR Police App and share with your friends and loved ones.\nAwareness App -  https://bit.ly/betatojuwa");
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            color: Palette.PrimaryColor,
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Navigate",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.navigation,
                                  size: 13,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      Expanded(
        child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              itemCount: cardList.length,
              itemBuilder: (context, index) => EachList(cardList[index]),
            )),
        flex: 2,
      ),
    ]));
  }

  Widget _buildPoliceStationMapView() {
    _markers.clear();
    const LatLng _center = const LatLng(9.110194, 7.424357);
    _markers.addAll(policeStations.map((ps) {
      return Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(ps.phoneNumber),
        position: LatLng(ps.location[0], ps.location[0]),
        infoWindow: InfoWindow(
          title: ps.name,
          snippet: ps.name,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
    }).toList());
    return Container(
      child: GoogleMap(
        myLocationEnabled: true,
        onMapCreated: (c) async {
          var location = await Geolocator.getCurrentPosition();
          Future.delayed(Duration(seconds: 3), () {
            c.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(location.latitude, location.longitude), 15.0));
          });
        },
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 9.0,
        ),
      ),
    );
  }

  @override
  Widget EachList(cardList) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.POLICEOFFICERSDETAILSSCREEN);
        },
        child: new Card(
            shadowColor: Palette.PrimaryColor,
            elevation: 2.0,
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                //  side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
                height: 80.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Stack(children: [
                  // CircleAvatar(
                  //     radius: 35,
                  //     backgroundColor: Colors.white,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(35),
                  //       child: Image.asset(
                  //         "assets/images/loginLogin.png",
                  //         width: double.infinity,
                  //         height: double.infinity,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Icon(
                          Icons.local_police,
                          color: Palette.SecondaryColor,
                        ),
                        // Expanded(
                        //     child: Padding(
                        //         padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        //         child:
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          cardList['description'],
                          //  maxLines: 3,
                        ),
                      ])),
                  // ),
                  //           flex: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      cardList['position'],
                      style: TextStyle(
                          color: Palette.PrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      //  maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.phone_outlined,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                callNcdc();
                                //   openAlertBox();
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                launchWhatsappWho();
                                // openAlertBox();
                              }),
                        ]),
                  ),
                ]))));
  }
}
