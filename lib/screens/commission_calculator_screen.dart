import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:siraf3/bloc/commission_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/money_input_formatter.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/field_dialog.dart';
import 'package:siraf3/widgets/list_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/try_again.dart';
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

  CommissionBloc bloc = CommissionBloc();

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
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
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
              BlocBuilder<CommissionBloc, CommissionState>(builder: _buildBloc),
            ],
          ),
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
            if (!totalPriceController.text.isFill()) {
              totalPrice = null;
            } else {
              totalPrice = double.parse(
                  totalPriceController.value.text.replaceAll(',', ''));
            }
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
            if (!depositController.text.isFill()) {
              deposit = null;
            } else {
              deposit = double.parse(
                  depositController.value.text.replaceAll(',', ''));
            }
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
            if (!rentController.text.isFill()) {
              rent = null;
            } else {
              rent =
                  double.parse(rentController.value.text.replaceAll(',', ''));
            }
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
            if (selectedTradeType == TradeType.buyAndSell) {
              rent = null;
              deposit = null;
            } else {
              totalPrice = null;
            }
            Navigator.pop(context);
            setState(() {});
          },
        );
      },
    );
  }

  void calculateCommission() {
    if (selectedCity == null || isInvalidType()) {
      notify("لطفا همه فیلد ها را پر کنید");
      return;
    }

    bloc.add(
      CommissionCalculateEvent(
        city: selectedCity!,
        tradeType: selectedTradeType!,
        totalPrice: totalPrice,
        deposit: deposit,
        rent: rent,
      ),
    );
  }

  bool isInvalidType() =>
      (selectedTradeType == TradeType.buyAndSell && totalPrice == null) ||
      (selectedTradeType == TradeType.rentAndMortgage &&
          (rent == null || deposit == null));

  Widget _buildBloc(BuildContext context, CommissionState state) {
    if (state is CommissionLoadingState) {
      return Expanded(
          child: Center(
        child: Loading(),
      ));
    }

    if (state is CommissionInitState) {
      return Container();
    }

    if (state is CommissionErrorState) {
      var message = jDecode(state.response.body)['message'] as String?;

      return Expanded(
          child: Center(
        child: TryAgain(
          message: message,
        ),
      ));
    }

    var data = state as CommissionLoadedState;

    if (data.tradeType == TradeType.buyAndSell) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 13,
            ),
            Text(
              "نتیجه",
              style: TextStyle(
                fontSize: 14,
                fontFamily: "IranSansBold",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "مبلغ پرداختی",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "IranSansMedium",
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "برای هر طرف به صورت مساوی",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "IranSans",
                      ),
                    ),
                  ],
                ),
                Text(
                  price_text(state.total),
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansMedium",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              height: 0.3,
              color: Themes.textGrey.withOpacity(0.5),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 13,
          ),
          Text(
            "نتیجه",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "IranSansBold",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مبلغ موجر",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "IranSansMedium",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "60 درصد با موجر می باشد",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: "IranSans",
                    ),
                  ),
                ],
              ),
              Text(
                price_text(state.mojer),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "IranSansMedium",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 0.3,
            color: Themes.textGrey.withOpacity(0.5),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مبلغ مستاجر",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "IranSansMedium",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "40 درصد با مستاجر می باشد",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: "IranSans",
                    ),
                  ),
                ],
              ),
              Text(
                price_text(state.mostajer),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "IranSansMedium",
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 0.3,
            color: Themes.textGrey.withOpacity(0.5),
          )
        ],
      ),
    );
  }
}
