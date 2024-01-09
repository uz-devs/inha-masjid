// Stdlib
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3rd party
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Local
import 'package:inha_masjid/utils/colors.dart';
import 'package:inha_masjid/utils/dimensions.dart';
import 'package:inha_masjid/utils/extensions.dart';
import 'package:inha_masjid/utils/strings.dart';

class AdminPanelScreen extends StatelessWidget {
  // Constructor
  AdminPanelScreen({super.key});

  // Variables
  final _monthlyExpenseController = TextEditingController();
  final _postNewAnnouncementTitleController = TextEditingController();
  final _postNewAnnouncementBodyController = TextEditingController();
  final _masjidBankNameController = TextEditingController();
  final _masjidBankNumberController = TextEditingController();

  // Functions
  void _onBackPressed(context) {
    Navigator.pop(context);
  }

  void _onPrayerTimePressed(context, prayerName) async {
    // Open time picker modal view
    var tod = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    // User cancelled the time picker
    if (tod == null) {
      Fluttertoast.showToast(
        msg: AppStrings.prayerTimeUpdateCanceledMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Update prayer time on firestore
    var fs = FirebaseFirestore.instance;
    var prayerTimeDoc = fs.doc(FirestorePaths.prayerTimeDoc(prayerName));
    await prayerTimeDoc.update({
      'hour': tod.hour,
      'minute': tod.minute,
    });

    // Show success message (after await)
    Fluttertoast.showToast(
      msg: AppStrings.prayerTimeUpdatedMessage(prayerName),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _updateMonthlyRentBtnPressed(context) async {
    // Try to convert inputted amount to int
    var newMonthlyRentAmount = int.tryParse(_monthlyExpenseController.text);

    // Couldn't parse to int
    if (newMonthlyRentAmount == null) {
      Fluttertoast.showToast(
        msg: AppStrings.rentUpdateFailedMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Update monthly rent amount on firestore
    var fs = FirebaseFirestore.instance;
    var doc = fs.doc(FirestorePaths.monthlyRentDoc);
    await doc.set({"amount": newMonthlyRentAmount});

    // Show success message (after await)
    Fluttertoast.showToast(
      msg: AppStrings.rentUpdatedMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Clear the monthly expense text field
    _monthlyExpenseController.clear();
  }

  void _postNewAnnouncementBtnPresses(content) {
    // Get announcement details
    var timestamp = DateTime.now();
    var title = _postNewAnnouncementTitleController.text;
    var body = _postNewAnnouncementBodyController.text;
    var newMonthlyRentAmount = int.tryParse(_monthlyExpenseController.text);

    if (_postNewAnnouncementTitleController.text.isEmpty ||
        _postNewAnnouncementBodyController.text.isEmpty) {
      // Show an error message if the amount is not provided
      Fluttertoast.showToast(
        msg: 'Please enter the bank name and number',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return; // Do not proceed further if the amount is not provided
    }
    var fs = FirebaseFirestore.instance;
    var announcementsCollection =
        fs.collection(FirestorePaths.announcementsCol);

    // Your data to be added to the document
    var announcementData = {
      "title": _postNewAnnouncementTitleController.text,
      "content": _postNewAnnouncementBodyController.text,
    };

    // Add a new document with the server timestamp
    announcementsCollection.add(announcementData).then((docRef) {
      print("Document written with ID: ${docRef.id}");
      // Show success message
      Fluttertoast.showToast(
        msg: 'Announcement posted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        // Change color to indicate success
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Clear text fields
      _postNewAnnouncementTitleController.clear();
      _postNewAnnouncementBodyController.clear();
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

  void _updateBankAccountBtnPressed(context) {
    if (_masjidBankNameController.text.isEmpty ||
        _masjidBankNumberController.text.isEmpty) {
      // Show an error message if the amount is not provided
      Fluttertoast.showToast(
        msg: 'Please enter the bank name and number',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return; // Do not proceed further if the amount is not provided
    }

    var accountNumber = int.parse(_masjidBankNumberController.text);
    var bankName = _masjidBankNameController.text;

    // keyin amountni olib firebase ga qo'yish kere
    var firestore = FirebaseFirestore.instance;
    firestore.doc("/masjidConfigs/bankAccount").set({
      "bankName": bankName,
      "accountNumber": accountNumber,
    }).then((_) {
      // Show success message
      Fluttertoast.showToast(
        msg: 'Masjid Bank account & name updated successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        // Change color to indicate success
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Clear the monthly expense text field
      _masjidBankNameController.clear();
      _masjidBankNumberController.clear();
    }).catchError((error) {
      print("Error updating bank account: $error");
      // Show error message
      Fluttertoast.showToast(
        msg: 'Error updating bank account name or number',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  // Overrides
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _onBackPressed(context),
        ),
        title: Text(
          AppStrings.inhaMasjidAdmin,
          style: GoogleFonts.manrope(
            fontSize: AppDimensions.screenTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Monthly expense card text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.updateMonthlyExpenseAmount,
                style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.adminPanelUpdateFontSize,
                  ),
                ),
              ),
            ),
            // Monthly expense amount adjustment widget
            Card(
              color: AppColors.cardBackgroundColor,
              elevation: AppDimensions.cardElevation,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(AppStrings.amount),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        // for below version 2 use this
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      controller: _monthlyExpenseController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.amountTooltip,
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Update monthly expense button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardPrimaryButtonColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () => _updateMonthlyRentBtnPressed(context),
                        child: Text(
                          AppStrings.update.toUpperCase(),
                          style: GoogleFonts.manrope(
                            textStyle: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.adminLoginButtonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Prayer times card title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.updatePrayerTimes,
                style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.adminPanelUpdateFontSize,
                  ),
                ),
              ),
            ),
            // Prayer times adjustment widget
            Card(
              color: AppColors.cardBackgroundColor,
              elevation: AppDimensions.cardElevation,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  children: [
                    // Prayer times adjustment buttons fields
                    Center(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          for (var prayerName in AppStrings.prayerNames)
                            Column(
                              children: [
                                // Prayer name text
                                Text(
                                  prayerName.capitalize(),
                                  style: GoogleFonts.manrope(
                                    fontSize:
                                        AppDimensions.prayerTimesTextFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),

                                // Prayer time button
                                StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .doc(FirestorePaths.prayerTimeDoc(
                                          prayerName))
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }

                                    // Get prayer time from firestore
                                    var doc = snapshot.data!;
                                    var hour =
                                        doc['hour'].toString().padLeft(2, '0');
                                    var minute = doc['minute']
                                        .toString()
                                        .padLeft(2, '0');

                                    // Widget with prayer time, when clicked opens a time picker (modal view) to adjust the prayer time.
                                    return SizedBox(
                                      width: 140,
                                      child: TextButton(
                                        onPressed: () => _onPrayerTimePressed(
                                            context, prayerName),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              side: const BorderSide(
                                                color: AppColors.textSecondary,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '$hour:$minute',
                                          style: GoogleFonts.manrope(
                                            textStyle: const TextStyle(
                                              fontSize: AppDimensions
                                                  .prayerTimesFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Announcement post card title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.postNewAnnouncement,
                style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.adminPanelUpdateFontSize,
                  ),
                ),
              ),
            ),

            // Announcement post text content widget
            Card(
              color: AppColors.cardBackgroundColor,
              elevation: AppDimensions.cardElevation,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO come back here

                    // Announcement title text field (editable)
                    const Text(AppStrings.announcementTitle),
                    TextFormField(
                      controller: _postNewAnnouncementTitleController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.announcementTitleTooltip,
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Announcement body text field (editable)
                    const Text(AppStrings.announcementBody),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: _postNewAnnouncementBodyController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.announcementBodyTooltip,
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        contentPadding: EdgeInsets.only(bottom: 0),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardPrimaryButtonColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            _postNewAnnouncementBtnPresses(context),
                        child: Text(
                          AppStrings.adminPanelUpdatePostButtonText
                              .toUpperCase(),
                          style: GoogleFonts.manrope(
                            textStyle: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.adminLoginButtonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Masjid Bank Account Update post card title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.updateMasjidBankAccountTitle,
                style: GoogleFonts.manrope(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.adminPanelUpdateFontSize,
                  ),
                ),
              ),
            ),
            Card(
              color: AppColors.cardBackgroundColor,
              elevation: AppDimensions.cardElevation,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(AppStrings.bankName),
                    TextFormField(
                      controller: _masjidBankNameController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.bankNameTooltip,
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        contentPadding: EdgeInsets.only(bottom: 0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(AppStrings.bankNumber),
                    TextFormField(
                      controller: _masjidBankNumberController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.bankNumberTooltip,
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        contentPadding: EdgeInsets.only(bottom: 0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardPrimaryButtonColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () => _updateBankAccountBtnPressed(context),
                        child: Text(
                          AppStrings.updateMasjidBankAccountButtonText,
                          style: GoogleFonts.manrope(
                            textStyle: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.adminLoginButtonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
