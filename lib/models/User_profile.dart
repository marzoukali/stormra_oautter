class UserProfile {
  String appUserId;
  String countryId;
  String firstName;
  String lastName;
  DateTime  dateOfBirth;
  int gender;
  double height;
  int ethnicity;
  int sect;
  int maritalStatus;
  bool isRegistrationCompleted;


  UserProfile(
      {this.appUserId,
      this.countryId,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.gender,
      this.height,
      this.ethnicity,
      this.sect,
      this.maritalStatus,
      this.isRegistrationCompleted});

  UserProfile.fromJson(Map<String, dynamic> parsedJson)
      : appUserId = parsedJson['appUserId'],
        countryId = parsedJson['countryId'],
        firstName = parsedJson['firstName'],
        lastName = parsedJson['lastName'],
        dateOfBirth = parsedJson['dateOfBirth'],
        gender = parsedJson['gender'],
        height = parsedJson['height'],
        ethnicity = parsedJson['ethnicity'],
        sect = parsedJson['sect'],
        maritalStatus = parsedJson['maritalStatus'],
        isRegistrationCompleted = parsedJson['isRegistrationCompleted'];

  Map<String, dynamic> toJson() => {
        'appUserId': appUserId,
        'countryId': countryId,
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'height': height,
        'ethnicity': ethnicity,
        'maritalStatus': maritalStatus,
        'isRegistrationCompleted': isRegistrationCompleted
      };
}
