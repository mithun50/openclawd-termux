// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'OpenClaw';

  @override
  String get aiGateway => 'Passerelle IA pour Android';

  @override
  String get loading => 'Chargement...';

  @override
  String get checkingSetup => 'Vérification de l\'état de la configuration...';

  @override
  String get setupTitle => 'Configurer OpenClaw';

  @override
  String get setupDescription =>
      'Cela téléchargera Ubuntu, Node.js et OpenClaw dans un environnement autonome.';

  @override
  String get settingUpEnvironment =>
      'Configuration de l\'environnement. Cela peut prendre plusieurs minutes.';

  @override
  String get beginSetup => 'Commencer la configuration';

  @override
  String get retrySetup => 'Réessayer la configuration';

  @override
  String get configureApiKeys => 'Configurer les clés API';

  @override
  String get storageRequirement =>
      'Nécessite ~500 Mo de stockage et une connexion Internet';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get stepDownloadRootfs => 'Télécharger Ubuntu rootfs';

  @override
  String get stepExtractRootfs => 'Extraire rootfs';

  @override
  String get stepInstallNode => 'Installer Node.js';

  @override
  String get stepInstallOpenClaw => 'Installer OpenClaw';

  @override
  String get stepConfigureBypass => 'Configurer Bionic Bypass';

  @override
  String get setupComplete => 'Configuration terminée !';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get terminal => 'Terminal';

  @override
  String get terminalSubtitle => 'Ouvrir le shell Ubuntu avec OpenClaw';

  @override
  String get webDashboard => 'Tableau de bord web';

  @override
  String get webDashboardSubtitleRunning =>
      'Ouvrir le tableau de bord OpenClaw dans le navigateur';

  @override
  String get startGatewayFirst => 'Démarrez d\'abord la passerelle';

  @override
  String get onboarding => 'Intégration';

  @override
  String get onboardingSubtitle => 'Configurer les clés API et la liaison';

  @override
  String get logs => 'Journaux';

  @override
  String get logsSubtitle => 'Voir la sortie et les erreurs de la passerelle';

  @override
  String versionLabel(String version) {
    return 'OpenClaw v$version';
  }

  @override
  String byLine(String author, String org) {
    return 'par $author | $org';
  }

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get startingTerminal => 'Démarrage du terminal...';

  @override
  String failedToStartTerminal(String error) {
    return 'Échec du démarrage du terminal : $error';
  }

  @override
  String get openLink => 'Ouvrir le lien';

  @override
  String get cancel => 'Annuler';

  @override
  String get copy => 'Copier';

  @override
  String get open => 'Ouvrir';

  @override
  String get paste => 'Coller';

  @override
  String get restart => 'Redémarrer';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get linkCopied => 'Lien copié';

  @override
  String get noUrlFound => 'Aucune URL trouvée dans la sélection';

  @override
  String get copyTooltip => 'Copier';

  @override
  String get openUrlTooltip => 'Ouvrir l\'URL';

  @override
  String get pasteTooltip => 'Coller';

  @override
  String get restartTooltip => 'Redémarrer';

  @override
  String processExited(int code) {
    return 'Le processus s\'est terminé avec le code $code';
  }

  @override
  String get webDashboardTitle => 'Tableau de bord web';

  @override
  String failedToLoadDashboard(String error) {
    return 'Échec du chargement du tableau de bord : $error';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get gatewayLogs => 'Journaux de la passerelle';

  @override
  String get filterLogs => 'Filtrer les journaux...';

  @override
  String get copyAllLogs => 'Copier tous les journaux';

  @override
  String get autoScrollOn => 'Défilement auto activé';

  @override
  String get autoScrollOff => 'Défilement auto désactivé';

  @override
  String get noLogsYet => 'Aucun journal. Démarrez la passerelle.';

  @override
  String get noMatchingLogs => 'Aucun journal correspondant.';

  @override
  String get logsCopied => 'Journaux copiés dans le presse-papiers';

  @override
  String get onboardingTitle => 'Intégration OpenClaw';

  @override
  String get startingOnboarding => 'Démarrage de l\'intégration...';

  @override
  String get goToDashboard => 'Aller au tableau de bord';

  @override
  String get done => 'Terminé';

  @override
  String get onboardingError =>
      'L\'intégration a rencontré une erreur. Vérifiez la sortie du terminal ci-dessus.';

  @override
  String get settings => 'Paramètres';

  @override
  String get general => 'Général';

  @override
  String get autoStartGateway => 'Démarrage auto de la passerelle';

  @override
  String get autoStartSubtitle =>
      'Démarrer la passerelle à l\'ouverture de l\'application';

  @override
  String get batteryOptimization => 'Optimisation de la batterie';

  @override
  String get batteryOptimized =>
      'Optimisée (peut arrêter les sessions en arrière-plan)';

  @override
  String get batteryUnrestricted => 'Sans restriction (recommandé)';

  @override
  String get systemInfo => 'Infos système';

  @override
  String get architecture => 'Architecture';

  @override
  String get prootPath => 'Chemin PRoot';

  @override
  String get rootfs => 'Rootfs';

  @override
  String get nodeJs => 'Node.js';

  @override
  String get openClaw => 'OpenClaw';

  @override
  String get installed => 'Installé';

  @override
  String get notInstalled => 'Non installé';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get rerunSetup => 'Relancer la configuration';

  @override
  String get rerunSubtitle => 'Réinstaller ou réparer l\'environnement';

  @override
  String get about => 'À propos';

  @override
  String aiGatewayVersion(String version) {
    return 'Passerelle IA pour Android\nVersion $version';
  }

  @override
  String get developer => 'Développeur';

  @override
  String get license => 'Licence';

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
  String get email => 'E-mail';

  @override
  String get startGateway => 'Démarrer la passerelle';

  @override
  String get stopGateway => 'Arrêter la passerelle';

  @override
  String get viewLogs => 'Voir les journaux';

  @override
  String get urlCopied => 'URL copiée dans le presse-papiers';

  @override
  String gatewayRunning(String port) {
    return 'En cours d\'exécution sur le port $port';
  }

  @override
  String get gatewayStopped => 'Passerelle arrêtée';

  @override
  String get gatewayStarting => 'Démarrage...';

  @override
  String get gatewayError => 'Erreur';
}
