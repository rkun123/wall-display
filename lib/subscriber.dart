import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wall_display/state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';

const amedasNumber = '44132';

class Subscriber {
  WidgetRef ref;
  Subscriber(this.ref);

  subscribe() {
    Timer.periodic(const Duration(seconds: 10), (_) async {
      _checkConnectedState().then((state) {
        debugPrint(state.name);
        ref.read(connectedStateProvider.notifier).state = state;
        ref.read(dh5gConnectionProvider.notifier).state =
            DH5GConnectionState.connected;
      }).onError((error, stackTrace) {
        debugPrint('Connection errored');
        ref.read(dh5gConnectionProvider.notifier).state =
            DH5GConnectionState.unconnected;
      });
    });
  }

  Future<ConnectedState> _checkConnectedState() async {
    var url = Uri.parse('http://192.168.128.1/cgi-bin/qcmap_web_cgi');
    var requestBody = 'Page=GetHomeDeviceInfo&mask=0&token';
    try {
      setLoadingState(ref, true);
      var response = await http.post(url,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: requestBody);
      var responseBody = json.decode(response.body);
      setLoadingState(ref, false);
      switch (responseBody['ConnectStatus']) {
        case '3':
          return ConnectedState.fourG;
        case '4':
          return ConnectedState.fiveG;
        default:
          return ConnectedState.unknown;
      }
    } catch (e) {
      ref.read(dh5gConnectionProvider.notifier).state =
          DH5GConnectionState.unconnected;
      return ConnectedState.unknown;
    }
  }
}

class WeatherSubscriber {
  WidgetRef ref;
  WeatherSubscriber(this.ref);

  subscribe() async {
    Future _checkTemp(_) async {
      var f = NumberFormat('00');
      final date =
          '${f.format(DateTime.now().year)}${f.format(DateTime.now().month)}${f.format(DateTime.now().day)}';
      final uri = Uri.parse(
          'https://www.jma.go.jp/bosai/amedas/data/point/$amedasNumber/${date}_00.json');
      try {
        debugPrint('Check temperature');
        setLoadingState(ref, true);
        var response = await http.get(uri);
        var responseBody = json.decode(response.body);
        var latestAmedasData = responseBody.values.last;
        double temp = latestAmedasData['temp'][0];
        debugPrint('temp: ${temp.toString()}');
        ref.read(temperatureProvider.notifier).state = temp;
        setLoadingState(ref, false);
      } catch (e) {
        debugPrint('errored: ${e.toString()}');
      }
    }

    await _checkTemp(null);
    debugPrint('_checkTemp');
    Timer.periodic(const Duration(minutes: 10), _checkTemp);
  }
}

class DatetimeSubscriber {
  WidgetRef ref;
  DatetimeSubscriber(this.ref);

  subscribe() async {
    Ticker ticker = Ticker((_) {
      ref.read(datetimeProvider.notifier).state = DateTime.now();
    });
    ticker.start();
  }
}

void setLoadingState(WidgetRef ref, bool loading) {
  ref.read(loadingProvider.notifier).state = loading;
}
