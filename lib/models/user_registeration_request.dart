class UserRegisterationRequest {
  String email;
  String password;
  String confirmPassword;
  String firstName;
  String lastName;
  String userName;
  String birthDate;
  String country;

  UserRegisterationRequest(
      {this.email,
      this.password,
      this.confirmPassword,
      this.firstName,
      this.lastName,
      this.userName,
      this.birthDate,
      this.country});

  UserRegisterationRequest.fromJson(Map<String, dynamic> parsedJson)
      : email = parsedJson['email'],
        password = parsedJson['password'],
        confirmPassword = parsedJson['confirm_password'],
        firstName = parsedJson['first_name'],
        lastName = parsedJson['last_name'],
        userName = parsedJson['user_name'],
        country = parsedJson['country'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        'first_name': firstName,
        'last_name': lastName,
        'user_name': userName,
        'country': country
      };
}
