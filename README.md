# Stormra Oautter

A Flutter package for manage identity and authentication for some stormra projects.

## Getting Started

You will find a full example on how to use the package inside `example` project.

To enable the phone Authntication flow:

- Initialize the client and request a code:

```
 new RaisedButton(
                child: new Text(
                    "Login using mobile phone number,
                color: Colors.blueAccent[300],
                onPressed: () async {
                  final client =
                      TokenClient('qa-mda-idsrv-app.azurewebsites.net');
                  await client.requestPhoneVerificationCode(phoneNumber:'+20100...');
                },
              ),
```

- When getting the code use it to request a token:

```
  final client = TokenClient('qa-mda-idsrv-app.azurewebsites.net');
  await client.requestPhoneVerificationToken(clientId:'phone_number_authentication', clientSecret:'secret', scope:'web_api openid profile', verificationToken: '...', phoneNumber: '...');
```
