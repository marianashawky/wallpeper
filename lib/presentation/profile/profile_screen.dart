import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../widgets/ui_bits.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onOpenFavorites});

  final VoidCallback onOpenFavorites;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SizedBox(
            height: 210,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset('assets/images/wallpapers/stadiums/stadium_001.jpg', fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background.withValues(alpha: 0.95)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: TextButton.icon(
                    onPressed: () => _edit(context),
                    icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 18),
                    label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(backgroundColor: Colors.black45),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.accent, width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('assets/images/branding/app_icon.png', width: 72, height: 72, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.profileName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                Text('${state.profileHandle} · ${state.profileBio}', style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _stat('${state.favorites.length}', 'Favorites'),
                    const SizedBox(width: 8),
                    _stat('${state.downloads.length}', 'Downloads'),
                    const SizedBox(width: 8),
                    _stat('${state.shareCount}', 'Shared', highlight: true),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _outlineButton(Icons.favorite_border, 'Favorites', onOpenFavorites)),
                    const SizedBox(width: 10),
                    Expanded(child: _outlineButton(Icons.download_outlined, 'Downloads', () => _showDownloads(context))),
                  ],
                ),
                const SizedBox(height: 22),
                const Text('Settings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 10),
                Material(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: state.notifications,
                        onChanged: state.setNotifications,
                        secondary: const Icon(Icons.notifications_outlined),
                        title: const Text('Notifications'),
                        subtitle: const Text('New drops & trending'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.hd_outlined),
                        title: const Text('Auto-download Quality'),
                        subtitle: Text(state.quality),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _pickQuality(context),
                      ),
                      SwitchListTile(
                        value: state.darkMode,
                        onChanged: state.setDarkMode,
                        secondary: const Icon(Icons.dark_mode_outlined),
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Always on'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: const Text('Clear Cache'),
                        subtitle: const Text('Local favorites stay safe'),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared'))),
                      ),
                      ListTile(
                        leading: const Icon(Icons.star_outline),
                        title: const Text('Rate the App'),
                        subtitle: const Text('Love it? Tell us!'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.ios_share),
                        title: const Text('Share App'),
                        subtitle: const Text('Invite friends'),
                        onTap: () => Share.share('Football Wallpaper — cinematic football wallpapers.'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.privacy_tip_outlined),
                        title: Text('Privacy Policy'),
                        subtitle: Text('Local-only. No account. No backend.'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.refresh),
                        title: const Text('Reset local data'),
                        subtitle: const Text('Clear favorites, downloads & searches'),
                        onTap: () => state.resetLocal(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Center(child: Text('Football Wallpaper v1.0.0 · Made locally', style: TextStyle(color: AppColors.textMuted, fontSize: 12))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.stroke)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: highlight ? AppColors.accent : Colors.white)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _outlineButton(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: AppColors.stroke),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _edit(BuildContext context) {
    final state = AppStateScope.of(context);
    final name = TextEditingController(text: state.profileName);
    final handle = TextEditingController(text: state.profileHandle);
    final bio = TextEditingController(text: state.profileBio);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: handle, decoration: const InputDecoration(labelText: 'Handle')),
            TextField(controller: bio, decoration: const InputDecoration(labelText: 'Bio')),
            const SizedBox(height: 12),
            GlowButton(
              label: 'SAVE',
              onPressed: () {
                state.updateProfile(name: name.text, handle: handle.text, bio: bio.text);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickQuality(BuildContext context) {
    final state = AppStateScope.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['4K Ultra HD', '1080p HD', 'Optimized']
            .map((q) => ListTile(
                  title: Text(q),
                  trailing: state.quality == q ? const Icon(Icons.check, color: AppColors.accent) : null,
                  onTap: () {
                    state.setQuality(q);
                    Navigator.pop(ctx);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showDownloads(BuildContext context) {
    final state = AppStateScope.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Downloads', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (state.downloadedWallpapers.isEmpty) const Text('No downloads yet'),
          ...state.downloadedWallpapers.map((w) => ListTile(title: Text(w.title), subtitle: Text(w.subtitle))),
        ],
      ),
    );
  }
}
