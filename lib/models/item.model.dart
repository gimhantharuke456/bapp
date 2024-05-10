import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Item {
  final String id;
  final String itemCode;
  final String itemName;
  final int unitPrice;
  final int quantity;
  final String itemImage;
  final String itemDescript;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.itemCode,
    required this.itemName,
    required this.unitPrice,
    required this.quantity,
    required this.itemImage,
    required this.itemDescript,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: (map['_id'] as mongo.ObjectId).toHexString(),
      itemCode: map['itemcode'] ?? '',
      itemName: map['itemname'] ?? '',
      unitPrice: map['unitprice']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      itemImage: map['itemimage'] ?? '',
      itemDescript: map['itemdescript'] ?? '',
      createdAt: DateTime.parse(
          map['createdAt'].toString() ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          map['updatedAt'].toString() ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'itemcode': itemCode,
      'itemname': itemName,
      'unitprice': unitPrice,
      'quantity': quantity,
      'itemimage': itemImage,
      'itemdescript': itemDescript,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
