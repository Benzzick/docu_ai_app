String formatDateModified(DateTime date) {
  final currentDate = DateTime.now();
  final difference = currentDate.difference(date);

  if (difference.inSeconds < 60) {
    return 'Opened now';
  } else if (difference.inMinutes < 60) {
    return difference.inMinutes == 1
        ? 'Opened a minute ago'
        : 'Opened ${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return difference.inHours == 1
        ? 'Opened an hour ago'
        : 'Opened ${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return difference.inDays == 1
        ? 'Opened a day ago'
        : 'Opened ${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).round();
    return weeks == 1 ? 'Opened a week ago' : 'Opened $weeks weeks ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).round();
    return months == 1 ? 'Opened a month ago' : 'Opened $months months ago';
  } else {
    final years = (difference.inDays / 365).round();
    return years == 1 ? 'Opened a year ago' : 'Opened $years years ago';
  }
}
