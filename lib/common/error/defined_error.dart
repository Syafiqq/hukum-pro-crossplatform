class DefinedError extends Error {
  Error? internalError;
  String? code;
  String? message;

  DefinedError(this.internalError, this.code, this.message);
}
