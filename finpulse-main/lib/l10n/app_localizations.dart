import 'package:flutter/material.dart';

/// Supported languages for FinPulse
enum AppLanguage {
  english('en', 'English', '🇬🇧'),
  hindi('hi', 'हिंदी', '🇮🇳'),
  hinglish('hi-en', 'Hinglish', '🔀');

  final String code;
  final String name;
  final String flag;
  
  const AppLanguage(this.code, this.name, this.flag);
}

/// App Localizations for FinPulse
/// Supports English, Hindi, and Hinglish
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// Helper method to get the current localization
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? 
           AppLocalizations(const Locale('en'));
  }

  /// Localization delegate
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),      // English
    Locale('hi'),      // Hindi
    Locale('hi', 'EN'), // Hinglish (Hindi-English mix)
  ];

  /// Get current language code
  String get languageCode => locale.languageCode;

  /// Check if Hinglish
  bool get isHinglish => locale.countryCode == 'EN' && locale.languageCode == 'hi';

  // ============ Common Strings ============
  
  String get appName => 'FinPulse';
  
  String get dashboard {
    if (languageCode == 'hi') return isHinglish ? 'Dashboard' : 'डैशबोर्ड';
    return 'Dashboard';
  }
  
  String get settings {
    if (languageCode == 'hi') return isHinglish ? 'Settings' : 'सेटिंग्स';
    return 'Settings';
  }
  
  String get transactions {
    if (languageCode == 'hi') return isHinglish ? 'Transactions' : 'लेनदेन';
    return 'Transactions';
  }
  
  String get categories {
    if (languageCode == 'hi') return isHinglish ? 'Categories' : 'श्रेणियाँ';
    return 'Categories';
  }
  
  String get stats {
    if (languageCode == 'hi') return isHinglish ? 'Stats' : 'आँकड़े';
    return 'Stats';
  }

  // ============ Dashboard Strings ============
  
  String get totalBalance {
    if (languageCode == 'hi') return isHinglish ? 'Total Balance' : 'कुल शेष';
    return 'Total Balance';
  }
  
  String get todaysSpending {
    if (languageCode == 'hi') return isHinglish ? "Aaj ka Kharcha" : "आज का खर्च";
    return "Today's Spending";
  }
  
  String get monthlySpending {
    if (languageCode == 'hi') return isHinglish ? "Mahine ka Kharcha" : "महीने का खर्च";
    return "Monthly Spending";
  }
  
  String get yetToTransponse {
    if (languageCode == 'hi') return isHinglish ? "Pending Transactions" : "बाकी लेनदेन";
    return "Yet to Transponse";
  }
  
  String pendingCount(int count) {
    if (languageCode == 'hi') return isHinglish ? "$count pending" : "$count बाकी";
    return "$count pending";
  }
  
  String get allCaughtUp {
    if (languageCode == 'hi') return isHinglish ? "Sab ho gaya!" : "सब हो गया!";
    return "All caught up!";
  }
  
  String get noPendingTransactions {
    if (languageCode == 'hi') return isHinglish ? "Koi pending transaction nahi" : "कोई बाकी लेनदेन नहीं";
    return "No pending transactions";
  }

  // ============ AI Chat Strings ============
  
  String get aiChat {
    if (languageCode == 'hi') return isHinglish ? "AI Chat" : "AI चैट";
    return "AI Chat";
  }
  
  String get askAboutSpending {
    if (languageCode == 'hi') return isHinglish ? "Apne kharche ke baare mein pucho..." : "अपने खर्चे के बारे में पूछें...";
    return "Ask about your spending...";
  }
  
  String get listening {
    if (languageCode == 'hi') return isHinglish ? "Sun raha hoon..." : "सुन रहा हूँ...";
    return "Listening...";
  }
  
  String get aiWelcome {
    if (languageCode == 'hi') {
      return isHinglish 
          ? "Hi! Main aapka FinPulse AI assistant hoon 💰\n\nMujhse spending ke baare mein kuch bhi pucho!"
          : "नमस्ते! मैं आपका FinPulse AI सहायक हूँ 💰\n\nमुझसे खर्चे के बारे में कुछ भी पूछें!";
    }
    return "Hi! I'm your FinPulse AI assistant 💰\n\nAsk me anything about your spending!";
  }

  // ============ Categories ============
  
  String get food {
    if (languageCode == 'hi') return isHinglish ? "Food" : "खाना";
    return "Food";
  }
  
  String get groceries {
    if (languageCode == 'hi') return isHinglish ? "Groceries" : "किराना";
    return "Groceries";
  }
  
  String get transport {
    if (languageCode == 'hi') return isHinglish ? "Transport" : "यातायात";
    return "Transport";
  }
  
  String get shopping {
    if (languageCode == 'hi') return isHinglish ? "Shopping" : "शॉपिंग";
    return "Shopping";
  }
  
  String get entertainment {
    if (languageCode == 'hi') return isHinglish ? "Entertainment" : "मनोरंजन";
    return "Entertainment";
  }
  
  String get bills {
    if (languageCode == 'hi') return isHinglish ? "Bills" : "बिल";
    return "Bills";
  }
  
  String get health {
    if (languageCode == 'hi') return isHinglish ? "Health" : "स्वास्थ्य";
    return "Health";
  }

  // ============ Settings Strings ============
  
  String get language {
    if (languageCode == 'hi') return isHinglish ? "Language" : "भाषा";
    return "Language";
  }
  
  String get notifications {
    if (languageCode == 'hi') return isHinglish ? "Notifications" : "सूचनाएँ";
    return "Notifications";
  }
  
  String get privacy {
    if (languageCode == 'hi') return isHinglish ? "Privacy" : "गोपनीयता";
    return "Privacy";
  }
  
  String get about {
    if (languageCode == 'hi') return isHinglish ? "About" : "के बारे में";
    return "About";
  }
  
  String get logout {
    if (languageCode == 'hi') return isHinglish ? "Logout" : "लॉगआउट";
    return "Logout";
  }

  // ============ Onboarding Strings ============
  
  String get welcomeToFinPulse {
    if (languageCode == 'hi') {
      return isHinglish ? "FinPulse mein Swagat hai!" : "FinPulse में स्वागत है!";
    }
    return "Welcome to FinPulse";
  }
  
  String get aiPoweredFinance {
    if (languageCode == 'hi') {
      return isHinglish ? "AI-Powered Finance Companion" : "AI-संचालित वित्त साथी";
    }
    return "AI-Powered Finance Companion";
  }
  
  String get smsAccess {
    if (languageCode == 'hi') return isHinglish ? "SMS Access" : "SMS पहुँच";
    return "SMS Access";
  }
  
  String get notificationAccess {
    if (languageCode == 'hi') return isHinglish ? "Notification Access" : "सूचना पहुँच";
    return "Notification Access";
  }
  
  String get getStarted {
    if (languageCode == 'hi') return isHinglish ? "Shuru Karein" : "शुरू करें";
    return "Get Started";
  }
  
  String get next {
    if (languageCode == 'hi') return isHinglish ? "Aage" : "आगे";
    return "Next";
  }
  
  String get skip {
    if (languageCode == 'hi') return isHinglish ? "Skip" : "छोड़ें";
    return "Skip";
  }
  
  String get dataStaysOnDevice {
    if (languageCode == 'hi') {
      return isHinglish ? "Data aapke device par hi rehta hai" : "डेटा आपके डिवाइस पर ही रहता है";
    }
    return "Data stays on your device";
  }

  // ============ Transaction Status ============
  
  String get pending {
    if (languageCode == 'hi') return isHinglish ? "Pending" : "लंबित";
    return "Pending";
  }
  
  String get verified {
    if (languageCode == 'hi') return isHinglish ? "Verified" : "सत्यापित";
    return "Verified";
  }
  
  String get confirmed {
    if (languageCode == 'hi') return isHinglish ? "Confirmed" : "पुष्ट";
    return "Confirmed";
  }

  // ============ Amount Formatting ============
  
  String spent(String amount) {
    if (languageCode == 'hi') return isHinglish ? "₹$amount kharch" : "₹$amount खर्च";
    return "₹$amount spent";
  }
  
  String at(String merchant) {
    if (languageCode == 'hi') return isHinglish ? "$merchant par" : "$merchant पर";
    return "at $merchant";
  }
}

/// Localizations delegate
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Language provider for dynamic language switching
class LanguageProvider with ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;
  
  AppLanguage get currentLanguage => _currentLanguage;
  
  Locale get locale {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.hindi:
        return const Locale('hi');
      case AppLanguage.hinglish:
        return const Locale('hi', 'EN');
    }
  }
  
  void setLanguage(AppLanguage language) {
    _currentLanguage = language;
    notifyListeners();
  }
  
  void toggleLanguage() {
    final languages = AppLanguage.values;
    final nextIndex = (languages.indexOf(_currentLanguage) + 1) % languages.length;
    setLanguage(languages[nextIndex]);
  }
}
