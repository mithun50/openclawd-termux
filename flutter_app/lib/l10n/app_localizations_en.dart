// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OpenClaw';

  @override
  String get aiGateway => 'AI Gateway for Android';

  @override
  String get loading => 'Loading...';

  @override
  String get checkingSetup => 'Checking setup status...';

  @override
  String get setupTitle => 'Setup OpenClaw';

  @override
  String get setupDescription =>
      'This will download Ubuntu, Node.js, and OpenClaw into a self-contained environment.';

  @override
  String get settingUpEnvironment =>
      'Setting up the environment. This may take several minutes.';

  @override
  String get beginSetup => 'Begin Setup';

  @override
  String get retrySetup => 'Retry Setup';

  @override
  String get configureApiKeys => 'Configure API Keys';

  @override
  String get storageRequirement =>
      'Requires ~500MB of storage and an internet connection';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get stepDownloadRootfs => 'Download Ubuntu rootfs';

  @override
  String get stepExtractRootfs => 'Extract rootfs';

  @override
  String get stepInstallNode => 'Install Node.js';

  @override
  String get stepInstallOpenClaw => 'Install OpenClaw';

  @override
  String get stepConfigureBypass => 'Configure Bionic Bypass';

  @override
  String get setupComplete => 'Setup complete!';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get terminal => 'Terminal';

  @override
  String get terminalSubtitle => 'Open Ubuntu shell with OpenClaw';

  @override
  String get webDashboard => 'Web Dashboard';

  @override
  String get webDashboardSubtitleRunning =>
      'Open OpenClaw dashboard in browser';

  @override
  String get startGatewayFirst => 'Start gateway first';

  @override
  String get onboarding => 'Onboarding';

  @override
  String get onboardingSubtitle => 'Configure API keys and binding';

  @override
  String get logs => 'Logs';

  @override
  String get logsSubtitle => 'View gateway output and errors';

  @override
  String versionLabel(String version) {
    return 'OpenClaw v$version';
  }

  @override
  String byLine(String author, String org) {
    return 'by $author | $org';
  }

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get startingTerminal => 'Starting terminal...';

  @override
  String failedToStartTerminal(String error) {
    return 'Failed to start terminal: $error';
  }

  @override
  String get openLink => 'Open Link';

  @override
  String get cancel => 'Cancel';

  @override
  String get copy => 'Copy';

  @override
  String get open => 'Open';

  @override
  String get paste => 'Paste';

  @override
  String get restart => 'Restart';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get noUrlFound => 'No URL found in selection';

  @override
  String get copyTooltip => 'Copy';

  @override
  String get openUrlTooltip => 'Open URL';

  @override
  String get pasteTooltip => 'Paste';

  @override
  String get restartTooltip => 'Restart';

  @override
  String processExited(int code) {
    return 'Process exited with code $code';
  }

  @override
  String get webDashboardTitle => 'Web Dashboard';

  @override
  String failedToLoadDashboard(String error) {
    return 'Failed to load dashboard: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get gatewayLogs => 'Gateway Logs';

  @override
  String get filterLogs => 'Filter logs...';

  @override
  String get copyAllLogs => 'Copy all logs';

  @override
  String get autoScrollOn => 'Auto-scroll on';

  @override
  String get autoScrollOff => 'Auto-scroll off';

  @override
  String get noLogsYet => 'No logs yet. Start the gateway.';

  @override
  String get noMatchingLogs => 'No matching logs.';

  @override
  String get logsCopied => 'Logs copied to clipboard';

  @override
  String get onboardingTitle => 'OpenClaw Onboarding';

  @override
  String get startingOnboarding => 'Starting onboarding...';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get done => 'Done';

  @override
  String get onboardingError =>
      'Onboarding encountered an error. Check the terminal output above.';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get autoStartGateway => 'Auto-start gateway';

  @override
  String get autoStartSubtitle => 'Start the gateway when the app opens';

  @override
  String get batteryOptimization => 'Battery Optimization';

  @override
  String get batteryOptimized => 'Optimized (may kill background sessions)';

  @override
  String get batteryUnrestricted => 'Unrestricted (recommended)';

  @override
  String get systemInfo => 'System Info';

  @override
  String get architecture => 'Architecture';

  @override
  String get prootPath => 'PRoot path';

  @override
  String get rootfs => 'Rootfs';

  @override
  String get nodeJs => 'Node.js';

  @override
  String get openClaw => 'OpenClaw';

  @override
  String get installed => 'Installed';

  @override
  String get notInstalled => 'Not installed';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get rerunSetup => 'Re-run setup';

  @override
  String get rerunSubtitle => 'Reinstall or repair the environment';

  @override
  String get about => 'About';

  @override
  String aiGatewayVersion(String version) {
    return 'AI Gateway for Android\nVersion $version';
  }

  @override
  String get developer => 'Developer';

  @override
  String get license => 'License';

  @override
  String get contact => 'Contact';

  @override
  String get github => 'GitHub';

  @override
  String get instagram => 'Instagram';

  @override
  String get youtube => 'YouTube';

  @override
  String get playStore => 'Play Store';

  @override
  String get email => 'Email';

  @override
  String get startGateway => 'Start Gateway';

  @override
  String get stopGateway => 'Stop Gateway';

  @override
  String get viewLogs => 'View Logs';

  @override
  String get urlCopied => 'URL copied to clipboard';

  @override
  String gatewayRunning(String port) {
    return 'Running on port $port';
  }

  @override
  String get gatewayStopped => 'Gateway is stopped';

  @override
  String get gatewayStarting => 'Starting...';

  @override
  String get gatewayError => 'Error';
}
