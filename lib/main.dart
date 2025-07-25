import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:werewolf_app/view/pages/create_game_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemTheme.accentColor.load();
  SystemTheme.fallbackColor = Colors.blue;

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('de')],
        path: 'assets/translations',
        fallbackLocale: const Locale('de'),
        child: const WerewolfApp()),
  );
}

class WerewolfApp extends StatelessWidget {
  const WerewolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'app_name'.tr(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: SystemTheme.accentColor.accent,
            brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: SystemTheme.accentColor.accent,
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const CreateGamePage(),
    );
  }
}

