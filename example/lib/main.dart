import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stormra_oautter/clients/identity_client.dart';
import 'package:stormra_oautter/custom_alert_box.dart';
import 'package:stormra_oautter/models/User_profile.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stormra OAutther Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Stormra OAutther Package'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final phoneVerificationCodeTextCtlr = TextEditingController();
  final emailVerificationCodeTextCtlr = TextEditingController();
  final phoneNumberTextCtlr = TextEditingController();
  final emailTextCtlr = TextEditingController();
  String currentRefreshToken = '';
  String currentAccessToken = '';

  final _client = IdentityClient('https://qa-mda-idsrv-app.azurewebsites.net',
      'https://qa-mda-apis.azurewebsites.net');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text("Resource Owner Login (Not recommended)"),
              color: Colors.blueAccent[600],
              onPressed: () async {
                var t = await _client.requestPasswordToken(
                    clientId: '7d04449291c5',
                    clientSecret: 'a06a29e8b7c6',
                    userName: 'alice',
                    password: 'My long 123\$ password',
                    scope: 'mda_api openid profile');

                await CustomAlertBox.showCustomAlertBox(
                    context: context,
                    willDisplayWidget: Container(
                      child: Text(t.accessToken),
                    ));
              },
            ),
            new RaisedButton(
              child: new Text(
                  "(Facebook) Login using Authorization Code with PKCE (OAuth2.0 Recommended)"),
              color: Colors.blueAccent[300],
              onPressed: () async {
                await _client.requestAuthorizationCodeToken(
                    clientId: 'ea05a6d574fb',
                    state: '5ca75bd30',
                    redirectUri:
                        'https://qa-mda-idsrv-app.azurewebsites.net/callback.html',
                    scope: 'mda_api',
                    acrValues: 'idp:Facebook');
              },
            ),
            TextField(
              controller: phoneNumberTextCtlr,
              decoration:
                  new InputDecoration.collapsed(hintText: 'Your Phone Number'),
            ),
            new RaisedButton(
              child: new Text("Request a Phone Number Code"),
              color: Colors.blueAccent[600],
              onPressed: () async {
                var isItReal = await _client.requestPhoneVerificationCode(
                    phoneNumber: phoneNumberTextCtlr.text);

                if (isItReal) {
                  await CustomAlertBox.showCustomAlertBox(
                      context: context,
                      willDisplayWidget: Container(
                        child: Text("Woooh Wait The Message Baby!"),
                      ));
                } else {
                  await CustomAlertBox.showCustomAlertBox(
                      context: context,
                      willDisplayWidget: Container(
                        child: Text("Sorry Something Went Wrong!"),
                      ));
                }
              },
            ),
            TextField(
              controller: phoneVerificationCodeTextCtlr,
              decoration: new InputDecoration.collapsed(
                  hintText: 'Your Phone Number Code'),
            ),
            new RaisedButton(
              child:
                  new Text("Login using Mobile Number (Not OAuth2.0 Standard)"),
              color: Colors.blueAccent[600],
              onPressed: () async {
                var t = await _client.requestPhoneVerificationToken(
                    phoneNumber: phoneNumberTextCtlr.text,
                    clientId: 'fdf6e0055853',
                    scope: 'profile openid mda_api offline_access',
                    verificationToken: phoneVerificationCodeTextCtlr.text);

                if (t.refreshToken != null && t.refreshToken != '') {
                  currentAccessToken = t.accessToken;
                }

                if (t.refreshToken != null && t.refreshToken != '') {
                  currentRefreshToken = t.refreshToken;
                }

                await CustomAlertBox.showCustomAlertBox(
                    context: context,
                    willDisplayWidget: Container(
                      child: Text(t.accessToken ?? t.error),
                    ));

                var user =
                    await _client.getUserInfo(accessToken: t.accessToken);

                await CustomAlertBox.showCustomAlertBox(
                    context: context,
                    willDisplayWidget: Container(
                      child: Text(user.phoneNumber ?? user.errorDescription),
                    ));

                var userProfile =
                    new UserProfile(appUserId: user.id, firstName: 'Lol');

               // var userAfterUpdate =
                  //  await _client.updateUserProfile(userProfile,accessToken: t.accessToken);

                // await CustomAlertBox.showCustomAlertBox(
                //     context: context,
                //     willDisplayWidget: Container(
                //       child: Text(userAfterUpdate.firstName),
                //     ));
              },
            ),
            TextField(
              controller: emailTextCtlr,
              decoration: new InputDecoration.collapsed(hintText: 'Your Email'),
            ),
            new RaisedButton(
              child: new Text("Request an Email Code"),
              color: Colors.blueAccent[600],
              onPressed: () async {
                var isItReal = await _client.requestEmailVerificationCode(
                    email: emailTextCtlr.text);

                if (isItReal) {
                  await CustomAlertBox.showCustomAlertBox(
                      context: context,
                      willDisplayWidget: Container(
                        child: Text("Woooh Wait The Message Baby!"),
                      ));
                } else {
                  await CustomAlertBox.showCustomAlertBox(
                      context: context,
                      willDisplayWidget: Container(
                        child: Text("Sorry Something Went Wrong!"),
                      ));
                }
              },
            ),
            TextField(
              controller: emailVerificationCodeTextCtlr,
              decoration:
                  new InputDecoration.collapsed(hintText: 'Your Email Code'),
            ),
            new RaisedButton(
              child: new Text("Login using Email (Not OAuth2.0 Standard)"),
              color: Colors.blueAccent[600],
              onPressed: () async {
                var t = await _client.requestEmailCodeVerificationToken(
                    email: emailTextCtlr.text,
                    clientId: '3ad437ac0aee',
                    scope: 'profile openid mda_api offline_access',
                    verificationToken: emailVerificationCodeTextCtlr.text);

                await CustomAlertBox.showCustomAlertBox(
                    context: context,
                    willDisplayWidget: Container(
                      child: Text(t.accessToken ?? t.errorDescription),
                    ));
              },
            ),
            new RaisedButton(
              child: new Text(
                  "Login using Facebook Native SDK (Not OAuth2.0 Standard)"),
              color: Colors.blue[600],
              onPressed: () async {
                final acessToken = await requestFacebookTokenUsingFacebookSDK();

                print(acessToken);

                await CustomAlertBox.showCustomAlertBox(
                    context: context,
                    willDisplayWidget: Container(
                      child: Text(acessToken),
                    ));

                var t = await _client.exchangeExternalTokenWithIdSrvToken(
                    clientId: '7daaca0f2102',
                    provider: 'Facebook',
                    phoneNumber: phoneNumberTextCtlr.text,
                    externalAccessToken: acessToken,
                    scope: 'profile openid mda_api offline_access');

                await CustomAlertBox.showCustomAlertBox(
                    context: context,
                    willDisplayWidget: Container(
                      child: Text('Our Access Token: ${t.accessToken}'),
                    ));
              },
            ),
            new RaisedButton(
              child: new Text(
                  "Login using Google Native SDK (Not OAuth2.0 Standard)"),
              color: Colors.red[600],
              onPressed: () async {
                _googleSignIn.signIn().then((result) {
                  result.authentication.then((googleKey) async {
                    print(googleKey.accessToken);
                    // print(googleKey.idToken);
                    // print(_googleSignIn.currentUser.displayName);
                    CustomAlertBox.showCustomAlertBox(
                        context: context,
                        willDisplayWidget: Container(
                          child: Text(googleKey.accessToken),
                        ));

                    var t = await _client.exchangeExternalTokenWithIdSrvToken(
                        clientId: '7daaca0f2102',
                        provider: 'Google',
                        phoneNumber: phoneNumberTextCtlr.text,
                        externalAccessToken: googleKey.accessToken,
                        scope: 'profile openid mda_api offline_access');

                    await CustomAlertBox.showCustomAlertBox(
                        context: context,
                        willDisplayWidget: Container(
                          child: Text('Our Access Token: ${t.accessToken}'),
                        ));
                  }).catchError((err) {
                    print('inner error $err');
                  });
                }).catchError((err) {
                  print('error occured  $err');
                });
              },
            ),
            new RaisedButton(
              child: new Text("Refresh Token)"),
              color: Colors.blueAccent[600],
              onPressed: () async {
                if (currentRefreshToken == null || currentRefreshToken == '') {
                  CustomAlertBox.showCustomAlertBox(
                      context: context,
                      willDisplayWidget: Container(
                        child: Text('Error Ya Man'),
                      ));
                } else {
                  var r = await _client.refreshToken(
                      clientId: 'fdf6e0055853',
                      refreshToken: currentRefreshToken);

                  CustomAlertBox.showCustomAlertBox(
                      context: context,
                      willDisplayWidget: Container(
                        child: Text(r.accessToken ?? r.errorDescription),
                      ));
                }
              },
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Show Custom Alert Box',
        child: Icon(Icons.message),
      ),
    );
  }

  Future<String> requestFacebookTokenUsingFacebookSDK() async {
    try {
      FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
      final accessToken = facebookLoginResult.accessToken.token;
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        return accessToken;
      }

      return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }
}
