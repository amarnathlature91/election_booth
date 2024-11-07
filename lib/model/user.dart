import 'package:election_booth/model/user_roles.dart';

class User {
  final String? token;
  final String? type;
  final int? id;
  final String? username;
  final dynamic email;
  final dynamic designation;
  final List<Roles> roles;
  final int? roleId;
  final String? message;
  final String? status;
  final dynamic schoolName;
  final String? firstName;
  final String? lastName;
  final dynamic schoolId;
  final dynamic address;
  final bool? cropAdded;
  final String? accessToken;
  final String? tokenType;

  User({
    this.token,
    this.type,
    this.id,
    this.username,
    this.email,
    this.designation,
    this.roles = const [Roles.ROLE_YAADI_LEADER],
    this.roleId,
    this.message,
    this.status,
    this.schoolName,
    this.firstName,
    this.lastName,
    this.schoolId,
    this.address,
    this.cropAdded,
    this.accessToken,
    this.tokenType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json["token"] ?? '',
      type: json["type"] ?? '',
      id: json["id"] ?? '',
      username: json["username"] ?? '',
      email: json["email"] ?? '',
      designation: json["designation"] ?? '',
      roles: json["roles"] == null || json["roles"] is! List
          ? [Roles.ROLE_CORE_COMMITTEE]
          : (json["roles"] as List<dynamic>).map((r) {
              var rl = r.toString().toLowerCase();
              if (rl.contains('admin')) {
                return Roles.ROLE_ADMIN;
              } else if (rl.contains('leader')) {
                return Roles.ROLE_YAADI_LEADER;
              } else {
                return Roles.ROLE_CORE_COMMITTEE;
              }
            }).toList(),
      roleId: json["roleId"] ?? '',
      message: json["message"] ?? '',
      status: json["status"] ?? '',
      schoolName: json["schoolName"] ?? '',
      firstName: json["firstName"] ?? '',
      lastName: json["lastName"] ?? '',
      schoolId: json["schoolId"] ?? '',
      address: json["address"] ?? '',
      cropAdded: json["cropAdded"] ?? '',
      accessToken: json["accessToken"] ?? '',
      tokenType: json["tokenType"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "type": type,
        "id": id,
        "username": username,
        "email": email,
        "designation": designation,
        "roles": roles,
        "roleId": roleId,
        "message": message,
        "status": status,
        "schoolName": schoolName,
        "firstName": firstName,
        "lastName": lastName,
        "schoolId": schoolId,
        "address": address,
        "cropAdded": cropAdded,
        "accessToken": accessToken,
        "tokenType": tokenType,
      };
}
