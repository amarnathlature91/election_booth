class Voter {
  final int id;
  final String fullName;
  final String fullNameInMarathi;
  final String voterId;
  final String address;
  final DateTime dob;
  final String mobNo;
  final String votingCenter;
  final String yaadiLeadName;
  final int yaadiLeadId;
  final String yaadiLeadMobNo;
  final bool nameInYaadi;
  late bool voted;
  final int totalCount;

  Voter({
    required this.id,
    required this.fullName,
    required this.fullNameInMarathi,
    required this.voterId,
    required this.address,
    required this.dob,
    required this.mobNo,
    required this.votingCenter,
    required this.yaadiLeadName,
    required this.yaadiLeadId,
    required this.yaadiLeadMobNo,
    required this.nameInYaadi,
    required this.voted,
    required this.totalCount,
  });

  factory Voter.fromJson(Map<String, dynamic> json) {
    return Voter(
      id: json["id"] ?? 0,
      fullName: json["fullName"] ?? "",
      fullNameInMarathi: json["fullNameInMarathi"] ?? "",
      voterId: json["voterId"] ?? "",
      address: json["address"] ?? "",
      dob: json['dob'] != null
          ? DateTime.tryParse(json["dob"]) ?? DateTime.now()
          : DateTime.now(),
      mobNo: json["mobNo"] ?? "",
      votingCenter: json["votingCenter"] ?? "",
      yaadiLeadName: json["yaadiLeadName"] ?? "",
      yaadiLeadId: json["yaadiLeadId"] ?? 0,
      yaadiLeadMobNo: json["yaadiLeadMobNo"] ?? "",
      nameInYaadi: json["nameInYaadi"] ?? false,
      voted: json["voted"] ?? false,
      totalCount: json["totalCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "fullNameInMarathi": fullNameInMarathi,
        "voterId": voterId,
        "address": address,
        "dob": dob,
        "mobNo": mobNo,
        "votingCenter": votingCenter,
        "yaadiLeadName": yaadiLeadName,
        "yaadiLeadId": yaadiLeadId,
        "yaadiLeadMobNo": yaadiLeadMobNo,
        "nameInYaadi": nameInYaadi,
        "voted": voted,
        "totalCount": totalCount,
      };
}
