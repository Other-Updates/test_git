import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Screens/notes.dart';
import 'package:vnr_police/Screens/notes.dart';
import 'package:vnr_police/Screens/photo_capture.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:intl/intl.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class LockedNew extends StatefulWidget {
  const LockedNew({Key? key}) : super(key: key);

  @override
  _LockedNewState createState() => _LockedNewState();
}

class _LockedNewState extends State<LockedNew> {
  GlobalKey bottomNavigationKey = GlobalKey();

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  bool adharnumber = true;
  bool voteridnumber = true;
  bool drivingnumber = true;
  bool other = true;
  bool save = true;

  String _chosenValue = 'Aadhar Number';
  final _files = [];
  void showWidget() {
    setState(() {
      adharnumber = true;
      voteridnumber = true;
      drivingnumber = true;
      other = false;
      save = false;
    });
  }

  void hideWidget() {
    setState(() {
      adharnumber = false;
      voteridnumber = false;
      drivingnumber = false;
      other = false;
      save = true;
    });
  }

  TextEditingController dateinput = TextEditingController();
  String selectedValue = "USA";
  String selectedValue1 = "USA";
  String selectedValue2 = "USA";
  String selectedValue3 = "USA";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Aadhar Number"), value: "USA"),
      DropdownMenuItem(child: Text("VoterId Number"), value: "Canada"),
      DropdownMenuItem(child: Text("Driving Licence Number"), value: "Brazil"),
      DropdownMenuItem(child: Text("Other"), value: "England"),
    ];

    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItems1 {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Address"), value: "USA"),
      DropdownMenuItem(child: Text("current location"), value: "Canada"),
    ];

    return menuItems;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    adharnumber = false;
    voteridnumber = false;
    drivingnumber = false;
    other = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.SecondaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.DASHBOARD_SCREEN);
          },
          icon: Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          'Locked Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: bg
        ),
        child: Column(
          children: [
            Expanded(
                child: Theme(
              data: ThemeData(
                  accentColor: Palette.SecondaryColor,
                  primarySwatch: Colors.green,
                  colorScheme:
                      ColorScheme.light(primary: Palette.PrimaryColor)),
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: new Text(
                      'Date',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          readOnly: true,
                          showCursor: false,
                          cursorColor: Colors.transparent,
                          controller: startDate,
                          decoration: InputDecoration(
                            isDense: true,
                            hintStyle: TextStyle(color: Color(0xff747474)),
                            prefixIcon: Icon(Icons.date_range),
                            labelText: "Enter start date",
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.8),
                            ),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                startDate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          readOnly: true,
                          showCursor: false,
                          cursorColor: Colors.transparent,
                          controller: endDate,
                          decoration: InputDecoration(
                            isDense: true,
                            hintStyle: TextStyle(color: Color(0xff747474)),
                            prefixIcon: Icon(Icons.date_range),
                            labelText: "Enter end date",
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.8),
                            ),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                endDate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text(
                      'Address Type',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
                              Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Address',
                                        fillColor: Colors.white,
                                        prefixIcon:
                                            Icon(Icons.my_location_sharp),
                                        // contentPadding:
                                        //     EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Palette.PrimaryColor,
                                              width: 2),
                                        ),
                                      ),
                                      value: selectedValue,
                                      hint: Text('Address Type'),
                                      icon: Icon(Icons.arrow_drop_down),
                                      onChanged: (String? newValue) {
                                        // (selectedValue == "USA")
                                        //     ? adharnumber = true
                                        //     : adharnumber = false;
                                        // (selectedValue1 == "USA")
                                        //     ? voteridnumber = false
                                        //     : voteridnumber = true;
                                        // (selectedValue2 == "USA")
                                        //     ? drivingnumber = true
                                        //     : drivingnumber = false;
                                        // (selectedValue3 == "USA")
                                        //     ? other = true
                                        //     : other = false;
                                        setState(() {
                                          selectedValue = newValue!;
                                          print(selectedValue);
                                        });
                                      },
                                      items: dropdownItems1))
                            ])),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Door No'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Down Name'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Landmark'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
              Step(
                title: new Text(
                  'Type of identification number',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                content: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(0.0),
                      child: DropdownButtonFormField<String>(
                        value: _chosenValue,
                        //elevation: 5,
                        decoration: InputDecoration(
                          hintText: 'Identification Number',
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Color(0xff004080), width: 2),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        hint: (_chosenValue == null || _chosenValue.isEmpty)
                            ? Text('Dropdown')
                            : Text(
                          _chosenValue,
                          style: TextStyle(color: Colors.black),
                        ),
                        items: <String>[
                          'Aadhar Number',
                          'VoterId Number',
                          'Driving License',
                          'Other',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        // hint: Text(
                        //   "Please choose a langauage",
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w600),
                        // ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value!;
                            print(_chosenValue);
                            if (_chosenValue == "Aadhar Number") {
                              adharnumber = true;
                              voteridnumber = false;
                              drivingnumber = false;
                              other = false;
                            }
                            if (_chosenValue == "VoterId Number") {
                              adharnumber = false;
                              voteridnumber = true;
                              drivingnumber = false;
                              other = false;
                            }
                            if (_chosenValue == "Driving License") {
                              adharnumber = false;
                              voteridnumber = false;
                              drivingnumber = true;
                              other = false;
                            }
                            if (_chosenValue == "Other") {
                              adharnumber = false;
                              voteridnumber = false;
                              drivingnumber = false;
                              other = true;
                            }
                          });
                        },
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: adharnumber,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Enter Aadhar Number'),
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: voteridnumber,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Enter VoterId Number'),
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: drivingnumber,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Enter Driving Licence Number'),
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: other,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Other'),
                      ),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 2
                    ? StepState.complete
                    : StepState.disabled,
              ),
                  Step(
                    title: new Text(
                      'Attach Media',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            // "Attach Media (Optional. Max. file size: 5MB)",
                            "Attach Media",
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.image,
                                  color: Colors.orange,
                                ),
                              ),
                              onTap: () {
                                if (_files.length == 5) {
                                  // WidgetUtils.infoToast("Mximum of 5 files allowed");
                                } else {
                                  // _optionsDialogBox(context);
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.videocam,
                                  color: Colors.purple,
                                ),
                              ),
                              onTap: () {
                                // WidgetUtils.infoToast("This feature is currently unavalibale");
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.keyboard_voice,
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () {
                                //WidgetUtils.infoToast("This feature is currently unavalibale");
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Divider(),
                        ),
                        Column(
                          children: _files.length == 0
                              ? [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 10,
                                        bottom: 10),
                                    child: Text(
                                      'No Files Selected',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ]
                              : _buildFileList(),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  )
                ],
              ),
            )),
           /* Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: gradientbutton1(),
            ),*/
          ],
        ),
      ),

            bottomNavigationBar: FancyBottomNavigation(
    //activeIconColor:Color(0xffb72334) ,
    inactiveIconColor: Color(0xffb72334),
    barBackgroundColor: Colors.white70,
    circleColor: Color(0xffb72334),
    tabs: [
    TabData(
    iconData: Icons.lock_outline,
    title: 'Locked home',
    onclick: () {
    final State<StatefulWidget>? fState =
    bottomNavigationKey.currentState;
    // fState.setPage(2);
 //   Navigator.pushNamed(context, PhotoCapture.route);
    }),
    TabData(
    iconData: Icons.local_police_outlined,
    title: 'Police station',
    //  onclick: () => Navigator.pushNamed(context, SpeechScreen.route),
    ),
    TabData(
    iconData: Icons.new_releases_outlined,
    title: 'News',
    // onclick: () => Navigator.pushNamed(context, NearbyPlaces.route),
    ),
    TabData(
    iconData: Icons.dashboard,
    title: 'Dashboard',
    // onclick: () => Navigator.pushNamed(context, NearbyPlaces.route),
    ),
    ],
    initialSelection: 1,
    key: bottomNavigationKey,
    onTabChangedListener: (position) {
    setState(() {
    // currentPage = position;
    });
    },
    ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.list),
      //   onPressed: switchStepsType,
      // ),
    );
  }

  switchStepsType() {
    setState(
      () => stepperType == StepperType.vertical
          ? stepperType = StepperType.horizontal
          : stepperType = StepperType.vertical,
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    Palette.SecondaryColor;
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Widget gradientbutton1() {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        //customer();
      },
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 6.0,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                Palette.PrimaryColor,
                Palette.PrimaryColor
              ]),
              borderRadius: BorderRadius.circular(40)),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Center(
              child: Text(
            'SUBMIT',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  _buildFileList() {}
}
