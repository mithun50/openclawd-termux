import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../services/native_bridge.dart';
import '../services/preferences_service.dart';
import 'setup_wizard_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _prefs = PreferencesService();
  bool _autoStart = false;
  bool _batteryOptimized = true;
  String _arch = '';
  String _prootPath = '';
  Map<String, dynamic> _status = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _prefs.init();

    try {
      final arch = await NativeBridge.getArch();
      final prootPath = await NativeBridge.getProotPath();
      final status = await NativeBridge.getBootstrapStatus();
      final batteryOptimized = await NativeBridge.isBatteryOptimized();

      setState(() {
        _autoStart = _prefs.autoStartGateway;
        _batteryOptimized = batteryOptimized;
        _arch = arch;
        _prootPath = prootPath;
        _status = status;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _sectionHeader(theme, l10n.general),
                SwitchListTile(
                  title: Text(l10n.autoStartGateway),
                  subtitle: Text(l10n.autoStartSubtitle),
                  value: _autoStart,
                  onChanged: (value) {
                    setState(() => _autoStart = value);
                    _prefs.autoStartGateway = value;
                  },
                ),
                ListTile(
                  title: Text(l10n.batteryOptimization),
                  subtitle: Text(_batteryOptimized
                      ? l10n.batteryOptimized
                      : l10n.batteryUnrestricted),
                  leading: const Icon(Icons.battery_alert),
                  trailing: _batteryOptimized
                      ? const Icon(Icons.warning, color: Colors.orange)
                      : const Icon(Icons.check_circle, color: Colors.green),
                  onTap: () async {
                    await NativeBridge.requestBatteryOptimization();
                    // Refresh status after returning from settings
                    final optimized = await NativeBridge.isBatteryOptimized();
                    setState(() => _batteryOptimized = optimized);
                  },
                ),
                const Divider(),
                _sectionHeader(theme, l10n.systemInfo),
                ListTile(
                  title: Text(l10n.architecture),
                  subtitle: Text(_arch),
                  leading: const Icon(Icons.memory),
                ),
                ListTile(
                  title: Text(l10n.prootPath),
                  subtitle: Text(_prootPath),
                  leading: const Icon(Icons.folder),
                ),
                ListTile(
                  title: Text(l10n.rootfs),
                  subtitle: Text(_status['rootfsExists'] == true
                      ? l10n.installed
                      : l10n.notInstalled),
                  leading: const Icon(Icons.storage),
                ),
                ListTile(
                  title: Text(l10n.nodeJs),
                  subtitle: Text(_status['nodeInstalled'] == true
                      ? l10n.installed
                      : l10n.notInstalled),
                  leading: const Icon(Icons.code),
                ),
                ListTile(
                  title: Text(l10n.openClaw),
                  subtitle: Text(_status['openclawInstalled'] == true
                      ? l10n.installed
                      : l10n.notInstalled),
                  leading: const Icon(Icons.cloud),
                ),
                const Divider(),
                _sectionHeader(theme, l10n.maintenance),
                ListTile(
                  title: Text(l10n.rerunSetup),
                  subtitle: Text(l10n.rerunSubtitle),
                  leading: const Icon(Icons.build),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const SetupWizardScreen(),
                    ),
                  ),
                ),
                const Divider(),
                _sectionHeader(theme, l10n.about),
                ListTile(
                  title: Text(l10n.openClaw),
                  subtitle: Text(
                    l10n.aiGatewayVersion(AppConstants.version),
                  ),
                  leading: const Icon(Icons.info_outline),
                  isThreeLine: true,
                ),
                ListTile(
                  title: Text(l10n.developer),
                  subtitle: const Text(AppConstants.authorName),
                  leading: const Icon(Icons.person),
                ),
                ListTile(
                  title: Text(l10n.github),
                  subtitle: const Text('mithun50/openclawd-termux'),
                  leading: const Icon(Icons.code),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => launchUrl(
                    Uri.parse(AppConstants.githubUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                ListTile(
                  title: Text(l10n.contact),
                  subtitle: const Text(AppConstants.authorEmail),
                  leading: const Icon(Icons.email),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => launchUrl(
                    Uri.parse('mailto:${AppConstants.authorEmail}'),
                  ),
                ),
                ListTile(
                  title: Text(l10n.license),
                  subtitle: const Text(AppConstants.license),
                  leading: const Icon(Icons.description),
                ),
                const Divider(),
                _sectionHeader(theme, AppConstants.orgName),
                ListTile(
                  title: Text(l10n.instagram),
                  subtitle: const Text('@nexgenxplorer_nxg'),
                  leading: const Icon(Icons.camera_alt),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => launchUrl(
                    Uri.parse(AppConstants.instagramUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                ListTile(
                  title: Text(l10n.youtube),
                  subtitle: const Text('@nexgenxplorer'),
                  leading: const Icon(Icons.play_circle_fill),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => launchUrl(
                    Uri.parse(AppConstants.youtubeUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                ListTile(
                  title: Text(l10n.playStore),
                  subtitle: const Text('NextGenX Apps'),
                  leading: const Icon(Icons.shop),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => launchUrl(
                    Uri.parse(AppConstants.playStoreUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                ListTile(
                  title: Text(l10n.email),
                  subtitle: const Text(AppConstants.orgEmail),
                  leading: const Icon(Icons.email_outlined),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => launchUrl(
                    Uri.parse('mailto:${AppConstants.orgEmail}'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
