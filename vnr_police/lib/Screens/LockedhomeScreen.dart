// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Utils/Routes.dart';

class LockedHomeScreen extends StatefulWidget {
  const LockedHomeScreen({Key? key}) : super(key: key);

  @override
  _LockedHomeScreenState createState() => _LockedHomeScreenState();
}

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}

class _LockedHomeScreenState extends State<LockedHomeScreen> {
  final _files = [];

  /* void _pickImage() async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (picture != null) {
      setState(() {
        _files.add(picture);
      });
    }
  }

  void _captureImage() async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (picture != null) {
      setState(() {
        _files.add(picture);
      });
    }
  }*/

  bool adharnumber = true;
  bool voteridnumber = true;
  bool drivingnumber = true;
  bool other = true;
  bool save = true;

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

  Future<void> _optionsDialogBox(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Take a picture'),
                  onTap: () {
                    //_captureImage();
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: () {
                    //  _pickImage();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    hideWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Palette.SecondaryColor,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, Routes.DASHBOARD_SCREEN),
          ),
          // leadingWidth: 110,
          centerTitle: true,
          backgroundColor: Palette.PrimaryColor,
          /*    leading: new IconButton(
            alignment: Alignment.topLeft,
              icon: new Icon(Icons.arrow_back),
              onPressed: (){Navigator.pop(context,true);}
          ),*/
          title: Text(
            'Locked Home',
            style: TextStyle(
                color: Palette.SecondaryColor, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.power_settings_new_rounded,
                  color: Palette.SecondaryColor,
                ),
                onPressed: () {}),
          ],
          //   centerTitle: true,
          //  automaticallyImplyLeading: false,
        ),
        body: Container(
            color: Colors.black26,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },

                ///child: SingleChildScrollView(
                child: ListView(children: [
                  Container(
                      //   height: 65,
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: TextFormField(
                                    readOnly: true,
                                    showCursor: false,
                                    cursorColor: Colors.transparent,
                                    controller: dateinput,
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
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        print(
                                            formattedDate); //formatted date output using intl package =>  2021-03-16
                                        //you can implement different kind of Date Format here according to your requirement

                                        setState(() {
                                          dateinput.text =
                                              formattedDate; //set output date to TextField value.
                                        });
                                      } else {
                                        print("Date is not selected");
                                      }
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      //  contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                                      prefixIcon: Icon(Icons.date_range),

                                      labelText: "Enter start date",

                                      hintStyle:
                                          TextStyle(color: Color(0xff747474)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.8),
                                      ),
                                    ))),
                            flex: 2,
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: TextFormField(
                                readOnly: true,
                                showCursor: false,
                                cursorColor: Colors.transparent,
                                controller: dateinput,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintStyle:
                                      TextStyle(color: Color(0xff747474)),
                                  prefixIcon: Icon(Icons.date_range),
                                  labelText: "Enter end date",
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.8),
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
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement

                                    setState(() {
                                      dateinput.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),
                            flex: 2,
                          ),
                        ],
                      )),

                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                      //   padding: EdgeInsets.all(15),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        Expanded(
                            flex: 3,
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  hintText: 'Type of identification number',
                                  prefixIcon: Icon(Icons.confirmation_num),
                                  fillColor: Colors.white,
                                  // contentPadding:
                                  //     EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Palette.PrimaryColor, width: 2),
                                  ),
                                ),
                                value: selectedValue,
                                hint: Text('Type of identification number'),
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
                                items: dropdownItems))
                      ])),

                  /* child: Column(
            mainAxisSize: MainAxisSize.min,
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [*/

                  (selectedValue == "USA")
                      ? Visibility(
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: adharnumber,
                          child: Container(
                            //height: 70,
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Aadhar Number',
                                  prefixIcon:
                                      Icon(Icons.sticky_note_2_outlined)),
                            ),
                          ),
                        )
                      : Container(),
                  (selectedValue1 == "USA")
                      ? Visibility(
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: voteridnumber,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'VoterId Number',
                                  prefixIcon: Icon(Icons.how_to_vote)),
                            ),
                          ))
                      : Container(),
                  (selectedValue2 == "USA")
                      ? Visibility(
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: drivingnumber,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Driving Licence Number',
                                  prefixIcon:
                                      Icon(Icons.drive_file_rename_outline)),
                            ),
                          ))
                      : Container(),
                  (selectedValue3 == "USA")
                      ? Visibility(
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: other,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Other',
                                  prefixIcon: Icon(Icons.devices_other)),
                            ),
                          ))
                      : Container(),
                  /*   Text("Address Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,),*/
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                      //   padding: EdgeInsets.all(15),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        Expanded(
                            flex: 3,
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(Icons.my_location_sharp),
                                  // contentPadding:
                                  //     EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 1.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Palette.PrimaryColor, width: 2),
                                  ),
                                ),
                                value: selectedValue,
                                hint: Text('Type of identification number'),
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
                  // Padding(
                  //   // margin: EdgeInsets.only(left: 10, right: 10),
                  //   padding: EdgeInsets.all(15),
                  //   child:
                  //       // Card(
                  //       //   child: Padding(
                  //       //     padding: const EdgeInsets.all(8.0),
                  //       //     child:
                  //       TextFormField(
                  //     //  controller: _addressController,
                  //     maxLines: 4,
                  //     minLines: 4,
                  //     textAlign: TextAlign.start,
                  //     decoration: new InputDecoration(
                  //       labelText: "Address Details",
                  //       fillColor: Colors.white,
                  //       border: new OutlineInputBorder(
                  //         borderRadius: new BorderRadius.circular(10.0),
                  //         borderSide: new BorderSide(),
                  //       ),
                  //       //fillColor: Colors.green
                  //     ),
                  //     keyboardType: TextInputType.text,
                  //   ),
                  // ),
                  // )),
                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    //margin: EdgeInsets.only(left: 10, right: 10),
                    // padding: EdgeInsets.all(15),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
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
                                    _optionsDialogBox(context);
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
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    ),
                                  ]
                                : _buildFileList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: gradientbutton1(),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  /*     Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 20),
             child: Icon(Icons.my_location_sharp),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton<String>(
                value: selectedValue,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue){
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems
            //  value: _sizedropDown,
            ),
          ),

        ],
      ),*/
                  // Padding(padding: EdgeInsets.only(bottom: 20)),
                  // Text(
                  //   'Developed by',
                  //   style: TextStyle(
                  //     color: Colors.black54,
                  //   ),
                  // ),
                  // Text(
                  //   'f2f   Solutions.in',
                  //   style: TextStyle(
                  //     color: Colors.black54,
                  //   ),
                  // )
                ]))));
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
              gradient: LinearGradient(
                  colors: <Color>[Palette.SecondaryColor, Palette.SecondaryColor]),
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
