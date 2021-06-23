import 'package:objectbox/objectbox.dart';

abstract class StoreProvider {
  Future<Store> get store;
}
