import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wall_display/subscriber.dart';

enum ConnectedState { fourG, fiveG, unknown }
enum DH5GConnectionState { connected, unconnected, unknown }

// 接続状態
final connectedStateProvider =
    StateProvider<ConnectedState>((ref) => ConnectedState.unknown);

//
final dh5gConnectionProvider =
    StateProvider((ref) => DH5GConnectionState.unconnected);

final subscribingProvider = StateProvider<bool>((ref) => false);

final temperatureProvider = StateProvider<double>((ref) => -274);

final datetimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

final loadingProvider = StateProvider<bool>((ref) => false);
