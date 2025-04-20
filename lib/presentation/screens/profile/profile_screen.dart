import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // انتقل إلى شاشة الإعدادات
            },
          ),
        ],
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return _buildNotLoggedIn(context);
          }
          return _buildProfileContent(context, user);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('حدث خطأ: $error'),
        ),
      ),
    );
  }

  // عرض حالة عدم تسجيل الدخول
  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'أهلاً بك في متجرنا',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'سجل دخول لتتمكن من الاستمتاع بكافة الخدمات',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // انتقل إلى شاشة تسجيل الدخول
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('تسجيل الدخول'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // انتقل إلى شاشة إنشاء حساب
            },
            child: const Text('إنشاء حساب جديد'),
          ),
        ],
      ),
    );
  }

  // عرض المحتوى للمستخدم المسجل
  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // معلومات المستخدم
          _buildUserInfo(context, user),
          const SizedBox(height: 24),

          // قائمة الخيارات
          _buildMenuSection(context),
          const SizedBox(height: 24),

          // إحصائيات المستخدم
          _buildUserStats(context),
          const SizedBox(height: 32),

          // زر تسجيل الخروج
          ElevatedButton.icon(
            onPressed: () {
              // تسجيل الخروج
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text('تسجيل الخروج'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.red[50],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // معلومات المستخدم
  Widget _buildUserInfo(BuildContext context, UserModel user) {
    return Column(
      children: [
        // صورة المستخدم
        CircleAvatar(
          radius: 60,
          backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
          child: user.profileImage == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
        ),
        const SizedBox(height: 16),

        // اسم المستخدم
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        // البريد الإلكتروني
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
              ),
        ),

        const SizedBox(height: 16),

        // زر تعديل الملف الشخصي
        TextButton.icon(
          onPressed: () {
            // انتقل إلى شاشة تعديل الملف الشخصي
          },
          icon: const Icon(Icons.edit),
          label: const Text('تعديل الملف الشخصي'),
        ),
      ],
    );
  }

  // قسم قائمة الخيارات
  Widget _buildMenuSection(BuildContext context) {
    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        icon: Icons.shopping_bag_outlined,
        title: 'طلباتي',
        subtitle: 'متابعة طلباتك السابقة والحالية',
        onTap: () {
          // انتقل إلى شاشة الطلبات
        },
      ),
      ProfileMenuItem(
        icon: Icons.favorite_border,
        title: 'المفضلة',
        subtitle: 'المنتجات المحفوظة في قائمة المفضلة',
        onTap: () {
          // انتقل إلى شاشة المفضلة
        },
      ),
      ProfileMenuItem(
        icon: Icons.location_on_outlined,
        title: 'العناوين',
        subtitle: 'إدارة عناوين الشحن الخاصة بك',
        onTap: () {
          // انتقل إلى شاشة العناوين
        },
      ),
      ProfileMenuItem(
        icon: Icons.credit_card,
        title: 'طرق الدفع',
        subtitle: 'إدارة بطاقات الدفع وطرق الدفع',
        onTap: () {
          // انتقل إلى شاشة طرق الدفع
        },
      ),
      ProfileMenuItem(
        icon: Icons.support_agent,
        title: 'الدعم الفني',
        subtitle: 'تواصل مع خدمة العملاء',
        onTap: () {
          // انتقل إلى شاشة الدعم الفني
        },
      ),
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return ListTile(
          leading: Icon(item.icon, color: Theme.of(context).primaryColor),
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: item.onTap,
        );
      },
    );
  }

  // إحصائيات المستخدم
  Widget _buildUserStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات الحساب',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                context,
                icon: Icons.shopping_bag,
                value: '5',
                label: 'الطلبات',
              ),
              _buildStatItem(
                context,
                icon: Icons.favorite,
                value: '8',
                label: 'المفضلة',
              ),
              _buildStatItem(
                context,
                icon: Icons.redeem,
                value: '210',
                label: 'النقاط',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // عنصر إحصائية
  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // حوار تأكيد تسجيل الخروج
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // تنفيذ تسجيل الخروج
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

// نموذج عنصر القائمة
class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
