import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werewolf_app/view/pages/setup_names_page.dart';

late final SharedPreferences prefs;
final ValueNotifier<int?> seedColor = ValueNotifier(null);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  seedColor.value = prefs.getInt('seedColor');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('de'),
      child: const WerewolfApp(),
    ),
  );
}

class WerewolfApp extends StatelessWidget {
  const WerewolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: seedColor,
      builder: (context, colorValue, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ColorScheme lightColorScheme =
                (lightDynamic != null && colorValue == null)
                ? lightDynamic
                : ColorScheme.fromSeed(
                    seedColor: colorValue != null
                        ? Color(colorValue)
                        : Colors.blue,
                    brightness: Brightness.light,
                  );
            ColorScheme darkColorScheme =
                (darkDynamic != null && colorValue == null)
                ? darkDynamic
                : ColorScheme.fromSeed(
                    seedColor: colorValue != null
                        ? Color(colorValue)
                        : Colors.blue,
                    brightness: Brightness.dark,
                  );

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Werewolf',
              themeMode: ThemeMode.system,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                scaffoldBackgroundColor: lightColorScheme.surface,
                fontFamily: 'Baloo2',
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                scaffoldBackgroundColor: darkColorScheme.surface,
                fontFamily: 'Baloo2',
              ),
              home: const SetupNamesPage(),
            );
          },
        );
      },
    );
  }
}
