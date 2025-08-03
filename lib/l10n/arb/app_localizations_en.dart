// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get shared_ok => 'OK';

  @override
  String get shared_cancel => 'Cancel';

  @override
  String get shared_error_generic =>
      'An unexpected error occurred. Please try again.';

  @override
  String get shared_loading => 'Loading...';

  @override
  String get shared_retry => 'Retry';
}
