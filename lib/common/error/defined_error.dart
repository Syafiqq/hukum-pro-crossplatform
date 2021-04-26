class DefinedException implements Exception {
  Error? internalError;
  String? code;
  String? message;

  DefinedException(this.internalError, this.code, this.message) : super();
}
