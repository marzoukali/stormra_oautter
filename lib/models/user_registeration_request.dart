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

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'country': country
      };
}
