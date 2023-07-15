import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:siraf3/themes.dart';

class MySwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MySwitch();

  bool value;
  bool disable;
  void Function(bool) onToggle;

  MySwitch({required this.onToggle, required this.value, this.disable = false});
}

class _MySwitch extends State<MySwitch> {
  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      height: 20.0,
      width: 40.0,
      padding: 3.0,
      toggleSize: 10.0,
      borderRadius: 20.0,
      disabled: widget.disable,
      activeColor: Themes.blue,
      inactiveColor: Colors.transparent,
      value: widget.value,
      inactiveSwitchBorder: Border.all(color: Themes.primary, width: 2.5),
      activeToggleColor: Colors.white,
      inactiveToggleColor: Themes.blue,
      onToggle: widget.onToggle,
    );
  }
}
