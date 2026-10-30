import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import 'tabs/archive_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';

/// Halaman 3: Beranda. Berisi bottom navigation (Beranda, Arsip, Profil)
/// dan tombol + untuk membuka halaman Tambah Catatan.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: [
            HomeTab(onOpenProfile: () => setState(() => _index = 2)),
            const ArchiveTab(),
            const ProfileTab(),
          ],
        ),
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              tooltip: 'Tambah catatan',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.add),
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Arsip',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
