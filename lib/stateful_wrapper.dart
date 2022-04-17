import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;

  StatefulWrapper(this.onInit, this.child);

  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
