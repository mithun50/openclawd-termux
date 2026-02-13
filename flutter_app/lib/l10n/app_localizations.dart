import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenClaw'**
  String get appTitle;

  /// No description provided for @aiGateway.
  ///
  /// In en, this message translates to:
  /// **'AI Gateway for Android'**
  String get aiGateway;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @checkingSetup.
  ///
  /// In en, this message translates to:
  /// **'Checking setup status...'**
  String get checkingSetup;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup OpenClaw'**
  String get setupTitle;

  /// No description provided for @setupDescription.
  ///
  /// In en, this message translates to:
  /// **'This will download Ubuntu, Node.js, and OpenClaw into a self-contained environment.'**
  String get setupDescription;

  /// No description provided for @settingUpEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Setting up the environment. This may take several minutes.'**
  String get settingUpEnvironment;

  /// No description provided for @beginSetup.
  ///
  /// In en, this message translates to:
  /// **'Begin Setup'**
  String get beginSetup;

  /// No description provided for @retrySetup.
  ///
  /// In en, this message translates to:
  /// **'Retry Setup'**
  String get retrySetup;

  /// No description provided for @configureApiKeys.
  ///
  /// In en, this message translates to:
  /// **'Configure API Keys'**
  String get configureApiKeys;

  /// No description provided for @storageRequirement.
  ///
  /// In en, this message translates to:
  /// **'Requires ~500MB of storage and an internet connection'**
  String get storageRequirement;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @stepDownloadRootfs.
  ///
  /// In en, this message translates to:
  /// **'Download Ubuntu rootfs'**
  String get stepDownloadRootfs;

  /// No description provided for @stepExtractRootfs.
  ///
  /// In en, this message translates to:
  /// **'Extract rootfs'**
  String get stepExtractRootfs;

  /// No description provided for @stepInstallNode.
  ///
  /// In en, this message translates to:
  /// **'Install Node.js'**
  String get stepInstallNode;

  /// No description provided for @stepInstallOpenClaw.
  ///
  /// In en, this message translates to:
  /// **'Install OpenClaw'**
  String get stepInstallOpenClaw;

  /// No description provided for @stepConfigureBypass.
  ///
  /// In en, this message translates to:
  /// **'Configure Bionic Bypass'**
  String get stepConfigureBypass;

  /// No description provided for @setupComplete.
  ///
  /// In en, this message translates to:
  /// **'Setup complete!'**
  String get setupComplete;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @terminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminal;

  /// No description provided for @terminalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open Ubuntu shell with OpenClaw'**
  String get terminalSubtitle;

  /// No description provided for @webDashboard.
  ///
  /// In en, this message translates to:
  /// **'Web Dashboard'**
  String get webDashboard;

  /// No description provided for @webDashboardSubtitleRunning.
  ///
  /// In en, this message translates to:
  /// **'Open OpenClaw dashboard in browser'**
  String get webDashboardSubtitleRunning;

  /// No description provided for @startGatewayFirst.
  ///
  /// In en, this message translates to:
  /// **'Start gateway first'**
  String get startGatewayFirst;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboarding;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure API keys and binding'**
  String get onboardingSubtitle;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @logsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View gateway output and errors'**
  String get logsSubtitle;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'OpenClaw v{version}'**
  String versionLabel(String version);

  /// No description provided for @byLine.
  ///
  /// In en, this message translates to:
  /// **'by {author} | {org}'**
  String byLine(String author, String org);

  /// No description provided for @terminalTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminalTitle;

  /// No description provided for @startingTerminal.
  ///
  /// In en, this message translates to:
  /// **'Starting terminal...'**
  String get startingTerminal;

  /// No description provided for @failedToStartTerminal.
  ///
  /// In en, this message translates to:
  /// **'Failed to start terminal: {error}'**
  String failedToStartTerminal(String error);

  /// No description provided for @openLink.
  ///
  /// In en, this message translates to:
  /// **'Open Link'**
  String get openLink;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @noUrlFound.
  ///
  /// In en, this message translates to:
  /// **'No URL found in selection'**
  String get noUrlFound;

  /// No description provided for @copyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyTooltip;

  /// No description provided for @openUrlTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open URL'**
  String get openUrlTooltip;

  /// No description provided for @pasteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get pasteTooltip;

  /// No description provided for @restartTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartTooltip;

  /// No description provided for @processExited.
  ///
  /// In en, this message translates to:
  /// **'Process exited with code {code}'**
  String processExited(int code);

  /// No description provided for @webDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Web Dashboard'**
  String get webDashboardTitle;

  /// No description provided for @failedToLoadDashboard.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard: {error}'**
  String failedToLoadDashboard(String error);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @gatewayLogs.
  ///
  /// In en, this message translates to:
  /// **'Gateway Logs'**
  String get gatewayLogs;

  /// No description provided for @filterLogs.
  ///
  /// In en, this message translates to:
  /// **'Filter logs...'**
  String get filterLogs;

  /// No description provided for @copyAllLogs.
  ///
  /// In en, this message translates to:
  /// **'Copy all logs'**
  String get copyAllLogs;

  /// No description provided for @autoScrollOn.
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll on'**
  String get autoScrollOn;

  /// No description provided for @autoScrollOff.
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll off'**
  String get autoScrollOff;

  /// No description provided for @noLogsYet.
  ///
  /// In en, this message translates to:
  /// **'No logs yet. Start the gateway.'**
  String get noLogsYet;

  /// No description provided for @noMatchingLogs.
  ///
  /// In en, this message translates to:
  /// **'No matching logs.'**
  String get noMatchingLogs;

  /// No description provided for @logsCopied.
  ///
  /// In en, this message translates to:
  /// **'Logs copied to clipboard'**
  String get logsCopied;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenClaw Onboarding'**
  String get onboardingTitle;

  /// No description provided for @startingOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Starting onboarding...'**
  String get startingOnboarding;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @onboardingError.
  ///
  /// In en, this message translates to:
  /// **'Onboarding encountered an error. Check the terminal output above.'**
  String get onboardingError;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @autoStartGateway.
  ///
  /// In en, this message translates to:
  /// **'Auto-start gateway'**
  String get autoStartGateway;

  /// No description provided for @autoStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start the gateway when the app opens'**
  String get autoStartSubtitle;

  /// No description provided for @batteryOptimization.
  ///
  /// In en, this message translates to:
  /// **'Battery Optimization'**
  String get batteryOptimization;

  /// No description provided for @batteryOptimized.
  ///
  /// In en, this message translates to:
  /// **'Optimized (may kill background sessions)'**
  String get batteryOptimized;

  /// No description provided for @batteryUnrestricted.
  ///
  /// In en, this message translates to:
  /// **'Unrestricted (recommended)'**
  String get batteryUnrestricted;

  /// No description provided for @systemInfo.
  ///
  /// In en, this message translates to:
  /// **'System Info'**
  String get systemInfo;

  /// No description provided for @architecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get architecture;

  /// No description provided for @prootPath.
  ///
  /// In en, this message translates to:
  /// **'PRoot path'**
  String get prootPath;

  /// No description provided for @rootfs.
  ///
  /// In en, this message translates to:
  /// **'Rootfs'**
  String get rootfs;

  /// No description provided for @nodeJs.
  ///
  /// In en, this message translates to:
  /// **'Node.js'**
  String get nodeJs;

  /// No description provided for @openClaw.
  ///
  /// In en, this message translates to:
  /// **'OpenClaw'**
  String get openClaw;

  /// No description provided for @installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// No description provided for @notInstalled.
  ///
  /// In en, this message translates to:
  /// **'Not installed'**
  String get notInstalled;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @rerunSetup.
  ///
  /// In en, this message translates to:
  /// **'Re-run setup'**
  String get rerunSetup;

  /// No description provided for @rerunSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reinstall or repair the environment'**
  String get rerunSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aiGatewayVersion.
  ///
  /// In en, this message translates to:
  /// **'AI Gateway for Android\nVersion {version}'**
  String aiGatewayVersion(String version);

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get youtube;

  /// No description provided for @playStore.
  ///
  /// In en, this message translates to:
  /// **'Play Store'**
  String get playStore;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @startGateway.
  ///
  /// In en, this message translates to:
  /// **'Start Gateway'**
  String get startGateway;

  /// No description provided for @stopGateway.
  ///
  /// In en, this message translates to:
  /// **'Stop Gateway'**
  String get stopGateway;

  /// No description provided for @viewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogs;

  /// No description provided for @urlCopied.
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get urlCopied;

  /// No description provided for @gatewayRunning.
  ///
  /// In en, this message translates to:
  /// **'Running on port {port}'**
  String gatewayRunning(String port);

  /// No description provided for @gatewayStopped.
  ///
  /// In en, this message translates to:
  /// **'Gateway is stopped'**
  String get gatewayStopped;

  /// No description provided for @gatewayStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get gatewayStarting;

  /// No description provided for @gatewayError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get gatewayError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'es',
        'fr',
        'hi',
        'ja'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
