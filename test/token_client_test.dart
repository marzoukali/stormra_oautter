import 'package:flutter_test/flutter_test.dart';
import 'package:oautter/token_client.dart';

void main() {
  test('adds one to input values', () {
    final client = TokenClient('https://qa-mda-idsrv-app.azurewebsites.net');
   // expect(client.requestPasswordTokenAsync('ro.client','secret',), 3);

   var t = client.requestPasswordTokenAsync('ro.client','secret',)
  });
}
