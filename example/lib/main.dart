import 'package:flutter/material.dart';
import 'package:stormra_oautter/clients/token_client.dart';
import 'package:stormra_oautter/custom_alert_box.dart';

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
  final phoneNumberTextCtlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: new Container(
          child: new Column(
            children: <Widget>[
              new RaisedButton(
                child: new Text("Resource Owner Login (Not recommended)"),
                color: Colors.blueAccent[600],
                onPressed: () async {
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                  var t = await client.requestPasswordToken(
                      'ro.client', 'secret', 'ali5', 'Linux.2000');

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
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                  await client.requestAuthorizationCodeToken(
                      'ro.client', 'secret');
                },
              ),
              TextField(
                controller: phoneNumberTextCtlr,
                decoration: new InputDecoration.collapsed(hintText: 'Your Phone Number'),
              ),
              new RaisedButton(
                child: new Text(
                    "Request a Phone Number Code"),
                color: Colors.blueAccent[600],
                onPressed: () async {
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                  await client.requestPhoneVerificationCode(phoneNumber: phoneNumberTextCtlr.text);
                },
              ),
                            TextField(
                controller: phoneVerificationCodeTextCtlr,
                decoration: new InputDecoration.collapsed(hintText: 'Your Phone Number Code'),
              ),
              new RaisedButton(
                child: new Text(
                    "Login using Mobile Number (Not OAuth2.0 Standard)"),
                color: Colors.blueAccent[600],
                onPressed: () async {
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                      var t = await client.requestPhoneVerificationToken(phoneNumber: phoneNumberTextCtlr.text,clientId:'phone_number_authentication',clientSecret: 'secret',scope: 'web_api openid profile offline_access', verificationToken: phoneVerificationCodeTextCtlr.text);
                
                  await CustomAlertBox.showCustomAlertBox(
                      context: context,
                      willDisplayWidget: Container(
                        child: Text(t.accessToken ?? t.error),
                      ));
                      
                },
              ),
              new RaisedButton(
                child: new Text(
                    "Login using Facebook Native SDK (Not OAuth2.0 Standard)"),
                color: Colors.blueAccent[600],
                onPressed: () async {
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                  await client.requestAuthorizationCodeToken(
                      'ro.client', 'secret');
                },
              ),
              new RaisedButton(
                child:
                    new Text("Login using Magic Mail (Not OAuth2.0 Standard)"),
                color: Colors.blueAccent[600],
                onPressed: () async {
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                  await client.requestAuthorizationCodeToken(
                      'ro.client', 'secret');
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await CustomAlertBox.showCustomAlertBox(
              context: context,
              willDisplayWidget: Container(
                child: Text('My custom alert box, used from example!!'),
              ));
        },
        tooltip: 'Show Custom Alert Box',
        child: Icon(Icons.message),
      ),
    );
  }
}
