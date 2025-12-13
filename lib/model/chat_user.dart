class ChatUser {
  String? image;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? id;
  String? lastActive;
  String? about;
  String? pushToken;
  String? email;

  ChatUser(
      {this.image,
      this.name,
      this.createdAt,
      this.isOnline,
      this.id,
      this.lastActive,
      this.about,
      this.pushToken,
      this.email});

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? true;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    about = json['about '] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['is_online'] = this.isOnline;
    data['id'] = this.id;
    data['last_active'] = this.lastActive;
    data['about '] = this.about;
    data['push_token'] = this.pushToken;
    data['email'] = this.email;
    return data;
  }
}