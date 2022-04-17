import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wall_display/state.dart';

Container loadingIndicator(WidgetRef ref) {
  final loading = ref.watch(loadingProvider);
  var color = loading ? Colors.amberAccent : Colors.transparent;
  return Container(color: color, width: 10, height: 10);
}