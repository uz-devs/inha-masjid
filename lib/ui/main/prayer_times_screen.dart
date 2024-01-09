// Prayer times screen.

// Stdlib
import 'dart:async';

import 'package:flutter/material.dart';

// 3rd party
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Local
import 'package:inha_masjid/utils/colors.dart';
import 'package:inha_masjid/utils/dimensions.dart';
import 'package:inha_masjid/utils/extensions.dart';
import 'package:inha_masjid/utils/strings.dart';

// Import the intl package for date formatting
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatefulWidget {
  // Variables
  final VoidCallback onBackButtonPressed;

  // Functions
  const PrayerTimesScreen({
    super.key,
    required this.onBackButtonPressed,
  });

  // Overrides
  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: BackButton(
          onPressed: widget.onBackButtonPressed,
        ),
        title: Text(
          AppStrings.prayerTimes,
          style: GoogleFonts.manrope(
            fontSize: AppDimensions.screenTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardPrimaryButtonColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                currentTime,
                style: GoogleFonts.manrope(
                  fontSize: 35,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Wrap(
              spacing: 22, // Adjust the spacing between prayer times
              runSpacing: 40, // Adjust the spacing between lines
              children: [
                // Prayer times
                for (var prayerName in AppStrings.prayerNames)
                  Column(
                    children: [
                      Text(
                        prayerName.capitalize(),
                        style: GoogleFonts.manrope(
                          fontSize: AppDimensions.prayerTimesTextFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 140,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.textSecondary,
                            width: 2.0,
                          ),
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .doc(FirestorePaths.prayerTimeDoc(prayerName))
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            var prayerTime = snapshot.data!;
                            var hour =
                                prayerTime['hour'].toString().padLeft(2, '0');
                            var minute =
                                prayerTime['minute'].toString().padLeft(2, '0');
                            return Center(
                              child: Text(
                                '$hour:$minute',
                                style: GoogleFonts.manrope(
                                  textStyle: const TextStyle(
                                    fontSize: AppDimensions.prayerTimesFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
