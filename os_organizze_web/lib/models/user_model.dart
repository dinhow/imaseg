class UserModel {
  String? userId;
  String? firstName;
  String? lastName;
  String? username;
  int? userlevel;
  String? createdAt;

  UserModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.username,
      this.userlevel,
      this.createdAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    userlevel = json['userlevel'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['userlevel'] = userlevel;
    data['created_at'] = createdAt;
    return data;
  }
}
