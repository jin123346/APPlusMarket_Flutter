import 'package:intl/intl.dart';

String formatPrice(int price) {
  if (price >= 100000000) {
// 100,000,000 이상 → '12억 3,456만'
    return '${price ~/ 100000000}억 ${((price % 100000000) ~/ 10000) > 0 ? '${(price % 100000000) ~/ 10000}만' : ''}'
        .trim();
  } else if (price >= 10000000) {
// 10,000,000 이상 → '1,234만'
    return '${price ~/ 10000}만';
  } else {
// 1,000,000 미만 → '1,000' (쉼표 포맷)
    return NumberFormat("#,###").format(price);
  }
}
