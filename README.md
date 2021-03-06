# Stormra Oautter

A Flutter package for manage identity and authentication for some stormra projects.

## Getting Started

- You will find a full example on how to use the package inside `example` project.

- To include the package in your project:

     1. you can offline download it and reference it as shown inside the example's pubspec.yaml:

```
dependencies:
  flutter:
    sdk: flutter
  stormra_oautter:
    path: ../

```

     2. Or reference it from github.


## To enable the phone Authntication flow:

1. Request a code to verify the phone number:

```
     new RaisedButton(
                child: new Text(
                    "Request a Phone Number Code"),
                color: Colors.blueAccent[600],
                onPressed: () async {
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                  await client.requestPhoneVerificationCode(phoneNumber: phoneNumberTextCtlr.text);
                },
```

2. When getting the code use it to request a token:

```
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
```

- Notes:

![image](https://user-images.githubusercontent.com/16062302/77227437-111c9980-6b89-11ea-81db-71a06b313322.png)

Add the offline_access to the scope to get the refresh_token:

```
scope: 'web_api openid profile offline_access'
```




