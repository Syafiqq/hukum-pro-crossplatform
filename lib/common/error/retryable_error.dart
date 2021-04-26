import 'package:hukum_pro/common/error/defined_error.dart';

class RetryableException extends DefinedException {
  RetryableException(Error? internalError, String? code, String? message)
      : super(internalError, code, message);
}
