import 'dart:convert';
import 'dart:io';

import 'package:stormra_oautter/models/user_info_response.dart';

import 'base/auth_client.dart';

class UserInfoClient extends AuthClient {
 
  final String authority;
  final HttpClient _client = HttpClient();

  UserInfoClient(this.authority) : super(authority);

  Future<UserInfoResponse> getUserInfo(String accessToken) async {
    var req =
        await _client.getUrl(new Uri.https(authority, '/connect/userinfo'));
    req
      ..headers.contentType =
          new ContentType('application', 'json', charset: 'utf-8')
          ..headers.add(HttpHeaders.authorizationHeader, 'Bearer $accessToken');

    var res = await req.close();
    Map jsonRes;

    if (res.statusCode == HttpStatus.unauthorized) {
      jsonRes = jsonDecode(
              '{"error_description":"user is not authorized to request the user info."}')
          as Map;
    } else if (res.statusCode == HttpStatus.forbidden) {
      jsonRes = jsonDecode(
              '{"error_description":"You are missing a required scope of openid to be included in the access_token."}')
          as Map;
    } else if (res.statusCode == HttpStatus.ok) {
      var responseBody = await res.transform(utf8.decoder).join();
      jsonRes = jsonDecode(responseBody) as Map;
    }

    if (jsonRes != null) {
      return UserInfoResponse.fromJson(jsonRes);
    }

    return null;
  }
}
