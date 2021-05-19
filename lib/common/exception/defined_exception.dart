class DefinedException implements Exception {
  Exception? internalException;
  Error? internalError;
  String? code;
  String? message;

  DefinedException(
      this.internalException, this.internalError, this.code, this.message)
      : super();
}
