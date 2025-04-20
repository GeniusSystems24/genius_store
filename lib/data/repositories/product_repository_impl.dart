import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirestoreProductDataSource _productDataSource;

  ProductRepositoryImpl({
    required FirestoreProductDataSource productDataSource,
  }) : _productDataSource = productDataSource;

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 10,
    String? startAfterId,
    String? categoryId,
    bool? isFeatured,
    String? query,
    String? orderBy,
    bool descending = false,
  }) async {
    DocumentSnapshot? startAfterDoc;

    // If we have a startAfterId, get the document to use for pagination
    if (startAfterId != null) {
      try {
        final docRef = FirebaseFirestore.instance.collection('products').doc(startAfterId);
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          startAfterDoc = docSnapshot;
        }
      } catch (e) {
        // If there's an error, we'll just start from the beginning
        print('Error getting start after document: $e');
      }
    }

    return _productDataSource.getProducts(
      limit: limit,
      startAfterDoc: startAfterDoc,
      categoryId: categoryId,
      isFeatured: isFeatured,
      query: query,
      orderBy: orderBy,
      descending: descending,
    );
  }

  @override
  Future<ProductModel> getProductById(String id) {
    return _productDataSource.getProductById(id);
  }

  @override
  Future<List<ProductModel>> getProductsByIds(List<String> ids) {
    return _productDataSource.getProductsByIds(ids);
  }

  @override
  Future<List<ProductVariantModel>> getProductVariants(String productId) {
    return _productDataSource.getProductVariants(productId);
  }

  @override
  Future<ProductVariantModel> getProductVariantById(String variantId) {
    return _productDataSource.getProductVariantById(variantId);
  }

  @override
  Future<List<ProductImageModel>> getProductImages(String productId, {String? colorId}) {
    return _productDataSource.getProductImages(productId, colorId: colorId);
  }

  @override
  Future<List<CategoryModel>> getCategories({String? parentId}) {
    return _productDataSource.getCategories(parentId: parentId);
  }

  @override
  Future<CategoryModel> getCategoryById(String id) {
    return _productDataSource.getCategoryById(id);
  }

  @override
  Future<List<ColorModel>> getColors() {
    return _productDataSource.getColors();
  }

  @override
  Future<List<SizeModel>> getSizes() {
    return _productDataSource.getSizes();
  }
}
