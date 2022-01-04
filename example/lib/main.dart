import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:foloosi/foloosi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController orderIdTextField = new TextEditingController();
  final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (orderIdTextField.text.trim().isNotEmpty) {
      try {
        await Foloosi.init("your_merchant_key");
        Foloosi.setLogVisible(true);
        var res = {
          "orderId": "xmadfadg",
          "orderDescription": "hello world",
          "orderAmount": double.parse(orderIdTextField.text),
          "state": "india",
          "postalCode": "23366",
          "customColor": "",
          "country": "ARE",
          "currencyCode": "INR",
          "customer": {
            "name": "jhon",
            "email": "jhon@email.com",
            "mobile": "9876543210",
            "code": "91",
            "address": "hello check 123",
            "city": "chennai",
          }
        };

        var result = await Foloosi.makePayment(json.encode(res));
        print(result);
      } on Exception catch (exception) {}
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => key.currentState.showSnackBar(
          new SnackBar(
            content: new Text("Please enter amount"),
          ),
        ),
      );
    }
    // Platform messages may fail, so we use a try/catch PlatformException.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: key,
        appBar: AppBar(
          title: const Text('Foloosi Example'),
        ),
        body: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextField(
                    controller: orderIdTextField,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Enter the amount"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    initPlatformState();
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 50,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Proceed Payment",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
