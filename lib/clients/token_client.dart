import 'dart:convert';
import 'dart:io';
import 'package:stormra_oautter/models/token_response.dart';
import 'package:stormra_oautter/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'base/auth_client.dart';

class TokenClient extends AuthClient {
  final String authority;

  TokenClient(this.authority) : super(authority);

  Future<TokenResponse> requestPasswordToken(
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

  /// Authorize and Exachange code
  Future<TokenResponse> requestAuthorizationCodeToken(
      String code, String redirectUri,
      [String codeVerifie, Map<String, String> parameters]) async {
    var codeVerifier = Utils.createCryptoRandomString();
    var codeChallenge = Utils.convertTosha256(codeVerifier);
    var clientId = 'mda_mobile_native';
    var responseType = 'code';
    var state = '5ca75bd30';
    var redirectUrl = 'http://localhost:5003/callback.html';
    var scope = 'web_api';

    var authCodeWithPkce =
        'https://$authority/connect/authorize?client_id=$clientId&response_type=$responseType&state=$state&redirect_uri=$redirectUrl&scope=$scope&code_challenge_method=S256&code_challenge=$codeChallenge&acr_values=idp:Facebook';

    _launchURL(authCodeWithPkce);

    return null;
  }

  Future<TokenResponse> requestFacebookAuthorizationCodeToken() async {
    return requestAuthorizationCodeToken('', '');
  }

  Future<TokenResponse>
      requestFacebookAuthorizationCodeTokenUsingFacebookSDK() async {
    return null;
  }

  Future<bool> requestPhoneVerificationCode({String phoneNumber}) async {
    var url = 'https://$authority/api/verify_phone_number';
    Map jsonMap = {'phoneNumber': phoneNumber};

    HttpClientRequest req = await client.postUrl(Uri.parse(url));
    req.headers.set('content-type', 'application/json');
    req.add(utf8.encode(json.encode(jsonMap)));
    var response = await req.close();

    if (response.statusCode == HttpStatus.accepted ||
        response.statusCode == HttpStatus.ok) {
      // String reply = await response.transform(utf8.decoder).join();

      return true;
    }

    return false;
  }

  Future<TokenResponse> requestPhoneVerificationToken(
      {String clientId,
      String clientSecret,
      String scope,
      String verificationToken,
      String phoneNumber}) async {
    var url = 'https://$authority' + '/connect/token';

    var body = {
      'grant_type': 'phone_number_token',
      'client_id': clientId,
      'client_secret': clientSecret,
      'verification_token': verificationToken,
      'phone_number': phoneNumber
    };

    if (scope != null) {
      body['scope'] = scope;
    }

    var req = await client.postUrl(Uri.parse(url));
    req.headers.set('content-type', 'application/json');
    req.add(utf8.encode(json.encode(body)));
    var response = await req.close();

    var responseBody = await response.transform(utf8.decoder).join();
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
