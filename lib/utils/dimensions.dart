// All dimensions used in the app (logo sizes, button sizes, paddings, etc.) are
// are defined here. This is to ensure that the app is responsive and consistent
// across all app screens and devices.

/// Class for streamlining the use of dimensions in the app (for consistency across
/// all screens and devices, easy maintenance, and app UI responsiveness).
class AppDimensions {
  // Private constructor to prevent instances from this class
  AppDimensions._();

  // Dimensions (primarily taken from Figma prototype)
  // ref: https://www.figma.com/file/sflifKnmkstz8j02emIXMS/Inha-Masjid-draft-(work-on-this)?type=design&node-id=0%3A1&mode=design&t=UmlmHZfCo964xBvV-1

  // ref Figma prototype: 48.8x60.22 logo in 393x852 container
  static const double imgWelcomeLogoFactor = 48.8 / 393;

  // ref Figma prototype: 329x329 square image in 393x393 container
  static const double imgWelcomeIllustrationFactor = 329 / 393;

  // ref Figma prototype: 168x56 button in 393x852 container
  static const double btnWelcomeNavWidthFactor = 168 / 393;
  static const double btnWelcomeNavHeightFactor = 56 / 852;

  // Font sizes
  // Screen titles (app bar text)
  static const double screenTitleFontSize = 24;
  static const double cardTitleFontSize = 24;
  static const double cardTitleContentSize = 18;

  // Card Text sizes
  static const double cardElevation = 0;
  static const double cardAmountText = 10;
  static const double requiredTotalAmount = 32;
  static const double collectedAmount = 24;
  static const double donateButtonHeight = 50;
  static const double transactionHistoryNameFontSize = 14;
  static const double transactionHistoryDateFontSize = 12;
  static const double bottomNavigationBarIconSize = 24;

  // announcements page card font sizes
  static const double announcementsPageDateFontSize = 14;

  // prayer times font sizes

  static const double prayerTimesTextFontSize = 16;
  static const double prayerTimesFontSize = 32;

  // Admin login
  static const double adminLoginIconFontSize = 130;
  static const double adminLoginButtonTextSize = 16;

  // Admin panel
  static const double adminPanelUpdateFontSize = 18;
  static const double adminPanelMonthlyExpenseAmountFontSize = 32;

  // Record My Donation
  static const double masjidBankAccountTitleSize = 16;
  static const double masjidBankAccountCardFontSize = 14;
  static const double recordMyDonationSmallFont = 12;
  static const double recorButtonFontSize = 16;
}
