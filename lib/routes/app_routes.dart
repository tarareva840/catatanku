import 'package:flutter/material.dart';

import '../screens/add_note_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/note_detail_screen.dart';
import '../screens/splash_screen.dart';
import '../state/notes_store.dart';

/// Named route untuk lima halaman aplikasi.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String add = '/add';
  static const String detail = '/detail';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _fade(settings, const LoginScreen());
      case home:
        return _fade(settings, const HomeScreen());
      case add:
        final id = settings.arguments as int?;
        final note = id == null ? null : NotesStore.instance.byId(id);
        return _slideUp(settings, AddNoteScreen(note: note));
      case detail:
        final note = NotesStore.instance.byId(settings.arguments as int);
        if (note == null) return _fade(settings, const HomeScreen());
        return _slide(settings, NoteDetailScreen(note: note));
      case splash:
      default:
        return _fade(settings, const SplashScreen());
    }
  }

  /// Transisi memudar untuk perpindahan tab.
  static Route<void> _fade(RouteSettings settings, Widget page) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  /// Transisi naik dari bawah untuk halaman form.
  static Route<void> _slideUp(RouteSettings settings, Widget page) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Transisi geser halus untuk halaman detail.
  static Route<void> _slide(RouteSettings settings, Widget page) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
