import 'package:bapp/db/mongodb.dart';
import 'package:bapp/models/item.model.dart';

class ItemService {
  final DbConnect _dbConnect = DbConnect();

  Future<List<Item>> fetchItems() async {
    await _dbConnect.open();
    var itemCollection = _dbConnect.db.collection('items');

    var itemDocs = await itemCollection.find().toList();
    await _dbConnect.close();

    List<Item> items = itemDocs
        .map((doc) => Item.fromMap(doc as Map<String, dynamic>))
        .toList();
    return items;
  }
}
