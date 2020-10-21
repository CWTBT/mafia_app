import 'User.dart';

class Message {
  final String contents;
  final User sender;

  Message.fromJson(Map<String, dynamic> json)
      : contents = json['contents'],
        sender = User.fromJson(json['sender']);

  Map<String, dynamic> toJson() =>
      {
        'contents': contents,
        'sender': sender.toJson(),
      };

  Message(this.contents, this.sender);
}