    
     class TokenResponse
    {
         String accessToken;
         String identityToken;
         String tokenType;
         String refreshToken;
         String errorDescription;
         int  expiresIn;

         TokenResponse(this.accessToken, this.identityToken, this.tokenType, this.refreshToken, this.errorDescription, this.expiresIn);

         TokenResponse.fromJson(Map<String, dynamic> parsedJson)
         : accessToken = parsedJson['access_token'],
           identityToken = parsedJson['identity_token'],
           tokenType = parsedJson['token_type'],
           refreshToken = parsedJson['refresh_token'],
           errorDescription = parsedJson['error_description'],
           expiresIn = parsedJson['expires_in'];

    }