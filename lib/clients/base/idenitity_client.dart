import 'dart:io';

abstract class IdentityClient {

  final String identityApiUrl;

  final HttpClient client = HttpClient();

  IdentityClient(this.identityApiUrl);

  void dispose() {
    client.close();
  }
}
