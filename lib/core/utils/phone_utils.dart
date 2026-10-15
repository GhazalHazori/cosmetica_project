/// Builds an international number (e.g. `+963944000104`) from a dial code and
/// the local part the user typed, dropping spaces, dashes and a leading 0.
String composeInternationalPhone(String dialCode, String localNumber) {
  var digits = localNumber.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  return '$dialCode$digits';
}
