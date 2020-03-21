import 'package:flutter_test/flutter_test.dart';
import 'package:stormra_oautter/clients/user_account_client.dart';
import 'package:stormra_oautter/models/user_registeration_request.dart';

void main() {
  test('test register a new user', () async {
    final client = UserAccountClient('qa-mda-idsrv-app.azurewebsites.net');
    var userRegisterationInfo = UserRegisterationRequest(
        email: 'email1@test.com',
        password: 'linux.2000',
        confirmPassword: 'linux.2000',
        firstName: 'ahmed',
        lastName: 'ali',
        userName: 'ali5',
        birthDate: '1990-03-17T21:50:43.001Z',
        country: 'Egypt');
    var r = await client.register(userRegisterationInfo);

    if (r.errorDescription != null) {
      print(r.errorDescription);
    } else {
      print(r.email);
    }
  });
}
