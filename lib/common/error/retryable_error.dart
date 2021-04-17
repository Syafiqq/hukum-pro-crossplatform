import 'package:hukum_pro/common/error/defined_error.dart';

class RetryableError extends DefinedError {
  RetryableError(Error? internalError, String? code, String? message)
      : super(internalError, code, message);
}
