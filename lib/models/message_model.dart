

enum Type {text, image}

class MessageModel {
  MessageModel({
    required this.fromId,
    required this.toId,
    required this.message,
    required this.type,
    required this.sent,
    required this.read,
  });
  late final String fromId;
  late final String toId;
  late final String message;
  late final Type type;
  late final String sent;
  late final String read;
  
  MessageModel.fromJson(Map<String, dynamic> json){
    fromId = json['fromId'].toString();
    toId = json['toId'].toString();
    message = json['message'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    read = json['read'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromId'] = fromId;
    data['toId'] = toId;
    data['message'] = message;
    data['type'] = type.name;
    data['sent'] = sent;
    data['read'] = read;
    return data;
  }
}