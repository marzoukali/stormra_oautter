import 'package:flutter_test/flutter_test.dart';
import 'package:stormra_oautter/clients/user_account_client.dart';
import 'package:stormra_oautter/models/user_registeration_request.dart';

void main() {

  test('test register a new user', () async {
    
   final client = UserAccountClient('qa-mda-idsrv-app.azurewebsites.net');
   var userRegisterationInfo = UserRegisterationRequest('email1@test.com','linux.2000', 'linux.2000', 'ahmed', 'ali', 'ali5', '1990-03-17T21:50:43.001Z', 'egypt');
   var r = await client.register(userRegisterationInfo);

   if(r.errorDescription != null)
   {
   print(r.errorDescription);
   }else{
     print(r.email);
   }

  });


}
