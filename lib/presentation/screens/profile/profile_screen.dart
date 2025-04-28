import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import 'components/profile_menu_item.dart';
import 'components/profile_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, we would get this from a provider
    final dummyUser = DummyUser(
      id: 'user123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 (555) 123-4567',
      profileImage: 'https://i.pravatar.cc/300',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            ProfileHeader(user: dummyUser),

            const SizedBox(height: 24),

            // Menu items
            ProfileMenuItem(
              title: 'My Orders',
              icon: Icons.shopping_bag_outlined,
              onTap: () {
                // Navigate to orders screen
              },
              subtitle: 'View your order history',
              showBadge: true,
              badgeCount: 2,
            ),

            ProfileMenuItem(
              title: 'Shipping Addresses',
              icon: Icons.location_on_outlined,
              onTap: () {
                // Navigate to addresses screen
              },
              subtitle: 'Manage your shipping addresses',
            ),

            ProfileMenuItem(
              title: 'Payment Methods',
              icon: Icons.credit_card_outlined,
              onTap: () {
                // Navigate to payment methods screen
              },
              subtitle: 'Manage your payment methods',
            ),

            ProfileMenuItem(
              title: 'Wishlist',
              icon: Icons.favorite_border_outlined,
              onTap: () {
                // Navigate to wishlist screen
              },
              subtitle: 'View your saved items',
            ),

            ProfileMenuItem(
              title: 'Recently Viewed',
              icon: Icons.visibility_outlined,
              onTap: () {
                // Navigate to recently viewed screen
              },
              subtitle: 'Browse your recently viewed products',
            ),

            ProfileMenuItem(
              title: 'Reviews',
              icon: Icons.rate_review_outlined,
              onTap: () {
                // Navigate to reviews screen
              },
              subtitle: 'Manage your product reviews',
            ),

            const Divider(),

            ProfileMenuItem(
              title: 'Help & Support',
              icon: Icons.support_agent_outlined,
              onTap: () {
                // Navigate to help screen
              },
              subtitle: 'Customer support and FAQs',
            ),

            ProfileMenuItem(
              title: 'About',
              icon: Icons.info_outline,
              onTap: () {
                // Navigate to about screen
              },
              subtitle: 'App information and policies',
            ),

            const Divider(),

            // Logout button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Show logout confirmation
                  _showLogoutConfirmation(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform logout
              Navigator.pop(context);

              // Navigate to login screen
              AppRouter.replace(context, AppConstants.loginRoute);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// Dummy model for preview only
class DummyUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;

  DummyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
  });
}
