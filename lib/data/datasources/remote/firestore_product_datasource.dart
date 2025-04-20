import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/models.dart';

abstract class FirestoreProductDataSource {
  Future<List<ProductModel>> getProducts({
    int limit = 10,
    DocumentSnapshot? startAfterDoc,
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

class FirestoreProductDataSourceImpl implements FirestoreProductDataSource {
  final FirebaseFirestore _firestore;

  FirestoreProductDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 10,
    DocumentSnapshot? startAfterDoc,
    String? categoryId,
    bool? isFeatured,
    String? query,
    String? orderBy,
    bool descending = false,
  }) async {
    // Start building the query
    Query<Map<String, dynamic>> productsQuery = _firestore.collection('products').where('is_active', isEqualTo: true).limit(limit);

    // Add category filter if provided
    if (categoryId != null) {
      productsQuery = productsQuery.where('category_id', isEqualTo: categoryId);
    }

    // Add featured filter if provided
    if (isFeatured != null) {
      productsQuery = productsQuery.where('is_featured', isEqualTo: isFeatured);
    }

    // Add ordering
    if (orderBy != null) {
      productsQuery = productsQuery.orderBy(orderBy, descending: descending);
    } else {
      // Default ordering by creation date
      productsQuery = productsQuery.orderBy('created_at', descending: true);
    }

    // Add pagination if startAfterDoc is provided
    if (startAfterDoc != null) {
      productsQuery = productsQuery.startAfterDocument(startAfterDoc);
    }

    // Execute the query
    final querySnapshot = await productsQuery.get();

    // Convert the results to ProductModel objects
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();

    if (!doc.exists) {
      throw Exception('Product not found');
    }

    // Get variants
    final variants = await getProductVariants(id);

    // Get images
    final images = await getProductImages(id);

    return ProductModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    }).copyWith(variants: variants, images: images);
  }

  @override
  Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    // Firestore limits batched reads to 10 at a time
    final batches = <Future<List<ProductModel>>>[];

    for (var i = 0; i < ids.length; i += 10) {
      final end = (i + 10 < ids.length) ? i + 10 : ids.length;
      final batchIds = ids.sublist(i, end);

      batches.add(_getProductBatch(batchIds));
    }

    final results = await Future.wait(batches);
    return results.expand((products) => products).toList();
  }

  Future<List<ProductModel>> _getProductBatch(List<String> ids) async {
    final querySnapshot = await _firestore.collection('products').where(FieldPath.documentId, whereIn: ids).get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<List<ProductVariantModel>> getProductVariants(String productId) async {
    final querySnapshot = await _firestore.collection('product_variants').where('product_id', isEqualTo: productId).get();

    final variants = querySnapshot.docs
        .map((doc) => ProductVariantModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();

    // Fetch color and size data for each variant
    for (var i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final color = await _getColor(variant.colorId);
      final size = await _getSize(variant.sizeId);

      variants[i] = ProductVariantModel.fromJson({
        ...variant.toJson(),
        'color': color?.toJson(),
        'size': size?.toJson(),
      });
    }

    return variants;
  }

  @override
  Future<ProductVariantModel> getProductVariantById(String variantId) async {
    final doc = await _firestore.collection('product_variants').doc(variantId).get();

    if (!doc.exists) {
      throw Exception('Product variant not found');
    }

    final variant = ProductVariantModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });

    final color = await _getColor(variant.colorId);
    final size = await _getSize(variant.sizeId);

    return ProductVariantModel.fromJson({
      ...variant.toJson(),
      'color': color?.toJson(),
      'size': size?.toJson(),
    });
  }

  Future<ColorModel?> _getColor(String colorId) async {
    final doc = await _firestore.collection('colors').doc(colorId).get();
    if (!doc.exists) return null;

    return ColorModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  Future<SizeModel?> _getSize(String sizeId) async {
    final doc = await _firestore.collection('sizes').doc(sizeId).get();
    if (!doc.exists) return null;

    return SizeModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  @override
  Future<List<ProductImageModel>> getProductImages(String productId, {String? colorId}) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection('product_images').where('product_id', isEqualTo: productId).orderBy('sort_order');

    if (colorId != null) {
      query = query.where('color_id', isEqualTo: colorId);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs
        .map((doc) => ProductImageModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getCategories({String? parentId}) async {
    Query<Map<String, dynamic>> query = _firestore.collection('categories');

    if (parentId != null) {
      query = query.where('parent_id', isEqualTo: parentId);
    } else {
      query = query.where('parent_id', isNull: true);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs
        .map((doc) => CategoryModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    final doc = await _firestore.collection('categories').doc(id).get();

    if (!doc.exists) {
      throw Exception('Category not found');
    }

    return CategoryModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  @override
  Future<List<ColorModel>> getColors() async {
    final querySnapshot = await _firestore.collection('colors').get();

    return querySnapshot.docs
        .map((doc) => ColorModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<List<SizeModel>> getSizes() async {
    final querySnapshot = await _firestore.collection('sizes').get();

    return querySnapshot.docs
        .map((doc) => SizeModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }
}

extension ProductModelExtension on ProductModel {
  ProductModel copyWith({
    String? id,
    Map<String, String>? nameLocalized,
    Map<String, String>? descriptionLocalized,
    double? basePrice,
    String? brand,
    String? categoryId,
    bool? isFeatured,
    bool? isActive,
    DateTime? createdAt,
    List<String>? tags,
    double? averageRating,
    List<ProductVariantModel>? variants,
    List<ProductImageModel>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      nameLocalized: nameLocalized ?? this.nameLocalized,
      descriptionLocalized: descriptionLocalized ?? this.descriptionLocalized,
      basePrice: basePrice ?? this.basePrice,
      brand: brand ?? this.brand,
      categoryId: categoryId ?? this.categoryId,
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      averageRating: averageRating ?? this.averageRating,
      variants: variants ?? this.variants,
      images: images ?? this.images,
    );
  }
}
