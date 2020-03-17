import 'dart:io';

import 'models/token_response.dart';

class TokenClient{

  final String authority;
  final HttpClient _client =  HttpClient();
  

  TokenClient(this.authority);

        Future<TokenResponse>  requestPasswordTokenAsync(String clientId, String clientSecret, String userName, String password, String scope) async
        {
           var req = await _client.postUrl(new Uri.https(authority, '/connect/token'));
           
           req
           ..headers.contentType = new ContentType(
          'application', 'x-www-form-urlencoded', charset: 'utf-8')
          ..write('grant_type=password&username=$userName&password=$password&client_id=$clientId&client_secret=$clientSecret');
          
          var res = await req.close();
        }


}