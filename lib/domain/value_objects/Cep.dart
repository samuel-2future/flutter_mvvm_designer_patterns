class Cep {
  final String value;
  static final _re = RegExp(r'^\d{8}$');

  const Cep._(this.value);

  static String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  static Cep? tryParse(String input) {
    final only = _digitsOnly(input);
    return _re.hasMatch(only) ? Cep._(only) : null;
  }
}
