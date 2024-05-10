import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

class DbConnect {
  static late Db _db;

  Db get db => _db;

  Future<void> open() async {
    _db = await Db.create(
        "mongodb+srv://it21212536:XNQkZ8UkenjX6skC@voiceshop.lrqeqzs.mongodb.net/test");
    await _db.open();

    inspect(_db);
  }

  Future<void> close() async {
    await _db.close();
  }

  Future<DbCollection> getUsersCollection() async {
    return _db.collection('users');
  }

  Future<DbCollection> getPostsCollection() async {
    return _db.collection('categories');
  }
}
