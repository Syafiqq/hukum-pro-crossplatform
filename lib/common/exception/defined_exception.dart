class DefinedException implements Exception {
  Exception? internalException;
  String? code;
  String? message;

  DefinedException(this.internalException, this.code, this.message) : super();
}
