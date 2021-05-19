import 'package:hukum_pro/common/exception/defined_exception.dart';

class RetryableException extends DefinedException {
  RetryableException(Exception? internalException, Error? internalError,
      String? code, String? message)
      : super(internalException, internalError, code, message);
}
