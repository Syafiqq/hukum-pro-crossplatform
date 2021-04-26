import 'package:hukum_pro/common/exception/defined_exception.dart';

class RetryableException extends DefinedException {
  RetryableException(Exception? internalException, String? code, String? message)
      : super(internalException, code, message);
}
