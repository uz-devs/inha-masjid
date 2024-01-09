// Announcement screen. This screen is the right tab in the bottom navigation bar.
// This screen includes a list of announcements fetched from Cloud Firestore
// https://firebase.google.com/docs/firestore

// Stdlib
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 3rd party
import 'package:google_fonts/google_fonts.dart';

// Local
import 'package:inha_masjid/utils/colors.dart';
import 'package:inha_masjid/utils/dimensions.dart';
import 'package:inha_masjid/utils/strings.dart';

class AnnouncementsScreen extends StatefulWidget {
  // Variables
  final VoidCallback onBackButtonPressed;

  // Constructor
  const AnnouncementsScreen({
    super.key,
    required this.onBackButtonPressed,
  });

  // Overrides
  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: BackButton(onPressed: widget.onBackButtonPressed),
        title: Text(
          AppStrings.announcements,
          style: GoogleFonts.manrope(
            fontSize: AppDimensions.screenTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirestorePaths.announcementsCol)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No data found.');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var timestamp = doc['timestamp'];
                var title = doc['title'];
                var body = doc['body'];

                return Card(
                  color: AppColors.cardBackgroundColor,
                  elevation: AppDimensions.cardElevation,
                  child: Theme(
                    data:
                        ThemeData().copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text('$title'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 15, right: 15, bottom: 15),
                          child: Text(body),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
