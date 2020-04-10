class TokenResponse {
  String accessToken;
  String identityToken;
  String tokenType;
  String refreshToken;
  String errorDescription;
  int expiresIn;
  String error;
  String scope;


  TokenResponse({
    this.accessToken,
    this.identityToken,
    this.tokenType,
    this.refreshToken,
    this.errorDescription,
    this.expiresIn,
    this.error,
    this.scope
  });

  TokenResponse.fromJson(Map<String, dynamic> parsedJson)
      : accessToken = parsedJson['access_token'],
        identityToken = parsedJson['id_token'],
        tokenType = parsedJson['token_type'],
        refreshToken = parsedJson['refresh_token'],
        errorDescription = parsedJson['error_description'],
        error = parsedJson['error'],
        expiresIn = parsedJson['expires_in'],
        scope = parsedJson['scope'];

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'id_token': identityToken,
        'token_type': tokenType,
        'refresh_token': refreshToken,
        'error_description': errorDescription,
        'error': error,
        'expires_in': expiresIn
      };
}
