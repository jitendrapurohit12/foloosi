import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Foloosi {
  static const MethodChannel _channel = const MethodChannel('foloosi');

  static init(String publicKey) {
    _channel
        .invokeMethod('init', <String, dynamic>{"public_key": publicKey});
  }

  static Future<dynamic> makePayment(String orderData) async {
    dynamic version = await _channel.invokeMethod(
        'makePayment', <String, dynamic>{"order_data": orderData});
    return json.decode(version);
  }

  static setLogVisible(bool debug) {
    _channel.invokeMethod('setLogVisible', <String, dynamic>{"visible": debug});
  }
}
