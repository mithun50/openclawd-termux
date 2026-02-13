// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'OpenClaw';

  @override
  String get aiGateway => 'Puerta de enlace IA para Android';

  @override
  String get loading => 'Cargando...';

  @override
  String get checkingSetup => 'Verificando estado de configuración...';

  @override
  String get setupTitle => 'Configurar OpenClaw';

  @override
  String get setupDescription =>
      'Esto descargará Ubuntu, Node.js y OpenClaw en un entorno independiente.';

  @override
  String get settingUpEnvironment =>
      'Configurando el entorno. Esto puede tardar varios minutos.';

  @override
  String get beginSetup => 'Iniciar configuración';

  @override
  String get retrySetup => 'Reintentar configuración';

  @override
  String get configureApiKeys => 'Configurar claves API';

  @override
  String get storageRequirement =>
      'Requiere ~500MB de almacenamiento y conexión a internet';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get stepDownloadRootfs => 'Descargar Ubuntu rootfs';

  @override
  String get stepExtractRootfs => 'Extraer rootfs';

  @override
  String get stepInstallNode => 'Instalar Node.js';

  @override
  String get stepInstallOpenClaw => 'Instalar OpenClaw';

  @override
  String get stepConfigureBypass => 'Configurar Bionic Bypass';

  @override
  String get setupComplete => '¡Configuración completa!';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get terminal => 'Terminal';

  @override
  String get terminalSubtitle => 'Abrir shell Ubuntu con OpenClaw';

  @override
  String get webDashboard => 'Panel web';

  @override
  String get webDashboardSubtitleRunning =>
      'Abrir panel de OpenClaw en el navegador';

  @override
  String get startGatewayFirst => 'Inicie la puerta de enlace primero';

  @override
  String get onboarding => 'Incorporación';

  @override
  String get onboardingSubtitle => 'Configurar claves API y vinculación';

  @override
  String get logs => 'Registros';

  @override
  String get logsSubtitle => 'Ver salida y errores de la puerta de enlace';

  @override
  String versionLabel(String version) {
    return 'OpenClaw v$version';
  }

  @override
  String byLine(String author, String org) {
    return 'por $author | $org';
  }

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get startingTerminal => 'Iniciando terminal...';

  @override
  String failedToStartTerminal(String error) {
    return 'Error al iniciar terminal: $error';
  }

  @override
  String get openLink => 'Abrir enlace';

  @override
  String get cancel => 'Cancelar';

  @override
  String get copy => 'Copiar';

  @override
  String get open => 'Abrir';

  @override
  String get paste => 'Pegar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String get noUrlFound => 'No se encontró URL en la selección';

  @override
  String get copyTooltip => 'Copiar';

  @override
  String get openUrlTooltip => 'Abrir URL';

  @override
  String get pasteTooltip => 'Pegar';

  @override
  String get restartTooltip => 'Reiniciar';

  @override
  String processExited(int code) {
    return 'El proceso finalizó con código $code';
  }

  @override
  String get webDashboardTitle => 'Panel web';

  @override
  String failedToLoadDashboard(String error) {
    return 'Error al cargar el panel: $error';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get gatewayLogs => 'Registros de puerta de enlace';

  @override
  String get filterLogs => 'Filtrar registros...';

  @override
  String get copyAllLogs => 'Copiar todos los registros';

  @override
  String get autoScrollOn => 'Auto-desplazamiento activado';

  @override
  String get autoScrollOff => 'Auto-desplazamiento desactivado';

  @override
  String get noLogsYet => 'Sin registros aún. Inicie la puerta de enlace.';

  @override
  String get noMatchingLogs => 'No hay registros coincidentes.';

  @override
  String get logsCopied => 'Registros copiados al portapapeles';

  @override
  String get onboardingTitle => 'Incorporación de OpenClaw';

  @override
  String get startingOnboarding => 'Iniciando incorporación...';

  @override
  String get goToDashboard => 'Ir al panel';

  @override
  String get done => 'Listo';

  @override
  String get onboardingError =>
      'La incorporación encontró un error. Verifique la salida del terminal arriba.';

  @override
  String get settings => 'Ajustes';

  @override
  String get general => 'General';

  @override
  String get autoStartGateway => 'Inicio automático de puerta de enlace';

  @override
  String get autoStartSubtitle =>
      'Iniciar la puerta de enlace al abrir la aplicación';

  @override
  String get batteryOptimization => 'Optimización de batería';

  @override
  String get batteryOptimized =>
      'Optimizada (puede cerrar sesiones en segundo plano)';

  @override
  String get batteryUnrestricted => 'Sin restricciones (recomendado)';

  @override
  String get systemInfo => 'Información del sistema';

  @override
  String get architecture => 'Arquitectura';

  @override
  String get prootPath => 'Ruta PRoot';

  @override
  String get rootfs => 'Rootfs';

  @override
  String get nodeJs => 'Node.js';

  @override
  String get openClaw => 'OpenClaw';

  @override
  String get installed => 'Instalado';

  @override
  String get notInstalled => 'No instalado';

  @override
  String get maintenance => 'Mantenimiento';

  @override
  String get rerunSetup => 'Ejecutar configuración de nuevo';

  @override
  String get rerunSubtitle => 'Reinstalar o reparar el entorno';

  @override
  String get about => 'Acerca de';

  @override
  String aiGatewayVersion(String version) {
    return 'Puerta de enlace IA para Android\nVersión $version';
  }

  @override
  String get developer => 'Desarrollador';

  @override
  String get license => 'Licencia';

  @override
  String get contact => 'Contacto';

  @override
  String get github => 'GitHub';

  @override
  String get instagram => 'Instagram';

  @override
  String get youtube => 'YouTube';

  @override
  String get playStore => 'Play Store';

  @override
  String get email => 'Correo electrónico';

  @override
  String get startGateway => 'Iniciar puerta de enlace';

  @override
  String get stopGateway => 'Detener puerta de enlace';

  @override
  String get viewLogs => 'Ver registros';

  @override
  String get urlCopied => 'URL copiada al portapapeles';

  @override
  String gatewayRunning(String port) {
    return 'Ejecutándose en el puerto $port';
  }

  @override
  String get gatewayStopped => 'Puerta de enlace detenida';

  @override
  String get gatewayStarting => 'Iniciando...';

  @override
  String get gatewayError => 'Error';
}
