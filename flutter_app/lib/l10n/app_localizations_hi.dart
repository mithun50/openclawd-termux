// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'OpenClaw';

  @override
  String get aiGateway => 'Android के लिए AI गेटवे';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get checkingSetup => 'सेटअप स्थिति जाँच रही है...';

  @override
  String get setupTitle => 'OpenClaw सेटअप करें';

  @override
  String get setupDescription =>
      'यह Ubuntu, Node.js और OpenClaw को एक स्वतंत्र वातावरण में डाउनलोड करेगा।';

  @override
  String get settingUpEnvironment =>
      'वातावरण सेट हो रहा है। इसमें कई मिनट लग सकते हैं।';

  @override
  String get beginSetup => 'सेटअप शुरू करें';

  @override
  String get retrySetup => 'पुनः प्रयास करें';

  @override
  String get configureApiKeys => 'API कुंजियाँ कॉन्फ़िगर करें';

  @override
  String get storageRequirement =>
      '~500MB स्टोरेज और इंटरनेट कनेक्शन आवश्यक है';

  @override
  String get unknownError => 'अज्ञात त्रुटि';

  @override
  String get stepDownloadRootfs => 'Ubuntu rootfs डाउनलोड करें';

  @override
  String get stepExtractRootfs => 'Rootfs निकालें';

  @override
  String get stepInstallNode => 'Node.js इंस्टॉल करें';

  @override
  String get stepInstallOpenClaw => 'OpenClaw इंस्टॉल करें';

  @override
  String get stepConfigureBypass => 'Bionic Bypass कॉन्फ़िगर करें';

  @override
  String get setupComplete => 'सेटअप पूरा हुआ!';

  @override
  String get quickActions => 'त्वरित कार्रवाई';

  @override
  String get terminal => 'टर्मिनल';

  @override
  String get terminalSubtitle => 'OpenClaw के साथ Ubuntu शेल खोलें';

  @override
  String get webDashboard => 'वेब डैशबोर्ड';

  @override
  String get webDashboardSubtitleRunning =>
      'OpenClaw डैशबोर्ड ब्राउज़र में खोलें';

  @override
  String get startGatewayFirst => 'पहले गेटवे शुरू करें';

  @override
  String get onboarding => 'ऑनबोर्डिंग';

  @override
  String get onboardingSubtitle => 'API कुंजियाँ और बाइंडिंग कॉन्फ़िगर करें';

  @override
  String get logs => 'लॉग्स';

  @override
  String get logsSubtitle => 'गेटवे आउटपुट और त्रुटियाँ देखें';

  @override
  String versionLabel(String version) {
    return 'OpenClaw v$version';
  }

  @override
  String byLine(String author, String org) {
    return '$author द्वारा | $org';
  }

  @override
  String get terminalTitle => 'टर्मिनल';

  @override
  String get startingTerminal => 'टर्मिनल शुरू हो रहा है...';

  @override
  String failedToStartTerminal(String error) {
    return 'टर्मिनल शुरू करने में विफल: $error';
  }

  @override
  String get openLink => 'लिंक खोलें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get copy => 'कॉपी';

  @override
  String get open => 'खोलें';

  @override
  String get paste => 'पेस्ट';

  @override
  String get restart => 'पुनः आरंभ';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get linkCopied => 'लिंक कॉपी किया गया';

  @override
  String get noUrlFound => 'चयन में कोई URL नहीं मिला';

  @override
  String get copyTooltip => 'कॉपी';

  @override
  String get openUrlTooltip => 'URL खोलें';

  @override
  String get pasteTooltip => 'पेस्ट';

  @override
  String get restartTooltip => 'पुनः आरंभ';

  @override
  String processExited(int code) {
    return 'प्रक्रिया कोड $code के साथ समाप्त हुई';
  }

  @override
  String get webDashboardTitle => 'वेब डैशबोर्ड';

  @override
  String failedToLoadDashboard(String error) {
    return 'डैशबोर्ड लोड करने में विफल: $error';
  }

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get gatewayLogs => 'गेटवे लॉग्स';

  @override
  String get filterLogs => 'लॉग्स फ़िल्टर करें...';

  @override
  String get copyAllLogs => 'सभी लॉग्स कॉपी करें';

  @override
  String get autoScrollOn => 'ऑटो-स्क्रॉल चालू';

  @override
  String get autoScrollOff => 'ऑटो-स्क्रॉल बंद';

  @override
  String get noLogsYet => 'अभी कोई लॉग नहीं। गेटवे शुरू करें।';

  @override
  String get noMatchingLogs => 'कोई मिलते जुलते लॉग नहीं।';

  @override
  String get logsCopied => 'लॉग्स क्लिपबोर्ड पर कॉपी किए गए';

  @override
  String get onboardingTitle => 'OpenClaw ऑनबोर्डिंग';

  @override
  String get startingOnboarding => 'ऑनबोर्डिंग शुरू हो रही है...';

  @override
  String get goToDashboard => 'डैशबोर्ड पर जाएँ';

  @override
  String get done => 'पूरा हुआ';

  @override
  String get onboardingError =>
      'ऑनबोर्डिंग में त्रुटि हुई। ऊपर टर्मिनल आउटपुट जाँचें।';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get general => 'सामान्य';

  @override
  String get autoStartGateway => 'गेटवे ऑटो-स्टार्ट';

  @override
  String get autoStartSubtitle => 'ऐप खुलने पर गेटवे शुरू करें';

  @override
  String get batteryOptimization => 'बैटरी ऑप्टिमाइज़ेशन';

  @override
  String get batteryOptimized =>
      'ऑप्टिमाइज़्ड (बैकग्राउंड सेशन बंद हो सकते हैं)';

  @override
  String get batteryUnrestricted => 'अप्रतिबंधित (अनुशंसित)';

  @override
  String get systemInfo => 'सिस्टम जानकारी';

  @override
  String get architecture => 'आर्किटेक्चर';

  @override
  String get prootPath => 'PRoot पथ';

  @override
  String get rootfs => 'Rootfs';

  @override
  String get nodeJs => 'Node.js';

  @override
  String get openClaw => 'OpenClaw';

  @override
  String get installed => 'इंस्टॉल है';

  @override
  String get notInstalled => 'इंस्टॉल नहीं है';

  @override
  String get maintenance => 'रखरखाव';

  @override
  String get rerunSetup => 'सेटअप फिर से चलाएँ';

  @override
  String get rerunSubtitle => 'वातावरण पुनः इंस्टॉल या मरम्मत करें';

  @override
  String get about => 'बारे में';

  @override
  String aiGatewayVersion(String version) {
    return 'Android के लिए AI गेटवे\nसंस्करण $version';
  }

  @override
  String get developer => 'डेवलपर';

  @override
  String get license => 'लाइसेंस';

  @override
  String get contact => 'संपर्क';

  @override
  String get github => 'GitHub';

  @override
  String get instagram => 'Instagram';

  @override
  String get youtube => 'YouTube';

  @override
  String get playStore => 'Play Store';

  @override
  String get email => 'ईमेल';

  @override
  String get startGateway => 'गेटवे शुरू करें';

  @override
  String get stopGateway => 'गेटवे बंद करें';

  @override
  String get viewLogs => 'लॉग्स देखें';

  @override
  String get urlCopied => 'URL क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String gatewayRunning(String port) {
    return 'पोर्ट $port पर चल रहा है';
  }

  @override
  String get gatewayStopped => 'गेटवे बंद है';

  @override
  String get gatewayStarting => 'शुरू हो रहा है...';

  @override
  String get gatewayError => 'त्रुटि';
}
