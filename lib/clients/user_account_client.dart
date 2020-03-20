import 'dart:convert';
import 'dart:io';

import 'package:stormra_oautter/models/user_registeration_request.dart';
import 'package:stormra_oautter/models/user_registeration_response.dart';

import 'base/idenitity_client.dart';



class UserAccountClient extends IdentityClient {
  final String identityApiUrl;

  UserAccountClient(this.identityApiUrl) : super(identityApiUrl);

  Future<UserRegisterationResponse> register(UserRegisterationRequest registrationInfo) async {
    
    var req = await client.postUrl(new Uri.https(identityApiUrl, '/api/Account/Register'));
    var json = jsonEncode(registrationInfo);

    req
      ..headers.contentType = new ContentType(
          'application', 'json',
          charset: 'utf-8')
      ..write(json);

    var res = await req.close();
    var responseBody = await res.transform(utf8.decoder).join();
    var jsonResponse = jsonDecode(responseBody) as Map;

    return UserRegisterationResponse.fromJson(jsonResponse);
  }
}
