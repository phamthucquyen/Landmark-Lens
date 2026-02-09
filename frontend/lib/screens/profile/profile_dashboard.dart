import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/user_service.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({super.key});

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  final UserService _userService = UserService();
  final supabase = Supabase.instance.client;

  static const Color _titleColor = Color(0xFF363E44);
  static const Color _muted = Color(0xFF9CA3AF);

  static const TextStyle _sectionTilt = TextStyle(
    fontFamily: 'Tilt Warp',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: _titleColor,
    height: 1.2,
  );
  static const TextStyle _smallComfortaa = TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: _muted,
    height: 1.25,
  );

  static const TextStyle _buttonComfortaa = TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle _tileTitleComfortaa = TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: 14.5,
    fontWeight: FontWeight.w800,
    color: _titleColor,
    height: 1.2,
  );

  static const TextStyle _tileSubtitleComfortaa = TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: _muted,
    height: 1.2,
  );

  static const TextStyle _snackComfortaa = TextStyle(
    fontFamily: 'Comfortaa',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userService.getUserProfileWithStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract data or use defaults
          final profileData = snapshot.data;
          final stats = profileData?['stats'] ?? {};
          final profile = profileData?['profile'] ?? {};
          
          final int placesVisited = stats['places_visited'] ?? 0;
          final int scansThisWeek = stats['scans_this_week'] ?? 0;
          final int streakDays = stats['streak_days'] ?? 0;
          final String displayName = profile['username'] ?? user?.email ?? 'User';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
                  const SizedBox(height: 60),
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Text(
                            displayName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          displayName,
                          style: const TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.createdAt != null 
                              ? 'Member since ${DateTime.parse(user!.createdAt).year}'
                              : 'Member since ${DateTime.now().year}',
                          style: const TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 13,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

          // Stats row
          Row(
            children: [
              _StatCard(
                icon: Icons.place,
                label: 'Places',
                value: '$placesVisited',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.calendar_month,
                label: 'This week',
                value: '$scansThisWeek',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.local_fire_department,
                label: 'Streak',
                value: '${streakDays}d',
              ),
            ],
          ),

              const SizedBox(height: 24),

          // Account Actions
          const Text('Account', style: _sectionTilt),
          const SizedBox(height: 8),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit, color: _titleColor),
                          title: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: _titleColor,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Edit profile coming soon', style: _snackComfortaa),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.notifications, color: _titleColor),
                          title: const Text(
                            'Notifications',
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: _titleColor,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Notifications coming soon', style: _snackComfortaa),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip, color: _titleColor),
                          title: const Text(
                            'Privacy',
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: _titleColor,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Privacy settings coming soon',
                                  style: _snackComfortaa,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            'Sign Out',
                            style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.red,
                            ),
                          ),
                          onTap: () async {
                            await supabase.auth.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacementNamed('/login');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color _titleColor = Color(0xFF363E44);
  static const Color _muted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: _titleColor),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _titleColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _muted,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
