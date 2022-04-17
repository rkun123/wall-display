import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wall_display/state.dart';
import 'package:intl/intl.dart';



Row clock(WidgetRef ref) {
  var datetime = ref.watch(datetimeProvider);

  var f = NumberFormat('00');
  final year = NumberFormat('0000').format(datetime.year);
  final month = f.format(datetime.month);
  final day = f.format(datetime.day);

  final hours = f.format(datetime.hour);
  final minutes = f.format(datetime.minute);
  // final seconds = f.format(datetime.second);


  var baseStyle = const TextStyle(fontSize: 180.0 ,color: Colors.white, fontWeight: FontWeight.bold);
  // final separator = Text(':', style: baseStyle.copyWith(fontWeight: FontWeight.normal));
  return Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('$hours:$minutes', style: baseStyle),
      Text('$year/$month/$day', style: baseStyle.copyWith(fontSize: 60.0))
    ]
  );
}