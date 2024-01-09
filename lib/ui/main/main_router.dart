// Main router widget. This is the main widget that is used to switch between
// three main screens: home, prayer times, and announcements.

// Stdlib
import 'package:flutter/material.dart';

// 3rd party
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Local
import 'package:inha_masjid/ui/main/home_screen.dart';
import 'package:inha_masjid/ui/main/prayer_times_screen.dart';
import 'package:inha_masjid/ui/main/announcements_screen.dart';
import 'package:inha_masjid/utils/colors.dart';
import 'package:inha_masjid/utils/dimensions.dart';

/// Main router widget for three main screens: home, prayer times, and announcements.
class MainRouterWidget extends StatefulWidget {
  const MainRouterWidget({super.key});

  @override
  State<MainRouterWidget> createState() => _MainRouterWidgetState();
}

/// Main router widget state that switches between three main screens: home, prayer
/// times, and announcements using a bottom navigation bar. The screen instances
/// are stored in a list of widgets, and referred to by index in build() method.
class _MainRouterWidgetState extends State<MainRouterWidget> {
  // Variables
  late List<Widget> _tabs;
  late int _currentTabIdx;

  // Functions
  void _onTabChange(int index) {
    setState(() => _currentTabIdx = index);
  }

  void _onBackButtonPressed() {
    _onTabChange(1); // Go to home screen (center tab, default)
  }

  // Overrides
  @override
  void initState() {
    super.initState();

    // Initialize tabs
    _tabs = <Widget>[
      // // Prayer times screen (left tab)
      PrayerTimesScreen(onBackButtonPressed: _onBackButtonPressed),

      // Home screen (center tab)
      HomeScreen(onBackButtonPressed: _onBackButtonPressed),

      // // Announcements screen (right tab)
      AnnouncementsScreen(onBackButtonPressed: _onBackButtonPressed),
    ];

    // Initialize current tab index
    _currentTabIdx = 1; // Default to home screen (center tab)

    /// Check if app is opened for the first time, and redirects to welcome screen
    /// if so. Otherwise, widget lifecycle moves to build() method.
    SharedPreferences.getInstance().then((prefs) {
      final firstTime = prefs.getBool('firstTime') ?? true;
      if (firstTime) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentTabIdx],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          top: 0,
          left: 28,
          right: 28,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.widgetLightPrimary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            left: 29,
            right: 28,
            bottom: 4,
          ),
          child: GNav(
            backgroundColor: AppColors.widgetLightPrimary,
            color: AppColors.white,
            activeColor: AppColors.widgetLightPrimary,
            tabBackgroundColor: AppColors.white,
            iconSize: AppDimensions.bottomNavigationBarIconSize,
            selectedIndex: _currentTabIdx,
            tabs: const [
              GButton(icon: Icons.timer),
              GButton(icon: Icons.home),
              GButton(icon: Icons.notification_important),
            ],
            onTabChange: _onTabChange,
          ),
        ),
      ),
    );
  }
}
