import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';
import '../../state/notes_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/user_avatar.dart';

/// Tab Profil: data pengguna, ringkasan, dan pengaturan.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<void> _editProfile(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => const _EditProfileDialog(),
    );
    if (saved == true) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Profil diperbarui.')),
      );
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Keluar dari aplikasi?'),
        content: const Text('Kamu akan kembali ke halaman login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'CatatanKu',
      applicationVersion: '1.0.0 (Fase 2)',
      applicationIcon: const AppLogo(size: 48),
      children: const [
        SizedBox(height: 12),
        Text(
          'Aplikasi catatan sederhana. Seluruh data masih berupa data statis '
          '(dummy) dan belum terhubung ke API atau database.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = NotesStore.instance;
    final pad = pagePadding(context);

    return ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final profile = store.profile;

            return ListView(
              padding: EdgeInsets.fromLTRB(pad, 16, pad, 24),
              children: [
                const Text('Profil', style: AppText.display),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    children: [
                      UserAvatar(initial: profile.initial, size: 84),
                      const SizedBox(height: 14),
                      Text(profile.name, style: AppText.title),
                      const SizedBox(height: 2),
                      Text(profile.email, style: AppText.body),
                      const SizedBox(height: 10),
                      Text(
                        profile.bio,
                        textAlign: TextAlign.center,
                        style: AppText.body,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(170, 44),
                        ),
                        onPressed: () => _editProfile(context),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit Profil'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(value: '${store.totalNotes}', label: 'Catatan'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        value: '${store.pinnedCount}',
                        label: 'Disematkan',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Stat(
                        value: '${store.archivedCount}',
                        label: 'Diarsipkan',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text('Pengaturan', style: AppText.heading),
                const SizedBox(height: 12),
                _Group(
                  children: [
                    _SettingTile(
                      icon: Icons.notifications_none_rounded,
                      label: 'Pengingat catatan',
                      trailing: Switch(
                        value: store.reminderOn,
                        onChanged: store.setReminder,
                      ),
                    ),
                    _SettingTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'Kunci aplikasi',
                      trailing: Switch(
                        value: store.lockOn,
                        onChanged: store.setLock,
                      ),
                    ),
                    _SettingTile(
                      icon: Icons.info_outline_rounded,
                      label: 'Tentang aplikasi',
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.inkSoft,
                      ),
                      onTap: () => _showAbout(context),
                    ),
                    _SettingTile(
                      icon: Icons.logout_rounded,
                      label: 'Keluar',
                      color: AppColors.danger,
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ],
            );
          },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppText.title.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppText.caption),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.line),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.color = AppColors.ink,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color == AppColors.ink ? AppColors.inkSoft : color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog();

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _bio;

  @override
  void initState() {
    super.initState();
    final profile = NotesStore.instance.profile;
    _name = TextEditingController(text: profile.name);
    _email = TextEditingController(text: profile.email);
    _bio = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    NotesStore.instance.updateProfile(
      UserProfile(
        name: _name.text.trim(),
        email: _email.text.trim(),
        bio: _bio.text.trim(),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Edit Profil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Email tidak boleh kosong';
                  if (!text.contains('@') || !text.contains('.')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bio,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        TextButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}
