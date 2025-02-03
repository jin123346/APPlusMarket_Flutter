/*
* 2025.01.21 - 황수빈 : UserCard 모델링 클래스
*
*/

class UserCard {
  final int user_id;
  final String name;
  final String? profileImage;

  UserCard({
    required this.user_id,
    required this.name,
    this.profileImage,
  });
  factory UserCard.fromJson(Map<String, dynamic> json) {
    return UserCard(
      user_id: json['userId'],
      name: json['userName'],
      profileImage: json['profileImage'] ?? '',
    );
  }
}
