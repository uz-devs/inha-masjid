// Home screen. This is the main screen of the application shown both to
// regular users and admins. Regular users can see the donation progress
// bar, recent donations list, and other information about the masjid.
// Admin users can also click on the admin login button to go to admin
// panel, and regular users can click on the `x` button to hide the admin
// login button.

// Stdlib
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inha_masjid/ui/record_donation_screen.dart';
import 'package:inha_masjid/utils/colors.dart';
import 'package:inha_masjid/utils/dimensions.dart';
import 'package:inha_masjid/utils/strings.dart';

/// Home screen shown to both regular and admin users.
class HomeScreen extends StatefulWidget {
  // Variables
  final VoidCallback onBackButtonPressed;

  // Constructor
  const HomeScreen({
    super.key,
    required this.onBackButtonPressed,
  });

  // Overrides
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Home screen state that shows the varying donation progress bar, and
/// recent donations list. Admin users can also click on the admin login
/// button to go to admin panel, and regular users can click on the `x`
/// button to hide the admin login button.
class _HomeScreenState extends State<HomeScreen> {
  // Functions
  void _onCloseAdminCardBtnPressed() {
    // TODO finish this
  }

  void _onOpenAdminPageBtnPressed() async {
    await Navigator.pushNamed(context, '/admin_login');
  }

  // Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppStrings.homeScreenTitle,
          style: GoogleFonts.manrope(
            fontSize: AppDimensions.screenTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Admin login button
          Card(
            margin: const EdgeInsets.all(15),
            color: AppColors.cardBackgroundColor,
            elevation: AppDimensions.cardElevation,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.homeScreenCardQuestion,
                        style: TextStyle(
                          fontSize: AppDimensions.homeScreenCardFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _onCloseAdminCardBtnPressed,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _onOpenAdminPageBtnPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 82.6,
                        vertical: 17,
                      ), // Adjust the padding values as needed
                      textStyle: const TextStyle(
                        fontSize: AppDimensions.homeScreenCardFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: AppColors.cardButtonBackgroundColor,
                    ),
                    child: Text(
                      AppStrings.homeScreenCardTextButton,
                      style: GoogleFonts.manrope(
                        textStyle: const TextStyle(
                          fontSize: AppDimensions.homeScreenCardFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Donation progress and log (history)
          Expanded(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.all(15),
                  elevation: AppDimensions.cardElevation,
                  color: AppColors.cardBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.homeScreenRequiredAvarageAmount,
                              style: GoogleFonts.manrope(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppDimensions.cardAmountText,
                                ),
                              ),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .doc("/masjidConfigs/monthlyFee")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return const Text('Document does not exist');
                                }

                                // Extracting data from snapshot
                                var amount = snapshot.data!['amount'];
                                var currency = snapshot.data!['currency'];

                                // Widget for displaying amount and currency
                                Widget amountAndCurrencyWidget() {
                                  return Row(
                                    children: [
                                      Text(
                                        '$amount',
                                        style: GoogleFonts.manrope(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppDimensions
                                                .requiredTotalAmount,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '$currency',
                                        style: GoogleFonts.manrope(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppDimensions
                                                .requiredTotalAmount,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Returning the widget
                                return amountAndCurrencyWidget();
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.homeScreenCollectedAmountText,
                              style: GoogleFonts.manrope(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppDimensions.cardAmountText,
                                ),
                              ),
                            ),
                            Text(
                              AppStrings.homeScreenCollectedAmount,
                              style: GoogleFonts.manrope(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppDimensions.collectedAmount,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Progress Bar
                        LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: AppColors.white,
                          color: AppColors.cardButtonBackgroundColor,
                          minHeight: 16,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RecordDonationScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        16, // Adjust this value as needed
                                    vertical: 17,
                                  ),
                                  backgroundColor:
                                      AppColors.cardButtonBackgroundColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.monetization_on,
                                      color: AppColors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      AppStrings.homeScreenRecordDonation,
                                      style: GoogleFonts.manrope(
                                        textStyle: const TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppDimensions
                                              .homeScreenCardFontSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(15),
                  elevation: AppDimensions.cardElevation,
                  color: AppColors.cardBackgroundColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Text(
                            AppStrings.homeScreenRecentPaymentsTitleText,
                            style: GoogleFonts.manrope(
                              textStyle: const TextStyle(
                                fontSize: AppDimensions.homeScreenCardFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('/donations')
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Text('No data found.');
                              }

                              var donations = snapshot.data!.docs;

                              return Column(
                                children: donations.map<Widget>(
                                    (QueryDocumentSnapshot donation) {
                                  var donorName = donation['donorName'];
                                  var donationAmount =
                                      donation['donationAmount'];

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 214, 214, 214),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$donorName',
                                          style: GoogleFonts.manrope(
                                            textStyle: const TextStyle(
                                              fontSize: AppDimensions
                                                  .transactionHistoryNameFontSize,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '$donationAmount',
                                          style: GoogleFonts.manrope(
                                            textStyle: const TextStyle(
                                              fontSize: AppDimensions
                                                  .transactionHistoryNameFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
