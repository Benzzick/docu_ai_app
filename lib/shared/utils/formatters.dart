import 'package:docu_ai_app/models/enums.dart';

String formatDateModified(DateTime date, DateFormat format) {
  final currentDate = DateTime.now();
  final difference = currentDate.difference(date);

  if (difference.inSeconds < 60) {
    return format == DateFormat.short ? 'now' : 'Opened now';
  } else if (difference.inMinutes < 60) {
    final value = difference.inMinutes;
    final unit = value == 1 ? 'minute' : 'minutes';
    return format == DateFormat.short
        ? '$value $unit'
        : 'Opened $value $unit ago';
  } else if (difference.inHours < 24) {
    final value = difference.inHours;
    final unit = value == 1 ? 'hour' : 'hours';
    return format == DateFormat.short
        ? '$value $unit'
        : 'Opened $value $unit ago';
  } else if (difference.inDays < 7) {
    final value = difference.inDays;
    final unit = value == 1 ? 'day' : 'days';
    return format == DateFormat.short
        ? '$value $unit'
        : 'Opened $value $unit ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).round();
    final unit = weeks == 1 ? 'week' : 'weeks';
    return format == DateFormat.short
        ? '$weeks $unit'
        : 'Opened $weeks $unit ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).round();
    final unit = months == 1 ? 'month' : 'months';
    return format == DateFormat.short
        ? '$months $unit'
        : 'Opened $months $unit ago';
  } else {
    final years = (difference.inDays / 365).round();
    final unit = years == 1 ? 'year' : 'years';
    return format == DateFormat.short
        ? '$years $unit'
        : 'Opened $years $unit ago';
  }
}
