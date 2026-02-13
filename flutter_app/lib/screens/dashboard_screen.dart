import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/gateway_provider.dart';
import '../widgets/gateway_controls.dart';
import '../widgets/status_card.dart';
import 'onboarding_screen.dart';
import 'terminal_screen.dart';
import 'web_dashboard_screen.dart';
import 'logs_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GatewayControls(),
            const SizedBox(height: 16),
            Text(
              l10n.quickActions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            StatusCard(
              title: l10n.terminal,
              subtitle: l10n.terminalSubtitle,
              icon: Icons.terminal,
              color: Colors.blueGrey,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TerminalScreen()),
              ),
            ),
            Consumer<GatewayProvider>(
              builder: (context, provider, _) {
                return StatusCard(
                  title: l10n.webDashboard,
                  subtitle: provider.state.isRunning
                      ? l10n.webDashboardSubtitleRunning
                      : l10n.startGatewayFirst,
                  icon: Icons.dashboard,
                  color: Colors.indigo,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: provider.state.isRunning
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WebDashboardScreen(
                                url: provider.state.dashboardUrl,
                              ),
                            ),
                          )
                      : null,
                );
              },
            ),
            StatusCard(
              title: l10n.onboarding,
              subtitle: l10n.onboardingSubtitle,
              icon: Icons.vpn_key,
              color: Colors.deepPurple,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              ),
            ),
            StatusCard(
              title: l10n.logs,
              subtitle: l10n.logsSubtitle,
              icon: Icons.article_outlined,
              color: Colors.teal,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LogsScreen()),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    l10n.versionLabel(AppConstants.version),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.byLine(AppConstants.authorName, AppConstants.orgName),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
