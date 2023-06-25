import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:siraf3/models/user.dart';

const LOG_RESPONSE = true;

const applicationJsonUTF8 = {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'};

Future<http.Response> get(Uri url, {Map<String, String>? headers, Duration? timeout}) async {
  try {
    var req = http.get(url, headers: headers).timeout(timeout ?? Duration(seconds: 30), onTimeout: timeoutErrorResponse).catchError((_) => timeoutErrorResponse());

    return handleReq(req);
  } catch (_) {
    print(_);
    return timeoutErrorResponse();
  }
}

Future<http.Response> post(Uri url, {Object? body, Encoding? encoding, Map<String, String>? headers, Duration? timeout}) async {
  try {
    var req = http
        .post(url, body: body, encoding: encoding, headers: headers)
        .timeout(timeout ?? Duration(minutes: 30), onTimeout: timeoutErrorResponse)
        .catchError((_) => timeoutErrorResponse());

    return handleReq(req, requestBody: body);
  } catch (_) {
    print(_);
    return timeoutErrorResponse();
  }
}

Future<http.Response> getWithToken(Uri url, {Map<String, String>? headers, Duration? timeout}) async {
  if (!await User.hasToken()) {
    return authErrorResponse();
  }

  headers = (headers ?? {})
    ..addAll(
      {
        'Authorization': await User.getBearerToken(),
      },
    );

  return get(url, headers: headers, timeout: timeout);
}

Future<http.Response> postWithToken(Uri url, {Object? body, Encoding? encoding, Map<String, String>? headers, Duration? timeout}) async {
  if (!await User.hasToken()) {
    return authErrorResponse();
  }

  headers = (headers ?? {})
    ..addAll(
      {
        'Authorization': await User.getBearerToken(),
      },
    );

  return post(url, body: body, encoding: encoding, headers: headers);
}

Future<http.Response> postJsonWithToken(Uri url, {Object? body, Encoding? encoding, Map<String, String>? headers, Duration? timeout}) async {
  if (!await User.hasToken()) return authErrorResponse();

  headers = (headers ?? {})
    ..addAll(
      {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': await User.getBearerToken(),
      },
    );

  return post(url, body: jsonEncode(body), encoding: encoding, headers: headers);
}

Future<http.Response> deleteWithToken(Uri url, {Object? body, Encoding? encoding, Map<String, String>? headers, Duration? timeout}) async {
  if (!await User.hasToken()) {
    return authErrorResponse();
  }

  headers = (headers ?? {})
    ..addAll(
      {
        'Authorization': await User.getBearerToken(),
      },
    );

  return delete(url, body: body, encoding: encoding, headers: headers);
}

Future<http.Response> delete(Uri url, {Object? body, Encoding? encoding, Map<String, String>? headers, Duration? timeout}) async {
  try {
    var req = http2
        .delete(url, body: body, encoding: encoding, headers: headers)
        .timeout(timeout ?? Duration(minutes: 10), onTimeout: timeoutErrorResponse)
        .catchError((_) => timeoutErrorResponse());

    return handleReq(req, requestBody: body);
  } catch (_) {
    print(_);
    return timeoutErrorResponse();
  }
}

http.Response authErrorResponse() {
  return generateErrorResponse(message: "احراز هویت ناموفق لطفا مجدد وارد حساب کاربری شوید", statusCode: 401);
}

http.Response timeoutErrorResponse() {
  return generateErrorResponse(message: "خطا در دریافت اطلاعات مجدد تلاش کنید", statusCode: 408);
}

Future<http.Response> handleReq(Future<http.Response> req, {Object? requestBody}) async {
  var response = await req;

  if (LOG_RESPONSE && response.request != null) logRequest(response, requestBody: requestBody);

  if (response.statusCode >= 500) {
    return generateErrorResponse(message: "خطایی در سمت سرور پیش آمد لطفا بعدا تلاش کنید");
  }

  print("response.headers['content-type'] ${response.headers["content-type"]}");
  if (response.headers["content-type"] != "application/json") {
    return generateErrorResponse(message: "خطایی در سمت سرور پیش آمد لطفا بعدا تلاش کنید");
  }

  return response;
}

void logRequest(http.Response response, {Object? requestBody}) async {
  Logger logger = Logger();

  var messages = [];

  messages.add("\n\n\nREQUEST ${response.request!.method.toUpperCase()} ${response.statusCode}");

  if (await User.hasToken()) {
    messages.add("\n\nUSER TOKEN : ${await User.getBearerToken()}");
  }

  messages.add("\n\nTO :  ${Uri.decodeFull(response.request!.url.toString())}");
  messages.add("\n\nHEADERS :  ${convertUtf8(getPrettyJSONString(response.request!.headers..remove("Authorization")))}");
  messages.add("\n\nQUERIES :  ${convertUtf8(getPrettyJSONString(response.request!.url.queryParameters))}");

  messages.add("\n\n\nREQUEST BODY : ${convertUtf8(getPrettyJSONString(requestBody))}");
  messages.add("\n\n\nRESPONSE HEADERS : ${getPrettyJSONString(response.headers)}");
  try {
    messages.add("\n\n\nRESPONSE BODY : ${convertUtf8(getPrettyJSONString(jsonDecode(response.body)))}");
  } catch (e) {
    messages.add("\n\n\nRESPONSE BODY have HTML format :(");
  }

  if (response.statusCode == 200) {
    logger.i(messages.join());
  } else {
    logger.e(messages.join());
  }
}

http.Response generateErrorResponse({int statusCode = 500, String message = "خطایی غیر منتظره رخ داد"}) {
  return http.Response(
    jsonEncode({"message": encodeUtf8(message), "status": false}),
    statusCode,
    headers: applicationJsonUTF8,
  );
}

String getPrettyJSONString(jsonObject) {
  var encoder = new JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}

void logRequestDio(dio.Response response) async {
  Logger logger = Logger();
  var userToken = await User.getBearerToken();
  var messages = [];

  messages.add("\n\n\nREQUEST POST ${response.statusCode}");

  if (await User.hasToken()) {
    messages.add("\n\nUSER TOKEN : $userToken");
  }

  messages.add("\n\nTO :  ${Uri.decodeFull(response.requestOptions.baseUrl)}");
  messages.add("\n\nHEADERS :  ${convertUtf8(getPrettyJSONString(response.requestOptions.headers..remove("Authorization")))}");
  messages.add("\n\nQUERIES :  ${convertUtf8(getPrettyJSONString(response.realUri.queryParameters))}");

  messages.add("\n\n\nREQUEST BODY : ${getPrettyJSONString(response.requestOptions.data)}");
  messages.add("\n\n\nRESPONSE HEADERS : ${getPrettyJSONString(response.headers)}");
  try {
    messages.add("\nRESPONSE BODY : ${getPrettyJSONString(response.data)}");
  } catch (e) {
    messages.add("\n\n\nRESPONSE BODY have HTML format :(");
  }

  if (response.statusCode == 200) {
    logger.i(messages.join());
  } else {
    logger.e(messages.join());
  }
}
