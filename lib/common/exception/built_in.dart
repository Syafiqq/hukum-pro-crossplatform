import 'package:hukum_pro/common/exception/defined_exception.dart';

// Data
// 001-001 = Data not exist
// 001-002 = Invalid Parse
// 001-003 = Data fetch failure

class DataNotExistsException extends DefinedException {
  DataNotExistsException(Exception? internalException, Error? internalError)
      : super(internalException, internalError, "001-001",
            "requested data is not found");
}

class ParseFailedException extends DefinedException {
  ParseFailedException(
      Type type, Exception? internalException, Error? internalError)
      : super(internalException, internalError, "001-002",
            "cannot parse to defined data $type");
}

class DataFetchFailureException extends DefinedException {
  DataFetchFailureException(Exception? internalException, Error? internalError)
      : super(internalException, internalError, "001-003",
            "request data failed to retrieve");
}
