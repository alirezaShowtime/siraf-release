import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';
import 'package:http/http.dart' as http;

const LOG_RESPONSE = true;

Future<http.Response> get(Uri url,
    {Map<String, String>? headers, Duration? timeout}) async {
  try {
    return handleReq(
      http
          .get(url, headers: headers)
          .timeout(
            timeout ?? Duration(seconds: 20),
            onTimeout: () => timeoutErrorResponse(),
          )
          .catchError((_) {
        return timeoutErrorResponse();
      }),
    );
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
    return handleReq(
      http
          .post(url, body: body, encoding: encoding, headers: headers)
          .timeout(
            timeout ?? Duration(minutes: 10),
            onTimeout: () => timeoutErrorResponse(),
          )
          .catchError((_) {
        return timeoutErrorResponse();
      }),
    );
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

Future<http.Response> delete(Uri url,
    {Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    Duration? timeout}) async {
  try {
    return handleReq(
      http
          .delete(url, body: body, encoding: encoding, headers: headers)
          .timeout(
            timeout ?? Duration(minutes: 10),
            onTimeout: () => timeoutErrorResponse(),
          )
          .catchError((_) {
        return timeoutErrorResponse();
      }),
    );
  } catch (_) {
    return timeoutErrorResponse();
  }
}

Future<http.Response> deleteWithToken(Uri url,
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

  return delete(url, headers: headers, timeout: timeout);
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

Future<http.Response> handleReq(Future<http.Response> req) async {
  var response = await req;
  if (LOG_RESPONSE) {
    print("REQUEST : " +
        (response.request?.method.toString() ?? "") +
        " " +
        (response.request?.url.toString() ?? ""));
    print("RESPONSE STATUS CODE : " + response.statusCode.toString());
    print("RESPONSE STATUS CODE : " + response.statusCode.toString());
    print("RESPONSE BODY UTF8 : " + convertUtf8(response.body));
    print("RESPONSE BODY RAW : " + response.body);
  }

  return response;
}
