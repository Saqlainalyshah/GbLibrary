class TimeFormater{
  static String timeAgo(String isoString) {
    final past = DateTime.parse(isoString).toLocal();
    final now = DateTime.now();
    final seconds = now.difference(past).inSeconds;

    final intervals = {
      'year': 31536000,
      'month': 2592000,
      'week': 604800,
      'day': 86400,
      'hour': 3600,
      'minute': 60,
      'second': 1,
    };

    for (final entry in intervals.entries) {
      final count = (seconds / entry.value).floor();
      if (count > 0) {
        return '$count ${entry.key}${count > 1 ? 's' : ''} ago';
      }
    }

    return 'just now';
  }
}