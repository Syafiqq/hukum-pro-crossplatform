import 'package:hukum_pro/common/exception/defined_exception.dart';

class RetryableException extends DefinedException {
  RetryableException(Error? internalError, String? code, String? message)
      : super(internalError, code, message);
}
