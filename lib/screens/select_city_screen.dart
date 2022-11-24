import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siraf3/themes.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background2,
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        
      ),
    );
  }
}