import 'package:objectbox/objectbox.dart';

abstract class ObjectResolver {
  Future<Store> getStore();
}
