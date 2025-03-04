String timeAgo(String? dateTimeString) {
  if (dateTimeString == null) return '날짜 정보 없음';

  DateTime currentTime = DateTime.now();
  DateTime inputTime = DateTime.parse(dateTimeString);

  Duration diff = currentTime.difference(inputTime);

  if (diff.inDays > 0) {
    if (diff.inDays == 1) {
      return '1일 전';
    } else if (diff.inDays < 30) {
      return '${diff.inDays}일 전';
    } else if (diff.inDays >= 30 && diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}개월 전';
    } else {
      return '${(diff.inDays / 365).floor()}년 전';
    }
  } else if (diff.inHours > 0) {
    return '${diff.inHours}시간 전';
  } else if (diff.inMinutes > 0) {
    return '${diff.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}
