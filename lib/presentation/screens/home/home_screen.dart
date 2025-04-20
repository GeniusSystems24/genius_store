import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_widgets/carousel_slider.dart';
import '../../common_widgets/category_card.dart';
import '../../common_widgets/product_card.dart';
import '../../common_widgets/section_title.dart';
import '../../common_widgets/search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text('متجر العبقري', style: Theme.of(context).textTheme.headlineMedium),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // التنقل لصفحة الإشعارات
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AppSearchBar(
                    onSearch: (query) {
                      // البحث
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: AppCarouselSlider(
                  items: [
                    'assets/images/banner1.jpg',
                    'assets/images/banner2.jpg',
                    'assets/images/banner3.jpg',
                  ],
                  onTap: (index) {
                    // التفاعل مع البانر
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SectionTitle(
                  title: 'الأقسام',
                  onSeeAllPressed: () {
                    // التنقل لصفحة كل الأقسام
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CategoryCard(
                        title: 'قسم ${index + 1}',
                        imageUrl: 'assets/images/category${index + 1}.jpg',
                        onTap: () {
                          // التنقل لصفحة القسم
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SectionTitle(
                  title: 'المنتجات الشائعة',
                  onSeeAllPressed: () {
                    // التنقل لصفحة المنتجات الشائعة
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ProductCard(
                        title: 'منتج ${index + 1}',
                        imageUrl: 'assets/images/product${index + 1}.jpg',
                        price: (index + 1) * 100.0,
                        discountPercentage: index % 2 == 0 ? 10 : null,
                        rating: 4.5,
                        onTap: () {
                          // التنقل لصفحة المنتج
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SectionTitle(
                  title: 'المنتجات الجديدة',
                  onSeeAllPressed: () {
                    // التنقل لصفحة المنتجات الجديدة
                  },
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(
                    title: 'منتج جديد ${index + 1}',
                    imageUrl: 'assets/images/new_product${index + 1}.jpg',
                    price: (index + 1) * 150.0,
                    discountPercentage: index % 3 == 0 ? 15 : null,
                    rating: 4.0,
                    onTap: () {
                      // التنقل لصفحة المنتج
                    },
                  );
                },
                childCount: 4,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
