import '../../data/models/models.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts({
    int limit = 10,
    String? startAfterId,
    String? categoryId,
    bool? isFeatured,
    String? query,
    String? orderBy,
    bool descending = false,
  });

  Future<ProductModel> getProductById(String id);

  Future<List<ProductModel>> getProductsByIds(List<String> ids);

  Future<List<ProductVariantModel>> getProductVariants(String productId);

  Future<ProductVariantModel> getProductVariantById(String variantId);

  Future<List<ProductImageModel>> getProductImages(String productId, {String? colorId});

  Future<List<CategoryModel>> getCategories({String? parentId});

  Future<CategoryModel> getCategoryById(String id);

  Future<List<ColorModel>> getColors();

  Future<List<SizeModel>> getSizes();
}
