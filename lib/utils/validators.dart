class AppValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter contact name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter phone number';
    }
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.length < 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
      return 'Phone number should contain only digits';
    }
    return null;
  }

  static String? validateRelationship(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please specify relationship';
    }
    return null;
  }
}
