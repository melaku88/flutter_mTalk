
// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
 late final String id;
 late final String username;
 late final String email;
 late final String profilePic;
 late final String about;
 late final bool isOnline;
 late final String createdAt;
 late final String lastActive;
 late final String pushToken;
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePic,
    required this.about,
    required this.isOnline,
    required this.createdAt,
    required this.lastActive,
    required this.pushToken,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['profilePic'] = profilePic;
    data['about'] = about;
    data['isOnline'] = isOnline;
    data['createdAt'] = createdAt;
    data['lastActive'] = lastActive;
    data['pushToken'] = pushToken;

    return data;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    profilePic = json['profilePic'] ?? '';
    about = json['about'] ?? '';
    isOnline = json['isOnline'] ?? '';
    createdAt = json['createdAt'] ?? '';
    lastActive = json['lastActive'] ?? '';
    pushToken = json['pushToken'] ?? '';
  }

}
