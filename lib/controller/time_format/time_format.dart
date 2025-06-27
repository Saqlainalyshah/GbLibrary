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

  static String formatIsoDate(String isoString) {
    DateTime date = DateTime.parse(isoString);

    const List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    String day = date.day.toString().padLeft(2, '0');
    String month = monthNames[date.month - 1];
    String year = date.year.toString();

    return '$day/$month/$year';
  }
  static bool isLessThanTenMinutesAgo(String? timeString) {
  if(timeString!=null){
      final past = DateTime.parse(timeString);
      final now = DateTime.now();
      return now.difference(past).inMinutes < 10;

  }else{
    return false;
  }
  }
  static bool isYesterday(String? timeString) {
    if(timeString!=null){
      final past = DateTime.parse(timeString);
      final now = DateTime.now();
      return now.difference(past).inHours >24;

    }else{
      return false;
    }
  }
  static String sortString(String input) {
    List<String> characters = input.split('');
    characters.sort();
    return characters.join();
  }
}