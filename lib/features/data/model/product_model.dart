import 'package:prominous/features/domain/entity/product_entity.dart';

class ProductModel extends ProductEntity {
  final List<ListOfProduct> listOfProduct;
  const ProductModel({
    required this.listOfProduct,
  }) : super(listofProductEntity: listOfProduct);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      listOfProduct: json['response_data']["List_Of_Product"] == null
          ? []
          : List<ListOfProduct>.from(json['response_data']["List_Of_Product"]!
              .map((x) => ListOfProduct.fromJson(x))),
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "List_Of_Product": listOfProduct.map((x) => x?.toJson()).toList(),
  //     };
}

class ListOfProduct extends ListofProductEntity {
  const ListOfProduct({
    required this.productName,
    required this.productid,
    //required this.plannedQty
  }) : super(productName: productName, productid: productid
            // plannedQty: plannedQty
            );

  final String? productName;
  final int? productid;
  //final int? plannedQty;

  
  factory ListOfProduct.fromJson(Map<String, dynamic> json) {
    return ListOfProduct(
      productName: json['product_name'],
      productid: json["product_id"],
      // plannedQty: json["planned_qty"],
    );
  }

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_id": productid,
        // "planned_qty": plannedQty
      };
}
