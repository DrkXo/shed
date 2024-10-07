extension StringExtensions on String {
  /// Converts the first letter of each word in a string to uppercase
  String toTitleCase() {
    if (isEmpty) return this;

    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Reverses the string
  String reverse() {
    return split('').reversed.join('');
  }

  /// Checks if the string is a palindrome
  bool isPalindrome() {
    String normalized = replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return normalized == normalized.split('').reversed.join('');
  }

  /// Removes all whitespace from the string
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncates the string to a specific length with ellipsis
  String truncate(int length) {
    if (length <= 0 || this.length <= length) {
      return this;
    }
    return '${substring(0, length)}...';
  }
}
