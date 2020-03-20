import 'package:flutter_test/flutter_test.dart';
import 'package:stormra_oautter/clients/token_client.dart';
import 'package:stormra_oautter/clients/user_info_client.dart';

void main() {

  test('Get user info', () async {
     final client1 = TokenClient('qa-mda-idsrv-app.azurewebsites.net');
   var t = await client1.requestPasswordToken('ro.client','secret', 'ali5', 'Linux.2000');

   final client = UserInfoClient('qa-mda-idsrv-app.azurewebsites.net');
   var r = await client.getUserInfo(t.accessToken);

   if(r.errorDescription != null)
   {
   print(r.errorDescription);
   }else{
     print(r.email);
   }

  });


}
