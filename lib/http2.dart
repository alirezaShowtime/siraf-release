import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';

Future<http.Response> get(Uri url,
    {Map<String, String>? headers, Duration? timeout}) async {
  try {
    return http
        .get(url, headers: headers)
        .timeout(
          timeout ?? Duration(seconds: 60), // todo temporary (change to 20 sec)
          onTimeout: () => timeoutErrorResponse(),
        )
        .catchError((_) {
      return timeoutErrorResponse();
    });
  } catch (_) {
    return timeoutErrorResponse();
  }
}

Future<http.Response> post(Uri url,
    {Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    Duration? timeout}) async {
  try {
    return http
        .post(url, body: body, encoding: encoding, headers: headers)
        .timeout(
          timeout ?? Duration(minutes: 10),
          onTimeout: () => timeoutErrorResponse(),
        )
        .catchError((_) {
      return timeoutErrorResponse();
    });
  } catch (_) {
    return timeoutErrorResponse();
  }
}

Future<http.Response> getWithToken(Uri url,
    {Map<String, String>? headers, Duration? timeout}) async {
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

Future<http.Response> postWithToken(Uri url,
    {Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    Duration? timeout}) async {
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

Future<http.Response> postJsonWithToken(Uri url,
    {Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    Duration? timeout}) async {
  if (!await User.hasToken()) {
    return authErrorResponse();
  }

  headers = (headers ?? {})
    ..addAll(
      {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': await User.getBearerToken(),
      },
    );

  return post(url,
      body: jsonEncode(body), encoding: encoding, headers: headers);
}

http.Response authErrorResponse() {
  return http.Response(
      jsonEncode({
        "message":
            encodeUtf8("احراز هویت ناموفق لطفا مجدد وارد حساب کاربری شوید"),
        "status": false
      }),
      401,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
      });
}

http.Response timeoutErrorResponse() {
  return http.Response(
      jsonEncode({
        "message": encodeUtf8("خطا در دریافت اطلاعات مجدد تلاش کنید"),
        "status": false
      }),
      408,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
      });
}
