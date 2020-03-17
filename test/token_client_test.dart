import 'package:flutter_test/flutter_test.dart';
import 'package:oautter/token_client.dart';

void main() {

  test('Get password token', () async {
   final client = TokenClient('qa-mda-idsrv-app.azurewebsites.net');
   var t = await client.requestPasswordTokenAsync('ro.client','secret', 'ali5', 'Linux.2000');
   print(t.accessToken);
   print(t.expiresIn);
  });


}
