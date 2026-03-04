import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/controllers/profile_controller.dart';
import 'package:real_time_chat/app/utils/helpers/extensions/context.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: KColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(ctrl),
              _buildAvatarSection(ctrl),
              const SizedBox(height: 32),
              _buildInfoCard(ctrl),
              const SizedBox(height: 16),
              _buildSettingsSection(),
              const SizedBox(height: 16),
              _buildDangerSection(ctrl),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────
  Widget _buildHeader(ProfileController ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: KColors.muted, size: 20),
          ),
          const Expanded(
            child: Text(
              'Profile',
              style: TextStyle(color: KColors.white, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.5),
            ),
          ),
          _EditButton(),
        ],
      ),
    );
  }

  // ── Avatar ────────────────────────────────────
  Widget _buildAvatarSection(ProfileController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        children: [
          // Avatar with gradient ring
          Obx(() {
            final _ = ctrl.isLoggingOut.value; // reactive rebuild
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [KColors.primary, KColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    boxShadow: [BoxShadow(color: KColors.primary.changeOpacity(0.35), blurRadius: 28, spreadRadius: 2)],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: KColors.bg),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: KColors.primary,
                      backgroundImage: ctrl.user?.userMetadata?['avatar_url'] != null ? NetworkImage(ctrl.user!.userMetadata!['avatar_url']) : null,
                      child: ctrl.user?.userMetadata?['avatar_url'] == null
                          ? Text(
                              ctrl.initials,
                              style: const TextStyle(color: KColors.white, fontWeight: FontWeight.w800, fontSize: 28),
                            )
                          : null,
                    ),
                  ),
                ),
                // Camera badge
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {}, // hook up image picker
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: KColors.surfaceLight,
                        border: Border.all(color: KColors.primary, width: 1.5),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: KColors.primary, size: 14),
                    ),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 16),

          // Name
          Text(
            ctrl.displayName,
            style: const TextStyle(color: KColors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.6),
          ),
          const SizedBox(height: 4),

          // Email
          Text(ctrl.email, style: const TextStyle(color: KColors.muted, fontSize: 14)),

          const SizedBox(height: 16),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: KColors.accent.changeOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: KColors.accent.changeOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: KColors.accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Active now',
                  style: TextStyle(color: KColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Card ─────────────────────────────────
  Widget _buildInfoCard(ProfileController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _Card(
        child: Column(
          children: [
            _InfoRow(icon: Icons.email_rounded, label: 'Email', value: ctrl.email),
            const _Divider(),
            _InfoRow(
              icon: Icons.verified_user_rounded,
              label: 'Account',
              value: Supabase.instance.client.auth.currentUser?.emailConfirmedAt != null ? 'Verified' : 'Unverified',
              valueColor: Supabase.instance.client.auth.currentUser?.emailConfirmedAt != null ? KColors.accent : KColors.orange,
            ),
            const _Divider(),
            _InfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'Joined',
              value: _formatDate(Supabase.instance.client.auth.currentUser?.createdAt != null ? DateTime.parse(Supabase.instance.client.auth.currentUser!.createdAt) : null),
            ),
          ],
        ),
      ),
    );
  }

  // ── Settings Section ──────────────────────────
  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'PREFERENCES',
                style: TextStyle(color: KColors.mutedDark, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
              ),
            ),
            const SizedBox(height: 8),
            _SettingsRow(icon: Icons.notifications_rounded, label: 'Notifications', onTap: () {}),
            const _Divider(),
            _SettingsRow(icon: Icons.lock_rounded, label: 'Privacy & Security', onTap: () {}),
            const _Divider(),
            _SettingsRow(icon: Icons.palette_rounded, label: 'Appearance', onTap: () {}),
            const _Divider(),
            _SettingsRow(icon: Icons.help_rounded, label: 'Help & Support', onTap: () {}),
          ],
        ),
      ),
    );
  }

  // ── Danger Zone ───────────────────────────────
  Widget _buildDangerSection(ProfileController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _Card(
        child: Obx(
          () => GestureDetector(
            onTap: ctrl.isLoggingOut.value ? null : () => _showLogoutDialog(ctrl),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(color: const Color(0xFFEF4444).changeOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                    child: ctrl.isLoggingOut.value
                        ? const Center(
                            child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF4444))),
                          )
                        : const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    ctrl.isLoggingOut.value ? 'Signing out...' : 'Sign Out',
                    style: TextStyle(color: ctrl.isLoggingOut.value ? KColors.muted : const Color(0xFFEF4444), fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  if (!ctrl.isLoggingOut.value) const Icon(Icons.arrow_forward_ios_rounded, color: KColors.mutedDark, size: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Logout Confirmation Dialog ─────────────────
  void _showLogoutDialog(ProfileController ctrl) {
    Get.dialog(
      Dialog(
        backgroundColor: KColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: const Color(0xFFEF4444).changeOpacity(0.12), shape: BoxShape.circle),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 26),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign Out?',
                style: TextStyle(color: KColors.white, fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'You will be redirected to the login screen. Your data will remain safe.',
                textAlign: TextAlign.center,
                style: TextStyle(color: KColors.muted, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: Get.back,
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(color: KColors.borderAlt, borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFFB0B0C8), fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        ctrl.logout();
                      },
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: const Color(0xFFEF4444).changeOpacity(0.3), blurRadius: 14, offset: const Offset(0, 4))],
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Out',
                            style: TextStyle(color: KColors.white, fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Unknown';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

// ─────────────────────────────────────────────
// Edit Button
// ─────────────────────────────────────────────
class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // hook up edit profile
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: KColors.primary.changeOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: KColors.primary.changeOpacity(0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_rounded, color: KColors.primary, size: 14),
            SizedBox(width: 5),
            Text(
              'Edit',
              style: TextStyle(color: KColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Reusable Widgets
// ─────────────────────────────────────────────
class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: KColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KColors.borderAlt, width: 1),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: KColors.primary.changeOpacity(0.1), borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: KColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: KColors.muted, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(color: valueColor ?? KColors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: KColors.borderAlt, borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, color: const Color(0xFFB0B0C8), size: 18),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(color: KColors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: KColors.mutedDark, size: 14),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: KColors.borderLight, height: 1, thickness: 1);
  }
}
