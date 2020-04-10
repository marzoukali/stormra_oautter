import 'dart:convert';
import 'dart:io';
import 'package:stormra_oautter/models/token_response.dart';
import 'package:stormra_oautter/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../models/user_info_response.dart';
import '../models/User_profile.dart';

class IdentityClient {

  final String authority;
  final String identityApi;

  final HttpClient _client = HttpClient();

  IdentityClient(this.authority, this.identityApi);

  Future<TokenResponse> requestPasswordToken(
      {String clientId, String clientSecret, String userName, String password,
      String scope}) async {
    var url = '$authority/connect/token';

    var body = {
      'grant_type': 'password',
      'client_id': clientId,
      'client_secret': clientSecret,
      'username': userName,
      'password': password
    };

    if (scope != null) {
      body['scope'] = scope;
    }
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var response = await http.post(url, body: body, headers: headers);
    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;
    return TokenResponse.fromJson(jsonResponse);
  }

    Future<TokenResponse> requestAuthorizationCodeToken(
      {String clientId,
      String state,
      String redirectUri,
      String scope,
      String acrValues}) async {
    var codeVerifier = Utils.createCryptoRandomString();
    var codeChallenge = Utils.convertTosha256(codeVerifier);
    var codeResponseType = 'code';
    var authCodeWithPkceUrl =
        '$authority/connect/authorize?client_id=$clientId&response_type=$codeResponseType&state=$state&redirect_uri=$redirectUri&scope=$scope&code_challenge_method=S256&code_challenge=$codeChallenge&acr_values=$acrValues';


    _launchURL(authCodeWithPkceUrl);

    return null;
  }

  Future<TokenResponse> exchangeExternalTokenWithIdSrvToken(
      {String clientId,
      String scope,
      String provider,
      String externalAccessToken,
      String phoneNumber}) async {
    var url = '$authority/connect/token';

    var body = {
      'grant_type': 'external_exchange_token',
      'client_id': clientId,
      'provider': provider,
      'external_token': externalAccessToken
    };

    if(phoneNumber != null && phoneNumber != '')
    {
      body['phone'] = phoneNumber;
    }

    if (scope != null && scope != '') {
      body['scope'] = scope;
    }
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    
    var response = await http.post(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }

  Future<bool> requestPhoneVerificationCode({String phoneNumber}) async {
    var url = '$identityApi/api/UserAccount/RequestPhoneVerification';

    Map jsonMap = {'phoneNumber': phoneNumber};

    HttpClientRequest req = await _client.postUrl(Uri.parse(url));
    req.headers.set('content-type', 'application/json');
    req.add(utf8.encode(json.encode(jsonMap)));
    var response = await req.close();

    if (response.statusCode == HttpStatus.accepted ||
        response.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }


    Future<bool> requestEmailVerificationCode({String email}) async {
    var url = '$identityApi/api/UserAccount/RequestEmailVerification';

    Map jsonMap = {'email': email};

    HttpClientRequest req = await _client.postUrl(Uri.parse(url));
    req.headers.set('content-type', 'application/json');
    req.add(utf8.encode(json.encode(jsonMap)));
    var response = await req.close();

    if (response.statusCode == HttpStatus.accepted ||
        response.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }



  Future<TokenResponse> requestPhoneVerificationToken(
      {String clientId,
      String scope,
      String verificationToken,
      String phoneNumber}) async {
    var url = '$authority/connect/token';

    if(phoneNumber == null || phoneNumber == '' || verificationToken == null || verificationToken == '')
    {
      throw 'Please Make Sure That the code and phone number are valid.';
    }

    var body = {
      'grant_type': 'phone_number_token',
      'client_id': clientId,
      'verification_token': verificationToken,
      'phone_number': phoneNumber
    };

    if (scope != null && scope != '') {
      body['scope'] = scope;
    }
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var response = await http.post(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }




  
  Future<TokenResponse> requestEmailCodeVerificationToken(
      {String clientId,
      String scope,
      String verificationToken,
      String email}) async {
    var url = '$authority/connect/token';

    if(email == null || email == '' || verificationToken == null || verificationToken == '')
    {
      throw 'Please Make Sure That the code and phone number are valid.';
    }

    var body = {
      'grant_type': 'email_code_token',
      'client_id': clientId,
      'verification_token': verificationToken,
      'email': email
    };

    if (scope != null && scope != '') {
      body['scope'] = scope;
    }
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var response = await http.post(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);
  }



  
  Future<TokenResponse> refreshToken(
      {String clientId,
      String refreshToken}) async {
    var url = '$authority/connect/token';

    var body = {
      'grant_type': 'refresh_token',
      'client_id': clientId,
      'refresh_token': refreshToken
    };


    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var response = await http.post(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return TokenResponse.fromJson(jsonResponse);

  }

  Future<UserInfoResponse> getUserInfo({String accessToken}) async {

 var url = '$authority/connect/userinfo';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    var response = await http.get(url, headers: headers);

 Map jsonRes;
     if (response.statusCode == HttpStatus.unauthorized) {
      jsonRes = jsonDecode(
              '{"error_description":"user is not authorized to request the user info."}')
          as Map;
    } else if (response.statusCode == HttpStatus.forbidden) {
      jsonRes = jsonDecode(
              '{"error_description":"You are missing a required scope of openid to be included in the access_token."}')
          as Map;
    } else if (response.statusCode == HttpStatus.ok) {
     var responseBody = response.body;
     jsonRes = jsonDecode(responseBody) as Map;
    }
    
    if (jsonRes != null) {
      return UserInfoResponse.fromJson(jsonRes);
    }
    return null;
  }
  
  Future<UserProfile> updateUserProfile(UserProfile userProfileUpdateRequest, {String accessToken}) async {
    
    var url = '$identityApi/api/UserProfile/UpdateUserProfileByUserId';

    if(userProfileUpdateRequest == null || userProfileUpdateRequest.appUserId == null)
    {
       throw 'UserId Should Be Provided. It can be aquired from the userInfo endpoint with key sub';
    }

    var body = jsonEncode(userProfileUpdateRequest);

    var headers = {
      'Content-Type': 'application/json'
    };

    if(accessToken != null && accessToken != '')
    {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    
    var response = await http.put(url, body: body, headers: headers);

    var responseBody = response.body;
    var jsonResponse = jsonDecode(responseBody) as Map;

    return UserProfile.fromJson(jsonResponse);
  }


  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

}
