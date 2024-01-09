// Stdlib
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inha_masjid/utils/colors.dart';
import 'package:inha_masjid/utils/dimensions.dart';
import 'package:inha_masjid/utils/strings.dart';
import 'package:flutter/services.dart';

class RecordDonationScreen extends StatefulWidget {
  const RecordDonationScreen({super.key});

  @override
  State<RecordDonationScreen> createState() => _RecordDonationScreenState();
}

class _RecordDonationScreenState extends State<RecordDonationScreen> {
  // Variables
  final _amountPaidController = TextEditingController();
  final _donarNameController = TextEditingController();

  // Functions
  void _recordMyDonationBtnPressed() {
    var firestore = FirebaseFirestore.instance;
    var donations = firestore.collection(FirestorePaths.donationsCol);
    var donationsData = {
      'donorName': _donarNameController.text,
      'donationAmount': _amountPaidController.text,
    };
    if (_donarNameController.text.isEmpty ||
        _amountPaidController.text.isEmpty) {
      // Show a message to the user indicating that both fields are required
      Fluttertoast.showToast(
        msg: 'Donor name and donation amount are required',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return; // Exit the method without proceeding to Firestore
    }
    donations.add(donationsData).then((docRef) {
      print("Document written with ID: ${docRef.id}");
      Fluttertoast.showToast(
        msg: 'Announcement posted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green, // Change color to indicate success
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Clear text fields
      _donarNameController.clear();
      _amountPaidController.clear();
    }).catchError((error) {
      print("Error adding document: $error");
      // Show error message
      Fluttertoast.showToast(
        msg: 'Error posting announcement',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  String accountNumber = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppStrings.recordMyDonation,
          style: GoogleFonts.manrope(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                AppStrings.bankAccountNumber,
                style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.masjidBankAccountTitleSize,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: AppColors.cardBackgroundColor,
              elevation: AppDimensions.cardElevation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .doc(FirestorePaths.bankAccountDoc)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // Access the first document in the collection (you may need to adjust this)
                    var document = snapshot.data!;

                    // Access the fields 'accountNumber' and 'bankName' from the document
                    var accountNumber = document['accountNumber'];
                    var bankName = document['bankName'];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$accountNumber',
                          style: GoogleFonts.manrope(
                            textStyle: const TextStyle(
                              fontSize:
                                  AppDimensions.masjidBankAccountCardFontSize,
                            ),
                          ),
                        ),
                        Text(
                          '$bankName',
                          style: GoogleFonts.manrope(
                            textStyle: const TextStyle(
                              fontSize:
                                  AppDimensions.masjidBankAccountCardFontSize,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: accountNumber));

                      // Optionally, you can show a snackbar or any other feedback to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account Number copied to clipboard'),
                        ),
                      );
                    },
                    child: Text(
                      'Copy Account Number',
                      style: GoogleFonts.manrope(
                        fontSize: AppDimensions.recordMyDonationSmallFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                AppStrings.donationDetails,
                style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.masjidBankAccountTitleSize,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextField(
                controller: _amountPaidController,
                decoration: InputDecoration(
                  hintText: AppStrings.donationDetailsAmount,
                  hintStyle: GoogleFonts.manrope(
                    textStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.masjidBankAccountCardFontSize,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackgroundColor,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: Text(
                    AppStrings.donatedAmountOne,
                    style: GoogleFonts.manrope(
                      color: AppColors.widgetLightPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.recordMyDonationSmallFont,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: Text(
                    AppStrings.donatedAmountTwo,
                    style: GoogleFonts.manrope(
                      color: AppColors.widgetLightPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.recordMyDonationSmallFont,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: Text(
                    AppStrings.donatedAmountThree,
                    style: GoogleFonts.manrope(
                      color: AppColors.widgetLightPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.recordMyDonationSmallFont,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: Text(
                    AppStrings.donatedAmountFour,
                    style: GoogleFonts.manrope(
                      color: AppColors.widgetLightPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.recordMyDonationSmallFont,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                AppStrings.recordMyDonationSenderName,
                style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.masjidBankAccountTitleSize,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextField(
                controller: _donarNameController,
                decoration: InputDecoration(
                  hintText: AppStrings.recordMyDonationDonateNameText,
                  hintStyle: GoogleFonts.manrope(
                    textStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.masjidBankAccountCardFontSize,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackgroundColor,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.cardPrimaryButtonColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () => _recordMyDonationBtnPressed(),
                child: Text(
                  AppStrings.recordMyDonationButtonText,
                  style: GoogleFonts.manrope(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: AppDimensions.recorButtonFontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
