import 'dart:convert';
import 'dart:io';

import 'package:oautter/auth_client.dart';

import 'models/token_response.dart';

class TokenClient extends AuthClient {
  
  final String authority;

  TokenClient(this.authority):super(authority);

  Future<TokenResponse> requestPasswordTokenAsync(
      String clientId, String clientSecret, String userName, String password,
      [String scope]) async {
    var req = await client.postUrl(new Uri.https(authority, '/connect/token'));
    var toWrite =
        'grant_type=password&username=$userName&password=$password&client_id=$clientId&client_secret=$clientSecret';

    if (scope != null) {
      toWrite += '&scope=$scope';
    }

    req
      ..headers.contentType = new ContentType(
          'application', 'x-www-form-urlencoded',
          charset: 'utf-8')
      ..write(toWrite);

    var res = await req.close();
    var responseBody = await res.transform(utf8.decoder).join();
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }
}
