// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'OpenClaw';

  @override
  String get aiGateway => 'بوابة الذكاء الاصطناعي لأندرويد';

  @override
  String get loading => 'جارِ التحميل...';

  @override
  String get checkingSetup => 'جارِ التحقق من حالة الإعداد...';

  @override
  String get setupTitle => 'إعداد OpenClaw';

  @override
  String get setupDescription =>
      'سيتم تنزيل Ubuntu و Node.js و OpenClaw في بيئة مستقلة.';

  @override
  String get settingUpEnvironment =>
      'جارِ إعداد البيئة. قد يستغرق هذا عدة دقائق.';

  @override
  String get beginSetup => 'بدء الإعداد';

  @override
  String get retrySetup => 'إعادة المحاولة';

  @override
  String get configureApiKeys => 'تكوين مفاتيح API';

  @override
  String get storageRequirement =>
      'يتطلب ~500 ميجابايت من التخزين واتصال بالإنترنت';

  @override
  String get unknownError => 'خطأ غير معروف';

  @override
  String get stepDownloadRootfs => 'تنزيل Ubuntu rootfs';

  @override
  String get stepExtractRootfs => 'استخراج rootfs';

  @override
  String get stepInstallNode => 'تثبيت Node.js';

  @override
  String get stepInstallOpenClaw => 'تثبيت OpenClaw';

  @override
  String get stepConfigureBypass => 'تكوين Bionic Bypass';

  @override
  String get setupComplete => 'اكتمل الإعداد!';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get terminal => 'الطرفية';

  @override
  String get terminalSubtitle => 'افتح واجهة Ubuntu مع OpenClaw';

  @override
  String get webDashboard => 'لوحة التحكم';

  @override
  String get webDashboardSubtitleRunning =>
      'افتح لوحة تحكم OpenClaw في المتصفح';

  @override
  String get startGatewayFirst => 'ابدأ البوابة أولاً';

  @override
  String get onboarding => 'الإعداد الأولي';

  @override
  String get onboardingSubtitle => 'تكوين مفاتيح API والربط';

  @override
  String get logs => 'السجلات';

  @override
  String get logsSubtitle => 'عرض مخرجات البوابة والأخطاء';

  @override
  String versionLabel(String version) {
    return 'OpenClaw v$version';
  }

  @override
  String byLine(String author, String org) {
    return 'بواسطة $author | $org';
  }

  @override
  String get terminalTitle => 'الطرفية';

  @override
  String get startingTerminal => 'جارِ بدء الطرفية...';

  @override
  String failedToStartTerminal(String error) {
    return 'فشل بدء الطرفية: $error';
  }

  @override
  String get openLink => 'فتح الرابط';

  @override
  String get cancel => 'إلغاء';

  @override
  String get copy => 'نسخ';

  @override
  String get open => 'فتح';

  @override
  String get paste => 'لصق';

  @override
  String get restart => 'إعادة التشغيل';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get linkCopied => 'تم نسخ الرابط';

  @override
  String get noUrlFound => 'لم يتم العثور على URL في التحديد';

  @override
  String get copyTooltip => 'نسخ';

  @override
  String get openUrlTooltip => 'فتح URL';

  @override
  String get pasteTooltip => 'لصق';

  @override
  String get restartTooltip => 'إعادة التشغيل';

  @override
  String processExited(int code) {
    return 'انتهت العملية برمز $code';
  }

  @override
  String get webDashboardTitle => 'لوحة التحكم';

  @override
  String failedToLoadDashboard(String error) {
    return 'فشل تحميل لوحة التحكم: $error';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get gatewayLogs => 'سجلات البوابة';

  @override
  String get filterLogs => 'تصفية السجلات...';

  @override
  String get copyAllLogs => 'نسخ جميع السجلات';

  @override
  String get autoScrollOn => 'التمرير التلقائي مفعّل';

  @override
  String get autoScrollOff => 'التمرير التلقائي معطّل';

  @override
  String get noLogsYet => 'لا توجد سجلات بعد. ابدأ البوابة.';

  @override
  String get noMatchingLogs => 'لا توجد سجلات مطابقة.';

  @override
  String get logsCopied => 'تم نسخ السجلات إلى الحافظة';

  @override
  String get onboardingTitle => 'الإعداد الأولي لـ OpenClaw';

  @override
  String get startingOnboarding => 'جارِ بدء الإعداد الأولي...';

  @override
  String get goToDashboard => 'الذهاب إلى لوحة التحكم';

  @override
  String get done => 'تم';

  @override
  String get onboardingError =>
      'واجه الإعداد الأولي خطأً. تحقق من مخرجات الطرفية أعلاه.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get general => 'عام';

  @override
  String get autoStartGateway => 'تشغيل البوابة تلقائياً';

  @override
  String get autoStartSubtitle => 'بدء البوابة عند فتح التطبيق';

  @override
  String get batteryOptimization => 'تحسين البطارية';

  @override
  String get batteryOptimized => 'محسّنة (قد تُنهي الجلسات في الخلفية)';

  @override
  String get batteryUnrestricted => 'بدون قيود (موصى به)';

  @override
  String get systemInfo => 'معلومات النظام';

  @override
  String get architecture => 'البنية';

  @override
  String get prootPath => 'مسار PRoot';

  @override
  String get rootfs => 'Rootfs';

  @override
  String get nodeJs => 'Node.js';

  @override
  String get openClaw => 'OpenClaw';

  @override
  String get installed => 'مثبّت';

  @override
  String get notInstalled => 'غير مثبّت';

  @override
  String get maintenance => 'الصيانة';

  @override
  String get rerunSetup => 'إعادة تشغيل الإعداد';

  @override
  String get rerunSubtitle => 'إعادة تثبيت أو إصلاح البيئة';

  @override
  String get about => 'حول';

  @override
  String aiGatewayVersion(String version) {
    return 'بوابة الذكاء الاصطناعي لأندرويد\nالإصدار $version';
  }

  @override
  String get developer => 'المطوّر';

  @override
  String get license => 'الترخيص';

  @override
  String get contact => 'اتصل بنا';

  @override
  String get github => 'GitHub';

  @override
  String get instagram => 'Instagram';

  @override
  String get youtube => 'YouTube';

  @override
  String get playStore => 'Play Store';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get startGateway => 'بدء البوابة';

  @override
  String get stopGateway => 'إيقاف البوابة';

  @override
  String get viewLogs => 'عرض السجلات';

  @override
  String get urlCopied => 'تم نسخ URL إلى الحافظة';

  @override
  String gatewayRunning(String port) {
    return 'يعمل على المنفذ $port';
  }

  @override
  String get gatewayStopped => 'البوابة متوقفة';

  @override
  String get gatewayStarting => 'جارِ البدء...';

  @override
  String get gatewayError => 'خطأ';
}
