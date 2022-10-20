// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatContactModal {
  final String name;
  final String userProfile;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  ChatContactModal({
    required this.name,
    required this.userProfile,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'userProfile': userProfile,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContactModal.fromMap(Map<String, dynamic> map) {
    return ChatContactModal(
      name: map['name'] as String,
      userProfile: map['userProfile'] as String,
      contactId: map['contactId'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
