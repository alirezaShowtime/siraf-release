import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/field_dialog.dart';
import 'package:siraf3/widgets/list_dialog.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';

import '../widgets/section.dart';

enum TradeType {
  buyAndSell,
  rentAndMortgage,
}

class CommissionCalculatorScreen extends StatefulWidget {
  @override
  State<CommissionCalculatorScreen> createState() => _CommissionCalculatorScreen();
}

class _CommissionCalculatorScreen extends State<CommissionCalculatorScreen> {
  TradeType? tradeType;
  TradeType? selectedTradeType;
  double? totalPrice;
  double? rent;
  double? deposit;
  City? selectedCity;
  TextEditingController totalPriceController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController depositController = TextEditingController();

  var tradTypeLabel = {
    TradeType.rentAndMortgage: "رهن و اجاره",
    TradeType.buyAndSell: "خرید و فروش",
  };

  List<Map<String, dynamic>> tradeTypeList = [
    {
      "name": "رهن و اجاره",
      "value": TradeType.rentAndMortgage,
    },
    {
      "name": "خرید و فروش",
      "value": TradeType.buyAndSell,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(titleText: "محاسبه کمیسیون"),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          children: [
            Section(
              title: "شهر",
              hint: "تعیین",
              value: selectedCity?.name,
              onTap: determineCity,
            ),
            Section(
              title: "نوع معامله",
              hint: "تعیین",
              value: tradTypeLabel[selectedTradeType],
              onTap: determineTradeType,
            ),
            if (selectedTradeType == TradeType.buyAndSell) getBuyAndSellWidget(),
            if (selectedTradeType == TradeType.rentAndMortgage) getRentAndMortgageWidget(),
            if (selectedTradeType != null) BlockBtn(text: "محاسبه سود", padding: EdgeInsets.only(top: 15), onTap: calculateCommission),
          ],
        ),
      ),
    );
  }

  Widget getBuyAndSellWidget() {
    return Section(
      title: "مبلغ کل",
      hint: "تعیین",
      value: totalPriceController.value.text.isNotEmpty ? totalPriceController.value.text : null,
      onTap: determineTotalPrice,
    );
  }

  Widget getRentAndMortgageWidget() {
    return Column(
      children: [
        Section(
          title: "مبلغ ودیعه",
          hint: "تعیین",
          value: depositController.value.text.isNotEmpty ? depositController.value.text : null,
          onTap: determineDeposit,
        ),
        Section(
          title: "مبلغ اجاره",
          hint: "تعیین",
          value: rentController.value.text.isNotEmpty ? rentController.value.text : null,
          onTap: determineRent,
        ),
      ],
    );
  }

  //event listeners
  void determineTotalPrice() {
    //todo: implement event listener
    showDialog(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: totalPriceController,
          keyboardType: TextInputType.number,
          hintText: "مبلغ را وارد کنید",
          onPressed: () {
            totalPrice = double.parse(totalPriceController.value.text);
            deposit = 0;
            rent = 0;
            setState(() {});
          },
        );
      },
    );
  }

  void determineDeposit() {
    //todo: implement event listener
    showDialog(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: depositController,
          keyboardType: TextInputType.number,
          hintText: "مبلغ را وارد کنید",
          onPressed: () {
            deposit = double.parse(depositController.value.text);
            totalPrice = 0;
            setState(() {});
          },
        );
      },
    );
  }

  void determineRent() {
    //todo: implement event listener
    showDialog(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: rentController,
          keyboardType: TextInputType.number,
          hintText: "مبلغ را وارد کنید",
          onPressed: () {
            rent = double.parse(rentController.value.text);
            totalPrice = 0;
            setState(() {});
          },
        );
      },
    );
  }

  void determineCity() {
    //todo: implement event listener

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectCityScreen(
          max: 1,
          saveCity: false,
        ),
      ),
    ).then((result) {
      if (result != null && result is List<City>) {
        selectedCity = result.first;
        setState(() {});
      }
    });
  }

  void determineTradeType() {
    //todo: implement event listener

    showDialog(
      context: context,
      builder: (context) {
        return ListDialog(
          list: tradeTypeList,
          onItemTap: (item) {
            if (selectedTradeType != null && selectedTradeType == item["value"]) return;

            selectedTradeType = item["value"];
            Navigator.pop(context);
            setState(() {});
          },
        );
      },
    );
  }

  void calculateCommission() {
    //todo: implement event listener

    if (!isValidCityAndTradeType() || !isValidTotalPrice() || !isValidRendAndDeposit()) {
      notify("فیلد های خالی هستند");
      return;
    }
  }

  bool isValidCityAndTradeType() => selectedCity == null || tradeType == null;

  bool isValidTotalPrice() => tradeType == TradeType.buyAndSell && totalPrice == null;

  bool isValidRendAndDeposit() => tradeType == TradeType.rentAndMortgage && (rent == null || deposit == null);
}
