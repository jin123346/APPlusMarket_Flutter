class Tokens {
  final String token;
  final String refreshToken;

  Tokens({required this.token, required this.refreshToken});

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }
}
