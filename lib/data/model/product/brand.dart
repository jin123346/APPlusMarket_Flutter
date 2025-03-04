class Brand {
  String? brandName;
  String? brandLogo;

  Brand({required this.brandName, this.brandLogo});
}

final brands = [
  Brand(brandName: 'SamSung', brandLogo: 'assets/images/brand/Samsung.png'),
  Brand(brandName: 'Apple', brandLogo: 'assets/images/brand/Apple.png'),
  Brand(brandName: 'LG', brandLogo: null),
  Brand(brandName: '기타', brandLogo: null),
];
