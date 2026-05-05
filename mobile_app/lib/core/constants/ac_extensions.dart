extension DateTimeFormatting on DateTime {
  String get formatted => '$day.$month.$year';
  String get formattedWithTime =>
      '$day.$month.$year $hour:${minute.toString().padLeft(2, '0')}';
}
