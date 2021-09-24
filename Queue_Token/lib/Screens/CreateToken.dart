import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:queue_token/Screens/TokenDashboard.dart';
import 'package:wifi/wifi.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;

class CreateToken extends StatefulWidget {
  late final List<Map<String, dynamic>> data;
  @override
  _CreateTokenState createState() => _CreateTokenState();
}

class _CreateTokenState extends State<CreateToken> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  late String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  String text1 = 'CH0002';
  late String currentTtsString;
  double ttsSpeechRate1 = 0.1;
  double ttsSpeechRate2 = 1.0;
  late double currentSpeechRate;

  late FlutterTts flutterTts;
  bool bolSpeaking = false;

  Future playTtsString1() async {
    bolSpeaking = true;
    currentTtsString = text1;
    currentSpeechRate = ttsSpeechRate1;
    await runTextToSpeech(currentTtsString, currentSpeechRate);
    return null;
  }

  var currentDate = DateFormat('dd MMM yyyy  hh:mm:ss').format(DateTime.now());

  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;

  void discover(BuildContext ctx) async {
    setState(() {
      isDiscovering = true;
      devices.clear();
      found = -1;
    });
    String ip;
    try {
      ip = await Wifi.ip;
      print('local ip:\t$ip');
    } catch (e) {
      final snackBar = SnackBar(
          content: Text('WiFi is not connected', textAlign: TextAlign.center));
      Scaffold.of(ctx).showSnackBar(snackBar);
      return;
    }
    setState(() {
      localIp = ip;
    });
    TextEditingController portController = TextEditingController(text: '9100');

    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    int port = 9100;
    try {
      port = int.parse(portController.text);
    } catch (e) {
      portController.text = port.toString();
    }
    print('subnet:\t$subnet, port:\t$port');

    final stream = NetworkAnalyzer.discover2(subnet, port);

    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        setState(() {
          devices.add(addr.ip);
          found = devices.length;
        });
      }
    })
      ..onDone(() {
        setState(() {
          isDiscovering = false;
          found = devices.length;
        });
      })
      ..onError((dynamic e) {
        final snackBar = SnackBar(
            content: Text('Unexpected exception', textAlign: TextAlign.center));
        Scaffold.of(ctx).showSnackBar(snackBar);
      });
  }

  // void testPrint(String printerIp, BuildContext ctx) async {
  //   // TODO Don't forget to choose printer's paper size
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);
  //
  //   final PosPrintResult res = await printer.connect(printerIp, port: 9100);
  //
  //   if (res == PosPrintResult.success) {
  //     await _showMyDialog(printer);
  //     printer.disconnect();
  //   }
  //
  //   final snackBar =
  //       SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
  //   Scaffold.of(ctx).showSnackBar(snackBar);
  // }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
        }
      });
    } else {
      initPrinter();
    }
  }

  @override
  Widget printer(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print'),
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_devicesMsg ?? ''))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Icon(Icons.print),
                  title: Text(_devices[i].name),
                  subtitle: Text(_devices[i].address),
                  onTap: () {
                    _startPrint(_devices[i], context);
                  },
                );
              },
            ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
    });
  }

  Future<void> _startPrint(
      PrinterBluetooth printer, BuildContext context) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    int total = 0;

    // Image assets
    final ByteData data = await rootBundle.load('assets/store.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final image = decodeImage(bytes);
    ticket.image(image);
    ticket.text(
      'TOKO KU',
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
      linesAfter: 1,
    );

    // for (var i = 0; i < widget.data.length; i++) {
    //   total += widget.data[i]['total_price'];
    //   ticket.text(widget.data[i]['title']);
    //   ticket.row([
    //     PosColumn(
    //         text: '${widget.data[i]['price']} x ${widget.data[i]['qty']}',
    //         width: 6),
    //     PosColumn(text: 'Rp ${widget.data[i]['total_price']}', width: 6),
    //   ]);
    // }

    ticket.feed(1);
    ticket.row([
      PosColumn(text: 'Total', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: 'Rp $total', width: 6, styles: PosStyles(bold: true)),
    ]);
    ticket.feed(2);
    ticket.text('Thank You',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.cut();

    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/loginback.jpg'),
                  // colorFilter: ColorFilter.mode(
                  //     Color(0xffADDFDE).withOpacity(0.5), BlendMode.dstATop),
                  fit: BoxFit.cover)),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.only(bottom: 150.0, top: 90.0),
              child: Text(
                'QUEUING EAZY - TREATMENT',
                style: TextStyle(fontSize: 22.0),
              ),
            ),
            Container(
                height: 85,
                width: 200,
                padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                child: RaisedButton.icon(
                  textColor: Colors.white,
                  color: Colors.deepOrangeAccent,
                  onPressed: () async {
                    await playTtsString1();
                    // testPrint(devices[index], context);
                    _showMyDialog();
                    _devices.isEmpty
                        ? Center(child: Text(_devicesMsg ?? ''))
                        : ListView.builder(
                            itemCount: _devices.length,
                            itemBuilder: (c, i) {
                              return ListTile(
                                leading: Icon(Icons.print),
                                title: Text(_devices[i].name),
                                subtitle: Text(_devices[i].address),
                                onTap: () {
                                  _startPrint(_devices[i], context);
                                },
                              );
                            },
                          );

                    //discover;
                  },
                  icon: Icon(Icons.print),
                  label: Text(
                    'Click me!',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
                height: 75,
                width: 200,
                padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.lightBlueAccent,
                  child: Text('Cancel',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => TokenDashboard()));
                  },
                )),
          ])),
    ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.purpleAccent,
            content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(left: 15, top: 5),
                          alignment: Alignment.topRight,
                          child: new Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 24.0,
                          )),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TokenDashboard()));
                      }),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('F2F',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text(/*'4 sept 2021   15.07.23'*/ currentDate,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          color: Colors.black54,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Your Token Number',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('CH0002',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Your Counter Name',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Cash',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Thank You',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Powered by F2F solutions',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                ])));
      },
    );
  }

  Future<void> runTextToSpeech(
      String currentTtsString, double currentSpeechRate) async {
    flutterTts = new FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(0.2);
    await flutterTts.setPitch(1.0);
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(currentSpeechRate);

    flutterTts.setCompletionHandler(() {
      setState(() {
        // The following code(s) will be called when the TTS finishes speaking
        bolSpeaking = false;
      });
    });

    flutterTts.speak(currentTtsString);
  }
}
