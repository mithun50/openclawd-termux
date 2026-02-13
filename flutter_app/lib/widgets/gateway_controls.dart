import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/gateway_state.dart';
import '../providers/gateway_provider.dart';
import '../screens/logs_screen.dart';

class GatewayControls extends StatelessWidget {
  const GatewayControls({super.key});

  String _getStatusText(GatewayStatus status, AppLocalizations l10n) {
    switch (status) {
      case GatewayStatus.stopped:
        return l10n.gatewayStopped;
      case GatewayStatus.starting:
        return l10n.gatewayStarting;
      case GatewayStatus.running:
        return l10n.gatewayRunning(AppConstants.gatewayPort.toString());
      case GatewayStatus.error:
        return l10n.gatewayError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Consumer<GatewayProvider>(
      builder: (context, provider, _) {
        final state = provider.state;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _statusDot(state.status),
                    const SizedBox(width: 12),
                    Text(
                      _getStatusText(state.status, l10n),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (state.isRunning) ...[
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          state.dashboardUrl ?? AppConstants.gatewayUrl,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        tooltip: l10n.copy,
                        onPressed: () {
                          final url = state.dashboardUrl ?? AppConstants.gatewayUrl;
                          Clipboard.setData(ClipboardData(text: url));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.urlCopied),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
                if (state.errorMessage != null)
                  Text(
                    state.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (state.isStopped || state.status == GatewayStatus.error)
                      FilledButton.icon(
                        onPressed: () => provider.start(),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l10n.startGateway),
                      ),
                    if (state.isRunning || state.status == GatewayStatus.starting)
                      FilledButton.icon(
                        onPressed: () => provider.stop(),
                        icon: const Icon(Icons.stop),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                        ),
                        label: Text(l10n.stopGateway),
                      ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LogsScreen()),
                      ),
                      icon: const Icon(Icons.article_outlined),
                      label: Text(l10n.viewLogs),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusDot(GatewayStatus status) {
    Color color;
    switch (status) {
      case GatewayStatus.running:
        color = Colors.green;
      case GatewayStatus.starting:
        color = Colors.orange;
      case GatewayStatus.error:
        color = Colors.red;
      case GatewayStatus.stopped:
        color = Colors.grey;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          if (status == GatewayStatus.running)
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
      ),
    );
  }
}
