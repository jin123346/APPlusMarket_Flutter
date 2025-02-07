/*
* 2025.01.21 - 황수빈 : UserCard 모델링 클래스
*
*/

class UserCard {
  final int userId;
  final String name;
  final String nickname;
  final String? profileImage;

  UserCard({
    required this.userId,
    required this.name,
    required this.nickname,
    this.profileImage,
  });
  factory UserCard.fromJson(Map<String, dynamic> json) {
    return UserCard(
      userId: json['userId'],
      name: json['userName'],
      nickname: json['nickname'],
      profileImage: json['profileImage'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserCard{user_id: $userId, name: $name, profileImage: $profileImage}';
  }
}
