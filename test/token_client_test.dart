import 'package:flutter_test/flutter_test.dart';
import 'package:stormra_oautter/clients/token_client.dart';

void main() {

TestWidgetsFlutterBinding.ensureInitialized();
  test('Get password token', () async {
   final client = TokenClient('qa-mda-idsrv-app.azurewebsites.net');
   var t = await client.requestPasswordToken('ro.client','secret', 'ali5', 'Linux.2000');
   print(t.accessToken);
   print(t.expiresIn);
  });


    test('open browser', () async {
      final client = TokenClient('qa-mda-idsrv-app.azurewebsites.net');
      await client.requestAuthorizationCodeToken('','');
  });



}
