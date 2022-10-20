class UserModal {
  String uid;
  String name;
  String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;
  UserModal({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModal.fromMap(Map<String, dynamic> map) {
    return UserModal(
        uid: map['uid'] as String,
        name: map['name'] as String,
        profilePic: map['profilePic'] as String,
        isOnline: map['isOnline'] as bool,
        phoneNumber: map['phoneNumber'] as String,
        groupId: List<String>.from(
          (map['groupId']
          // as List<String>
          ),
        ));
  }
}
