import 'package:hukum_pro/common/exception/defined_exception.dart';

// Data
// 001-001 = Data not exist
// 001-002 = Invalid Parse

class DataNotExistsException extends DefinedException {
  DataNotExistsException(Exception? internalException)
      : super(internalException, "001-001", "requested data is not found");
}

class ParseFailedException extends DefinedException {
  ParseFailedException(Type type, Exception? internalException)
      : super(internalException, "001-002", "cannot parse to defined data $type");
}
