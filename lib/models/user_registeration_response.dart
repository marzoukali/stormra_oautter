class UserRegisterationResponse {
  String id;
  String email;
  String name;
  String isEnabled;
  String phoneNumber;
  String errorDescription;

  UserRegisterationResponse(this.id, this.email, this.name, this.isEnabled,
      this.phoneNumber, this.errorDescription);

  UserRegisterationResponse.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['sub'],
        email = parsedJson['email'],
        name = parsedJson['name'],
        isEnabled = parsedJson['is_enabled'],
        phoneNumber = parsedJson['phone_number'],
        errorDescription = parsedJson['error_description'];
}
