class ProductImageModel {
  final String id;
  final String productId;
  final String? colorId;
  final String url;
  final int sortOrder;

  ProductImageModel({
    required this.id,
    required this.productId,
    this.colorId,
    required this.url,
    required this.sortOrder,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      productId: json['product_id'],
      colorId: json['color_id'],
      url: json['url'],
      sortOrder: json['sort_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'color_id': colorId,
      'url': url,
      'sort_order': sortOrder,
    };
  }
}
