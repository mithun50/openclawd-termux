// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'OpenClaw';

  @override
  String get aiGateway => 'Android用AIゲートウェイ';

  @override
  String get loading => '読み込み中...';

  @override
  String get checkingSetup => 'セットアップ状態を確認中...';

  @override
  String get setupTitle => 'OpenClawをセットアップ';

  @override
  String get setupDescription => 'Ubuntu、Node.js、OpenClawを独立した環境にダウンロードします。';

  @override
  String get settingUpEnvironment => '環境をセットアップ中です。数分かかる場合があります。';

  @override
  String get beginSetup => 'セットアップを開始';

  @override
  String get retrySetup => 'セットアップを再試行';

  @override
  String get configureApiKeys => 'APIキーを設定';

  @override
  String get storageRequirement => '約500MBのストレージとインターネット接続が必要です';

  @override
  String get unknownError => '不明なエラー';

  @override
  String get stepDownloadRootfs => 'Ubuntu rootfsをダウンロード';

  @override
  String get stepExtractRootfs => 'rootfsを展開';

  @override
  String get stepInstallNode => 'Node.jsをインストール';

  @override
  String get stepInstallOpenClaw => 'OpenClawをインストール';

  @override
  String get stepConfigureBypass => 'Bionic Bypassを設定';

  @override
  String get setupComplete => 'セットアップ完了！';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get terminal => 'ターミナル';

  @override
  String get terminalSubtitle => 'OpenClaw付きUbuntuシェルを開く';

  @override
  String get webDashboard => 'Webダッシュボード';

  @override
  String get webDashboardSubtitleRunning => 'ブラウザでOpenClawダッシュボードを開く';

  @override
  String get startGatewayFirst => '先にゲートウェイを起動してください';

  @override
  String get onboarding => 'オンボーディング';

  @override
  String get onboardingSubtitle => 'APIキーとバインディングを設定';

  @override
  String get logs => 'ログ';

  @override
  String get logsSubtitle => 'ゲートウェイの出力とエラーを表示';

  @override
  String versionLabel(String version) {
    return 'OpenClaw v$version';
  }

  @override
  String byLine(String author, String org) {
    return '$author | $org';
  }

  @override
  String get terminalTitle => 'ターミナル';

  @override
  String get startingTerminal => 'ターミナルを起動中...';

  @override
  String failedToStartTerminal(String error) {
    return 'ターミナルの起動に失敗: $error';
  }

  @override
  String get openLink => 'リンクを開く';

  @override
  String get cancel => 'キャンセル';

  @override
  String get copy => 'コピー';

  @override
  String get open => '開く';

  @override
  String get paste => '貼り付け';

  @override
  String get restart => '再起動';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get linkCopied => 'リンクをコピーしました';

  @override
  String get noUrlFound => '選択範囲にURLが見つかりません';

  @override
  String get copyTooltip => 'コピー';

  @override
  String get openUrlTooltip => 'URLを開く';

  @override
  String get pasteTooltip => '貼り付け';

  @override
  String get restartTooltip => '再起動';

  @override
  String processExited(int code) {
    return 'プロセスがコード$codeで終了しました';
  }

  @override
  String get webDashboardTitle => 'Webダッシュボード';

  @override
  String failedToLoadDashboard(String error) {
    return 'ダッシュボードの読み込みに失敗: $error';
  }

  @override
  String get retry => '再試行';

  @override
  String get gatewayLogs => 'ゲートウェイログ';

  @override
  String get filterLogs => 'ログをフィルター...';

  @override
  String get copyAllLogs => 'すべてのログをコピー';

  @override
  String get autoScrollOn => '自動スクロール オン';

  @override
  String get autoScrollOff => '自動スクロール オフ';

  @override
  String get noLogsYet => 'ログがありません。ゲートウェイを起動してください。';

  @override
  String get noMatchingLogs => '一致するログがありません。';

  @override
  String get logsCopied => 'ログをクリップボードにコピーしました';

  @override
  String get onboardingTitle => 'OpenClaw オンボーディング';

  @override
  String get startingOnboarding => 'オンボーディングを開始中...';

  @override
  String get goToDashboard => 'ダッシュボードへ';

  @override
  String get done => '完了';

  @override
  String get onboardingError => 'オンボーディングでエラーが発生しました。上のターミナル出力を確認してください。';

  @override
  String get settings => '設定';

  @override
  String get general => '一般';

  @override
  String get autoStartGateway => 'ゲートウェイ自動起動';

  @override
  String get autoStartSubtitle => 'アプリ起動時にゲートウェイを開始';

  @override
  String get batteryOptimization => 'バッテリー最適化';

  @override
  String get batteryOptimized => '最適化済み（バックグラウンドセッションが終了する可能性）';

  @override
  String get batteryUnrestricted => '制限なし（推奨）';

  @override
  String get systemInfo => 'システム情報';

  @override
  String get architecture => 'アーキテクチャ';

  @override
  String get prootPath => 'PRootパス';

  @override
  String get rootfs => 'Rootfs';

  @override
  String get nodeJs => 'Node.js';

  @override
  String get openClaw => 'OpenClaw';

  @override
  String get installed => 'インストール済み';

  @override
  String get notInstalled => '未インストール';

  @override
  String get maintenance => 'メンテナンス';

  @override
  String get rerunSetup => 'セットアップを再実行';

  @override
  String get rerunSubtitle => '環境を再インストールまたは修復';

  @override
  String get about => 'アプリについて';

  @override
  String aiGatewayVersion(String version) {
    return 'Android用AIゲートウェイ\nバージョン $version';
  }

  @override
  String get developer => '開発者';

  @override
  String get license => 'ライセンス';

  @override
  String get contact => '連絡先';

  @override
  String get github => 'GitHub';

  @override
  String get instagram => 'Instagram';

  @override
  String get youtube => 'YouTube';

  @override
  String get playStore => 'Play Store';

  @override
  String get email => 'メール';

  @override
  String get startGateway => 'ゲートウェイを起動';

  @override
  String get stopGateway => 'ゲートウェイを停止';

  @override
  String get viewLogs => 'ログを表示';

  @override
  String get urlCopied => 'URLをクリップボードにコピーしました';

  @override
  String gatewayRunning(String port) {
    return 'ポート$portで実行中';
  }

  @override
  String get gatewayStopped => 'ゲートウェイは停止中';

  @override
  String get gatewayStarting => '起動中...';

  @override
  String get gatewayError => 'エラー';
}
