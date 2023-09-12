import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/screens/commission_calculator_screen.dart';

class CommissionCalculateEvent {
  City city;
  TradeType tradeType;
  double? totalPrice;
  double? rent;
  double? deposit;

  CommissionCalculateEvent({required this.city, required this.tradeType, this.totalPrice, this.rent, this.deposit});

  Map<String, dynamic> toMap() => {
        "cityId": city.id,
        "type": tradeType == TradeType.rentAndMortgage ? 2 : 1,
        "total": (tradeType == TradeType.rentAndMortgage ? deposit : totalPrice)?.toInt(),
        if (tradeType == TradeType.rentAndMortgage) "rent": rent?.toInt()
      };
}

class CommissionState {}

class CommissionInitState extends CommissionState {}

class CommissionLoadingState extends CommissionState {}

class CommissionLoadedState extends CommissionState {
  TradeType tradeType;
  double? total;
  double? tarafAval;
  double? tarafDovom;
  double? tarafAvalPercent;
  double? tarafDovomPercent;

  CommissionLoadedState({required this.tradeType, this.total, this.tarafAval, this.tarafDovom, this.tarafAvalPercent, this.tarafDovomPercent});
}

class CommissionErrorState extends CommissionState {
  Response response;

  CommissionErrorState({required this.response});
}

class CommissionBloc extends Bloc<CommissionCalculateEvent, CommissionState> {
  CommissionBloc() : super(CommissionInitState()) {
    on(_onEvent);
  }

  _onEvent(CommissionCalculateEvent event, Emitter<CommissionState> emit) async {
    emit(CommissionLoadingState());

    var response = await http2.post(getFileUrl("commission/calculateCommission/"), body: jsonEncode(event.toMap()), headers: {
      "Content-Type": "application/json",
    });

    if (isResponseOk(response)) {
      var json = jDecode(response.body);
      if (event.tradeType == TradeType.rentAndMortgage) {
        emit(CommissionLoadedState(
          tradeType: event.tradeType,
          total: json['data']['price'],
          tarafAval: json['data']['landlord'] * json['data']['price'],
          tarafDovom: json['data']['lessor'] * json['data']['price'],
          tarafAvalPercent: json['data']['landlord'],
          tarafDovomPercent: json['data']['lessor'],
        )); // todo fix after fix API
      } else {
        emit(
          CommissionLoadedState(
            tradeType: event.tradeType,
            total: json['data']['price'],
            tarafAval: json['data']['landlord'] * json['data']['price'],
            tarafDovom: json['data']['lessor'] * json['data']['price'],
            tarafAvalPercent: json['data']['landlord'],
            tarafDovomPercent: json['data']['lessor'],
          ),
        );
      }
    } else {
      emit(CommissionErrorState(response: response));
    }
  }
}
