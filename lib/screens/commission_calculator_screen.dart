import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/money_input_formatter.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/field_dialog.dart';
import 'package:siraf3/widgets/list_dialog.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/usefull/button/button_primary.dart';

import '../widgets/section.dart';

enum TradeType {
  buyAndSell,
  rentAndMortgage,
}

class CommissionCalculatorScreen extends StatefulWidget {
  @override
  State<CommissionCalculatorScreen> createState() =>
      _CommissionCalculatorScreen();
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
        padding: const EdgeInsets.only(top: 10, right: 12, left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (selectedTradeType == TradeType.buyAndSell)
              getBuyAndSellWidget(),
            if (selectedTradeType == TradeType.rentAndMortgage)
              getRentAndMortgageWidget(),
            SizedBox(
              height: 10,
            ),
            Text(
              "کمیسیون قرارداد های جعاله بصورت توافقی میباشد.",
              style: TextStyle(
                fontSize: 11,
                color: App.theme.tooltipTheme.textStyle?.color,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: ButtonPrimary(
                text: "محاسبه",
                onPressed: calculateCommission,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBuyAndSellWidget() {
    return Section(
      title: "مبلغ کل",
      hint: "تعیین",
      value: number_format(totalPrice, defaultValue: "تعیین"),
      onTap: determineTotalPrice,
    );
  }

  Widget getRentAndMortgageWidget() {
    return Column(
      children: [
        Section(
          title: "مبلغ ودیعه",
          hint: "تعیین",
          value: number_format(deposit, defaultValue: "تعیین"),
          onTap: determineDeposit,
        ),
        Section(
          title: "مبلغ اجاره",
          hint: "تعیین",
          value: number_format(rent, defaultValue: "تعیین"),
          onTap: determineRent,
        ),
      ],
    );
  }

  String? totalPriceHelpText;

  //event listeners
  void determineTotalPrice() {
    //todo: implement event listener
    showDialog2(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: totalPriceController,
          keyboardType: TextInputType.number,
          hintText: "مبلغ کل را وارد کنید",
          inputFormatters: [
            MoneyInputFormatter(mantissaLength: 0),
          ],
          helperText: totalPriceHelpText,
          onChanged: (value) {
            setState(() {
              totalPriceHelpText = value.isNotEmpty ? value.toWord() : null;
            });

            print(totalPriceHelpText);
          },
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
    showDialog2(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: depositController,
          keyboardType: TextInputType.number,
          hintText: "مبلغ ودیعه را وارد کنید",
          inputFormatters: [
            MoneyInputFormatter(mantissaLength: 0),
          ],
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
    showDialog2(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: rentController,
          keyboardType: TextInputType.number,
          hintText: "مبلغ اجاره را وارد کنید",
          inputFormatters: [
            MoneyInputFormatter(mantissaLength: 0),
          ],
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
    showDialog2(
      context: context,
      builder: (context) {
        return ListDialog(
          list: tradeTypeList,
          onItemTap: (item) {
            if (selectedTradeType != null && selectedTradeType == item["value"])
              return;

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

    if (!isValidCityAndTradeType() ||
        !isValidTotalPrice() ||
        !isValidRendAndDeposit()) {
      notify("فیلد های خالی هستند");
      return;
    }
  }

  bool isValidCityAndTradeType() => selectedCity == null || tradeType == null;

  bool isValidTotalPrice() =>
      tradeType == TradeType.buyAndSell && totalPrice == null;

  bool isValidRendAndDeposit() =>
      tradeType == TradeType.rentAndMortgage &&
      (rent == null || deposit == null);
}
