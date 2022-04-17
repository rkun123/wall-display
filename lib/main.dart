import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:wall_display/clock.dart';
import 'package:wall_display/loading.dart';
import 'package:wall_display/state.dart';
import 'package:wall_display/stateful_wrapper.dart';
import 'package:wall_display/subscriber.dart';

void main() {
  debugPrint('init');
  runApp(const ProviderScope(child: MyApp()));
}

const defaultTextStyle = TextStyle(fontSize: 40.0, color: Colors.white);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FullScreen.enterFullScreen(FullScreenMode.LEANBACK);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  Widget _statusRow(String label, String value) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: defaultTextStyle,
          ),
          Text(
            value,
            style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
          )
        ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    /**
    bool subscribing = ref.watch(subscribingProvider);

    debugPrint(subscribing.toString());
    if (!subscribing) {
      // subscribing = true;
      debugPrint('Start subscribing...');
      ref.read(subscribingProvider.notifier).state = true;
      var s = Subscriber(ref);
      s.subscribe();
      var ws = WeatherSubscriber(ref);
      ws.subscribe();
      var datetimeSubscriber = DatetimeSubscriber(ref);
      datetimeSubscriber.subscribe();
    }
    */
    void onInit() {
      // bool subscribing = ref.watch(subscribingProvider);

      // debugPrint(subscribing.toString());
      // subscribing = true;
      debugPrint('Start subscribing...');
      // ref.read(subscribingProvider.notifier).state = true;
      var s = Subscriber(ref);
      s.subscribe();
      var weatherSubscriber = WeatherSubscriber(ref);
      weatherSubscriber.subscribe();
      weatherSubscriber.updateTempImmediately();

      var datetimeSubscriber = DatetimeSubscriber(ref);
      datetimeSubscriber.subscribe();

      var chanceOfLainSubscriber = ChanceOfLainSubscriber(ref);
      chanceOfLainSubscriber.subscribe();
      chanceOfLainSubscriber.updateChanceOfLainImmediately();
    }

    return StatefulWrapper(
        onInit,
        Scaffold(
            backgroundColor: Colors.black87,
            body: Container(
                margin: const EdgeInsets.all(32.0),
                padding: const EdgeInsets.all(64.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black87),
                width: double.infinity,
                child: Stack(children: [
                  loadingIndicator(ref),
                  Consumer(
                      builder: (context, ref, _) => Column(
                            // Column is also a layout widget. It takes a list of children and
                            // arranges them vertically. By default, it sizes itself to fit its
                            // children horizontally, and tries to be as tall as its parent.
                            //
                            // Invoke "debug painting" (press "p" in the console, choose the
                            // "Toggle Debug Paint" action from the Flutter Inspector in Android
                            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                            // to see the wireframe for each widget.
                            //
                            // Column has various properties to control how it sizes itself and
                            // how it positions its children. Here we use mainAxisAlignment to
                            // center the children vertically; the main axis here is the vertical
                            // axis because Columns are vertical (the cross axis would be
                            // horizontal).
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              clock(ref),
                              Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.white, width: 2)))),
                              () {
                                final cs = ref.watch(connectedStateProvider);
                                var text = '不明';
                                switch (cs) {
                                  case ConnectedState.fiveG:
                                    text = '5G';
                                    break;
                                  case ConnectedState.fourG:
                                    text = '4G+';
                                    break;
                                  default:
                                }
                                return _statusRow('コネクションタイプ', text);
                              }(),
                              () {
                                final cs = ref.watch(dh5gConnectionProvider);
                                var connectionName = '';
                                switch (cs) {
                                  case DH5GConnectionState.connected:
                                    connectionName = '接続中';
                                    break;
                                  case DH5GConnectionState.unconnected:
                                    connectionName = '未接続';
                                    break;
                                  default:
                                    connectionName = '未接続（不明）';
                                }
                                return _statusRow('接続状況', connectionName);
                              }(),
                              () {
                                final temp = ref.watch(temperatureProvider);
                                var tempFormat = '不明';
                                if (temp >= -273) {
                                  tempFormat = temp.toString();
                                } else {
                                  tempFormat = '不明';
                                }
                                return _statusRow('気温', '$tempFormat℃');
                              }(),
                              () {
                                final chanceOfRain =
                                    ref.watch(chanceOfRainProvider);
                                var formatted = '不明';
                                if (chanceOfRain >= 0) {
                                  formatted = '$chanceOfRain%';
                                }
                                return _statusRow('降水確率', formatted);
                              }()
                            ],
                          )),
                ]))));
  }
}
