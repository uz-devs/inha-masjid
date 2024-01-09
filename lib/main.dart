// Stdlib
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inha_masjid/ui/main/main_router.dart';

// 3rd party
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Local
import 'package:inha_masjid/ui/welcome_screen.dart';
import 'package:inha_masjid/ui/record_donation_screen.dart';
import 'package:inha_masjid/ui/admin/admin_login_screen.dart';
import 'package:inha_masjid/ui/admin/admin_panel_screen.dart';
import 'package:inha_masjid/utils/colors.dart';
import 'package:inha_masjid/utils/strings.dart';

void main() async {
  // Ensure that all widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Firebase
  await initFirebase();

  // Run the app
  runApp(const InhaMasjidApp());
}

Future<void> initFirebase() async {
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase auth -- anonymous sign-in for both admin and regular users
  await FirebaseAuth.instance.signInAnonymously();
}

class InhaMasjidApp extends StatelessWidget {
  const InhaMasjidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: AppStrings.appTitle,
      theme: ThemeData(
        colorSchemeSeed: AppColors.widgetPrimary,
        useMaterial3: true,
      ),

      // Main router widget checks if app is opened for the first time, and
      // redirects to welcome screen if so. Otherwise, it redirects to home screen.
      initialRoute: '/main',

      // Routes for easy navigation through the application
      routes: {
        // Welcome screen shown when user opens the app for the first time.
        // After that, welcome page immediately redirects to home screen.
        '/welcome': (context) => const WelcomeScreen(),

        // Home page, shown immediately after splash screen (or instructions on first time)
        '/main': (context) => const MainRouterWidget(),

        // Donation recording Screen (regular user)
        '/donate': (context) => const RecordDonationScreen(),

        // Admin login Screen (admin user)
        '/admin_login': (context) => AdminLoginScreen(),

        // Administration Screen for configuring masjid details (admin user)
        '/admin_panel': (context) => AdminPanelScreen(),
      },
    );
  }
}
