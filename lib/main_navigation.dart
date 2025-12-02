import 'package:flutter/material.dart';
import 'package:gas_app_project_dev/pages/map_screen.dart';
import 'package:gas_app_project_dev/pages/search_screen.dart';
import 'package:gas_app_project_dev/pages/setting_screen.dart';
import 'package:gas_app_project_dev/pages/contributor_page.dart';
import 'package:gas_app_project_dev/pages/rewards_screen.dart';
import 'package:gas_app_project_dev/services/auth.dart';
import 'package:gas_app_project_dev/services/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int myIndex = 0;
  String role = "user";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  void loadRole() async {
    final User? user = Auth().currentUser;

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      role = doc.data()?['role'] ?? "user";
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        final screens = [
          MapScreen(isDarkMode: isDarkMode, key: ValueKey(isDarkMode)),
          SearchScreen(isDarkMode: isDarkMode),
          const SizedBox(),
          const SettingsPage(),
        ];

        return Scaffold(
          body: myIndex == 2
              ? (role == "contributor"
                    ? const RewardsPage()
                    : const ContributorPage())
              : screens[myIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: myIndex,
            onTap: (index) {
              setState(() {
                myIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                label: 'Rewards',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
