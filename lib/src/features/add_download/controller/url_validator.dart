part of "../view/add_download.dart";

String? urlValidator(String? value) {
  // Check if the input is null or empty
  if (value == null || value.isEmpty) {
    return 'Please enter a URL';
  }

  // More robust regex for URL validation
  final urlPattern = r'^(https?:\/\/)?' // Optional http or https
      r'((([a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])+\.)+[a-zA-Z]{2,})' // Domain
      r'(:\d{2,5})?' // Optional port
      r'(\/[^\s]*)?$'; // Optional path
  final regExp = RegExp(urlPattern);

  // Check if the input matches the URL pattern
  if (!regExp.hasMatch(value)) {
    return 'Please enter a valid URL';
  }

  // If valid, return null
  return null;
}
