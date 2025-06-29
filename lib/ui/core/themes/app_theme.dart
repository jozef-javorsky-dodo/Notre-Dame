// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:notredame/ui/core/themes/app_colors_extension.dart';
import 'package:notredame/ui/core/themes/app_palette.dart';

class AppTheme with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  static final light = () {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      appBarTheme: AppBarTheme(color: _lightAppColors.appBar),
      tabBarTheme: TabBarThemeData(labelColor: AppPalette.grey.white),
      scaffoldBackgroundColor: const Color(0xffeeebeb),
      cardTheme: defaultTheme.cardTheme.copyWith(
        color: Color(0xfff8f8f8),
        surfaceTintColor: Color(0xffffe6e6),
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xfffffdfd),
        labelStyle: TextStyle(color: AppPalette.grey.black),
      ),
      bottomNavigationBarTheme: defaultTheme.bottomNavigationBarTheme.copyWith(
        selectedItemColor: AppPalette.etsLightRed,
        backgroundColor: _lightAppColors.navBar,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: _lightAppColors.navBar,
        groupAlignment: 0,
        indicatorColor: Colors.transparent,
        selectedLabelTextStyle: TextStyle(color: AppPalette.etsLightRed),
        selectedIconTheme: IconThemeData(color: AppPalette.etsLightRed),
      ),
      colorScheme: defaultTheme.colorScheme.copyWith(
        primary: AppPalette.etsLightRed,
        secondary: AppPalette.etsLightRed,
        surface: const Color(0xfff8e9e9),
        surfaceTint: const Color(0xfff6ebeb),
      ),
      extensions: [_lightAppColors],
    );
  }();

  static final _lightAppColors = AppColorsExtension(
    appBar: const Color(0xfff8f8f8),
    navBar: const Color(0xfffffdfd),
    backgroundAlt: const Color(0xffefefef),
    backgroundVibrant: AppPalette.etsLightRed,
    scheduleLine: const Color(0xffd9d8d8),
    tabBarLabel: Colors.black,
    tabBarIndicator: Colors.black26,
    shimmerHighlight: const Color.fromARGB(255, 228, 225, 225),
    vibrantAppBar: AppPalette.etsLightRed,
    newsAccent: const Color(0xff007c6f),
    newsBackgroundVibrant: AppPalette.etsLightRed,
    newsAuthorProfile: const Color.fromARGB(255, 237, 237, 237),
    newsAuthorProfileDescription: AppPalette.grey.darkGrey,
    modalTitle: const Color(0xffe8e5e5),
    modalHandle: const Color(0xff868383),
    fadedText: const Color(0xff424242),
    fadedInvertText: const Color(0xffefefef),
    positive: const Color(0xff5fc263),
    positiveText: const Color(0xff11a616),
    negative: const Color(0xffff9393),
    negativeText: const Color(0xffe33e3e),
    link: const Color(0xff2a81bd),
    outageGif: AppPalette.grey.white,
    dayIndicatorWeekView: const Color(0x83ef3e45),
    dayIndicatorDayView: AppPalette.grey.lightGrey,
    loginMain: AppPalette.etsLightRed,
    loginAccent: AppPalette.grey.white,
    inputError: Colors.amberAccent,
  );

  static final dark = () {
    final defaultTheme = ThemeData.dark();

    return defaultTheme.copyWith(
      appBarTheme: AppBarTheme(color: _darkAppColors.appBar),
      tabBarTheme: TabBarThemeData(labelColor: AppPalette.grey.white),
      scaffoldBackgroundColor: const Color(0xff121212),
      cardTheme: defaultTheme.cardTheme.copyWith(color: Color(0xff242326)),
      bottomNavigationBarTheme: defaultTheme.bottomNavigationBarTheme.copyWith(
        selectedItemColor: AppPalette.etsLightRed,
        backgroundColor: _darkAppColors.navBar,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: _darkAppColors.navBar,
        groupAlignment: 0,
        indicatorColor: Colors.transparent,
        selectedLabelTextStyle: TextStyle(color: AppPalette.etsLightRed),
        selectedIconTheme: IconThemeData(color: AppPalette.etsLightRed),
      ),
      colorScheme: defaultTheme.colorScheme.copyWith(
        primary: AppPalette.etsLightRed,
        secondary: AppPalette.etsLightRed,
        surface: const Color(0xff1e1e1e),
        surfaceTint: const Color(0xff1e1e1e),
      ),
      extensions: [_darkAppColors],
    );
  }();

  static final _darkAppColors = AppColorsExtension(
    appBar: const Color(0xff16171a),
    navBar: const Color(0xff1c1d21),
    backgroundAlt: const Color(0xff2c2c2c),
    backgroundVibrant: const Color(0xff121212),
    scheduleLine: const Color(0xff2c2929),
    tabBarLabel: AppPalette.grey.white,
    tabBarIndicator: AppPalette.grey.white,
    shimmerHighlight: const Color(0xff424242),
    vibrantAppBar: const Color(0xff16171a),
    newsAccent: const Color(0xff00cdb7),
    newsBackgroundVibrant: const Color.fromARGB(255, 35, 32, 32),
    newsAuthorProfile: const Color.fromARGB(255, 31, 33, 32),
    newsAuthorProfileDescription: const Color.fromARGB(255, 237, 237, 237),
    modalTitle: const Color(0xff232222),
    modalHandle: const Color(0xffb9b8b8),
    fadedText: const Color(0xffbebbbb),
    fadedInvertText: const Color(0xffaba8a8),
    positive: const Color(0xff468f48),
    positiveText: const Color(0xff8dee8f),
    negative: const Color(0xff982a20),
    negativeText: const Color(0xfff35948),
    link: const Color(0xff5eb1f8),
    outageGif: AppPalette.etsLightRed,
    dayIndicatorWeekView: const Color(0x96ef3e45),
    dayIndicatorDayView: AppPalette.grey.darkGrey,
    loginMain: AppPalette.grey.white,
    loginAccent: AppPalette.etsLightRed,
    inputError: Colors.redAccent,
  );
}

extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors => extension<AppColorsExtension>() ?? AppTheme._lightAppColors;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
