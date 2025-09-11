import 'package:flutter/material.dart';

import 'supa_extended_color_token_group.dart';

const String _default = 'default';
const String _warning = 'warning';
const String _information = 'information';
const String _success = 'success';
const String _error = 'error';
const String _blueTag = 'blue';
const String _cyanTag = 'cyan';
const String _geekblueTag = 'geekblue';
const String _goldTag = 'gold';
const String _greenTag = 'green';
const String _limeTag = 'lime';
const String _magentaTag = 'magenta';
const String _orangeTag = 'orange';
const String _purpleTag = 'purple';
const String _redTag = 'red';
const String _volcanoTag = 'volcano';

const String _processing = 'processing';
const String _critical = 'critical';

class SupaExtendedColorScheme extends ThemeExtension<SupaExtendedColorScheme> {
  // Warning colors
  final Color warningText;
  final Color warningBackground;
  final Color warningBorder;

  // Information colors
  final Color informationText;
  final Color informationBackground;
  final Color informationBorder;

  // Success colors
  final Color successText;
  final Color successBackground;
  final Color successBorder;

  // Default colors
  final Color defaultText;
  final Color defaultBackground;
  final Color defaultBorder;

  // Error colors
  final Color errorText;
  final Color errorBackground;
  final Color errorBorder;

  // Blue tag colors
  final Color blueTagText;
  final Color blueTagBackground;
  final Color blueTagBorder;

  // Cyan tag colors
  final Color cyanTagText;
  final Color cyanTagBackground;
  final Color cyanTagBorder;

  // Geek blue tag colors
  final Color geekblueTagText;
  final Color geekblueTagBackground;
  final Color geekblueTagBorder;

  // Gold tag colors
  final Color goldTagText;
  final Color goldTagBackground;
  final Color goldTagBorder;

  // Green tag colors
  final Color greenTagText;
  final Color greenTagBackground;
  final Color greenTagBorder;

  // Lime tag colors
  final Color limeTagText;
  final Color limeTagBackground;
  final Color limeTagBorder;

  // Magenta tag colors
  final Color magentaTagText;
  final Color magentaTagBackground;
  final Color magentaTagBorder;

  // Orange tag colors
  final Color orangeTagText;
  final Color orangeTagBackground;
  final Color orangeTagBorder;

  // Purple tag colors
  final Color purpleTagText;
  final Color purpleTagBackground;
  final Color purpleTagBorder;

  // Red tag colors
  final Color redTagText;
  final Color redTagBackground;
  final Color redTagBorder;

  // Volcano tag colors
  final Color volcanoTagText;
  final Color volcanoTagBackground;
  final Color volcanoTagBorder;

  const SupaExtendedColorScheme({
    required this.warningText,
    required this.warningBackground,
    required this.warningBorder,
    required this.informationText,
    required this.informationBackground,
    required this.informationBorder,
    required this.successText,
    required this.successBackground,
    required this.successBorder,
    required this.defaultText,
    required this.defaultBackground,
    required this.defaultBorder,
    required this.errorText,
    required this.errorBackground,
    required this.errorBorder,
    required this.blueTagText,
    required this.blueTagBackground,
    required this.blueTagBorder,
    required this.cyanTagText,
    required this.cyanTagBackground,
    required this.cyanTagBorder,
    required this.geekblueTagText,
    required this.geekblueTagBackground,
    required this.geekblueTagBorder,
    required this.goldTagText,
    required this.goldTagBackground,
    required this.goldTagBorder,
    required this.greenTagText,
    required this.greenTagBackground,
    required this.greenTagBorder,
    required this.limeTagText,
    required this.limeTagBackground,
    required this.limeTagBorder,
    required this.magentaTagText,
    required this.magentaTagBackground,
    required this.magentaTagBorder,
    required this.orangeTagText,
    required this.orangeTagBackground,
    required this.orangeTagBorder,
    required this.purpleTagText,
    required this.purpleTagBackground,
    required this.purpleTagBorder,
    required this.redTagText,
    required this.redTagBackground,
    required this.redTagBorder,
    required this.volcanoTagText,
    required this.volcanoTagBackground,
    required this.volcanoTagBorder,
  });

  @override
  ThemeExtension<SupaExtendedColorScheme> copyWith({
    Color? warningText,
    Color? warningBackground,
    Color? warningBorder,
    Color? informationText,
    Color? informationBackground,
    Color? informationBorder,
    Color? successText,
    Color? successBackground,
    Color? successBorder,
    Color? defaultText,
    Color? defaultBackground,
    Color? defaultBorder,
    Color? errorText,
    Color? errorBackground,
    Color? errorBorder,
    Color? blueTagText,
    Color? blueTagBackground,
    Color? blueTagBorder,
    Color? cyanTagText,
    Color? cyanTagBackground,
    Color? cyanTagBorder,
    Color? geekblueTagText,
    Color? geekblueTagBackground,
    Color? geekblueTagBorder,
    Color? goldTagText,
    Color? goldTagBackground,
    Color? goldTagBorder,
    Color? greenTagText,
    Color? greenTagBackground,
    Color? greenTagBorder,
    Color? limeTagText,
    Color? limeTagBackground,
    Color? limeTagBorder,
    Color? magentaTagText,
    Color? magentaTagBackground,
    Color? magentaTagBorder,
    Color? orangeTagText,
    Color? orangeTagBackground,
    Color? orangeTagBorder,
    Color? purpleTagText,
    Color? purpleTagBackground,
    Color? purpleTagBorder,
    Color? redTagText,
    Color? redTagBackground,
    Color? redTagBorder,
    Color? volcanoTagText,
    Color? volcanoTagBackground,
    Color? volcanoTagBorder,
  }) {
    return SupaExtendedColorScheme(
      warningText: warningText ?? this.warningText,
      warningBackground: warningBackground ?? this.warningBackground,
      warningBorder: warningBorder ?? this.warningBorder,
      informationText: informationText ?? this.informationText,
      informationBackground:
          informationBackground ?? this.informationBackground,
      informationBorder: informationBorder ?? this.informationBorder,
      successText: successText ?? this.successText,
      successBackground: successBackground ?? this.successBackground,
      successBorder: successBorder ?? this.successBorder,
      defaultText: defaultText ?? this.defaultText,
      defaultBackground: defaultBackground ?? this.defaultBackground,
      defaultBorder: defaultBorder ?? this.defaultBorder,
      errorText: errorText ?? this.errorText,
      errorBackground: errorBackground ?? this.errorBackground,
      errorBorder: errorBorder ?? this.errorBorder,
      blueTagText: blueTagText ?? this.blueTagText,
      blueTagBackground: blueTagBackground ?? this.blueTagBackground,
      blueTagBorder: blueTagBorder ?? this.blueTagBorder,
      cyanTagText: cyanTagText ?? this.cyanTagText,
      cyanTagBackground: cyanTagBackground ?? this.cyanTagBackground,
      cyanTagBorder: cyanTagBorder ?? this.cyanTagBorder,
      geekblueTagText: geekblueTagText ?? this.geekblueTagText,
      geekblueTagBackground:
          geekblueTagBackground ?? this.geekblueTagBackground,
      geekblueTagBorder: geekblueTagBorder ?? this.geekblueTagBorder,
      goldTagText: goldTagText ?? this.goldTagText,
      goldTagBackground: goldTagBackground ?? this.goldTagBackground,
      goldTagBorder: goldTagBorder ?? this.goldTagBorder,
      greenTagText: greenTagText ?? this.greenTagText,
      greenTagBackground: greenTagBackground ?? this.greenTagBackground,
      greenTagBorder: greenTagBorder ?? this.greenTagBorder,
      limeTagText: limeTagText ?? this.limeTagText,
      limeTagBackground: limeTagBackground ?? this.limeTagBackground,
      limeTagBorder: limeTagBorder ?? this.limeTagBorder,
      magentaTagText: magentaTagText ?? this.magentaTagText,
      magentaTagBackground: magentaTagBackground ?? this.magentaTagBackground,
      magentaTagBorder: magentaTagBorder ?? this.magentaTagBorder,
      orangeTagText: orangeTagText ?? this.orangeTagText,
      orangeTagBackground: orangeTagBackground ?? this.orangeTagBackground,
      orangeTagBorder: orangeTagBorder ?? this.orangeTagBorder,
      purpleTagText: purpleTagText ?? this.purpleTagText,
      purpleTagBackground: purpleTagBackground ?? this.purpleTagBackground,
      purpleTagBorder: purpleTagBorder ?? this.purpleTagBorder,
      redTagText: redTagText ?? this.redTagText,
      redTagBackground: redTagBackground ?? this.redTagBackground,
      redTagBorder: redTagBorder ?? this.redTagBorder,
      volcanoTagText: volcanoTagText ?? this.volcanoTagText,
      volcanoTagBackground: volcanoTagBackground ?? this.volcanoTagBackground,
      volcanoTagBorder: volcanoTagBorder ?? this.volcanoTagBorder,
    );
  }

  @override
  ThemeExtension<SupaExtendedColorScheme> lerp(
    covariant ThemeExtension<SupaExtendedColorScheme>? other,
    double t,
  ) {
    if (other is! SupaExtendedColorScheme) {
      return this;
    }

    return SupaExtendedColorScheme(
      warningText: Color.lerp(warningText, other.warningText, t) ?? warningText,
      warningBackground:
          Color.lerp(warningBackground, other.warningBackground, t) ??
              warningBackground,
      warningBorder:
          Color.lerp(warningBorder, other.warningBorder, t) ?? warningBorder,
      informationText: Color.lerp(informationText, other.informationText, t) ??
          informationText,
      informationBackground:
          Color.lerp(informationBackground, other.informationBackground, t) ??
              informationBackground,
      informationBorder:
          Color.lerp(informationBorder, other.informationBorder, t) ??
              informationBorder,
      successText: Color.lerp(successText, other.successText, t) ?? successText,
      successBackground:
          Color.lerp(successBackground, other.successBackground, t) ??
              successBackground,
      successBorder:
          Color.lerp(successBorder, other.successBorder, t) ?? successBorder,
      defaultText: Color.lerp(defaultText, other.defaultText, t) ?? defaultText,
      defaultBackground:
          Color.lerp(defaultBackground, other.defaultBackground, t) ??
              defaultBackground,
      defaultBorder:
          Color.lerp(defaultBorder, other.defaultBorder, t) ?? defaultBorder,
      errorText: Color.lerp(errorText, other.errorText, t) ?? errorText,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t) ??
          errorBackground,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t) ?? errorBorder,
      blueTagText: Color.lerp(blueTagText, other.blueTagText, t) ?? blueTagText,
      blueTagBackground:
          Color.lerp(blueTagBackground, other.blueTagBackground, t) ??
              blueTagBackground,
      blueTagBorder:
          Color.lerp(blueTagBorder, other.blueTagBorder, t) ?? blueTagBorder,
      cyanTagText: Color.lerp(cyanTagText, other.cyanTagText, t) ?? cyanTagText,
      cyanTagBackground:
          Color.lerp(cyanTagBackground, other.cyanTagBackground, t) ??
              cyanTagBackground,
      cyanTagBorder:
          Color.lerp(cyanTagBorder, other.cyanTagBorder, t) ?? cyanTagBorder,
      geekblueTagText: Color.lerp(geekblueTagText, other.geekblueTagText, t) ??
          geekblueTagText,
      geekblueTagBackground:
          Color.lerp(geekblueTagBackground, other.geekblueTagBackground, t) ??
              geekblueTagBackground,
      geekblueTagBorder:
          Color.lerp(geekblueTagBorder, other.geekblueTagBorder, t) ??
              geekblueTagBorder,
      goldTagText: Color.lerp(goldTagText, other.goldTagText, t) ?? goldTagText,
      goldTagBackground:
          Color.lerp(goldTagBackground, other.goldTagBackground, t) ??
              goldTagBackground,
      goldTagBorder:
          Color.lerp(goldTagBorder, other.goldTagBorder, t) ?? goldTagBorder,
      greenTagText:
          Color.lerp(greenTagText, other.greenTagText, t) ?? greenTagText,
      greenTagBackground:
          Color.lerp(greenTagBackground, other.greenTagBackground, t) ??
              greenTagBackground,
      greenTagBorder:
          Color.lerp(greenTagBorder, other.greenTagBorder, t) ?? greenTagBorder,
      limeTagText: Color.lerp(limeTagText, other.limeTagText, t) ?? limeTagText,
      limeTagBackground:
          Color.lerp(limeTagBackground, other.limeTagBackground, t) ??
              limeTagBackground,
      limeTagBorder:
          Color.lerp(limeTagBorder, other.limeTagBorder, t) ?? limeTagBorder,
      magentaTagText:
          Color.lerp(magentaTagText, other.magentaTagText, t) ?? magentaTagText,
      magentaTagBackground:
          Color.lerp(magentaTagBackground, other.magentaTagBackground, t) ??
              magentaTagBackground,
      magentaTagBorder:
          Color.lerp(magentaTagBorder, other.magentaTagBorder, t) ??
              magentaTagBorder,
      orangeTagText:
          Color.lerp(orangeTagText, other.orangeTagText, t) ?? orangeTagText,
      orangeTagBackground:
          Color.lerp(orangeTagBackground, other.orangeTagBackground, t) ??
              orangeTagBackground,
      orangeTagBorder: Color.lerp(orangeTagBorder, other.orangeTagBorder, t) ??
          orangeTagBorder,
      purpleTagText:
          Color.lerp(purpleTagText, other.purpleTagText, t) ?? purpleTagText,
      purpleTagBackground:
          Color.lerp(purpleTagBackground, other.purpleTagBackground, t) ??
              purpleTagBackground,
      purpleTagBorder: Color.lerp(purpleTagBorder, other.purpleTagBorder, t) ??
          purpleTagBorder,
      redTagText: Color.lerp(redTagText, other.redTagText, t) ?? redTagText,
      redTagBackground:
          Color.lerp(redTagBackground, other.redTagBackground, t) ??
              redTagBackground,
      redTagBorder:
          Color.lerp(redTagBorder, other.redTagBorder, t) ?? redTagBorder,
      volcanoTagText:
          Color.lerp(volcanoTagText, other.volcanoTagText, t) ?? volcanoTagText,
      volcanoTagBackground:
          Color.lerp(volcanoTagBackground, other.volcanoTagBackground, t) ??
              volcanoTagBackground,
      volcanoTagBorder:
          Color.lerp(volcanoTagBorder, other.volcanoTagBorder, t) ??
              volcanoTagBorder,
    );
  }

  SupaExtendedColorTokenGroup getTokenGroup(String name) {
    switch (name) {
      case _warning:
        return SupaExtendedColorTokenGroup(
          text: warningText,
          background: warningBackground,
          border: warningBorder,
        );
      case _information:
        return SupaExtendedColorTokenGroup(
          text: informationText,
          background: informationBackground,
          border: informationBorder,
        );
      case _success:
        return SupaExtendedColorTokenGroup(
          text: successText,
          background: successBackground,
          border: successBorder,
        );
      case _default:
        return SupaExtendedColorTokenGroup(
          text: defaultText,
          background: defaultBackground,
          border: defaultBorder,
        );
      case _error:
        return SupaExtendedColorTokenGroup(
          text: errorText,
          background: errorBackground,
          border: errorBorder,
        );
      case _blueTag:
        return SupaExtendedColorTokenGroup(
          text: blueTagText,
          background: blueTagBackground,
          border: blueTagBorder,
        );
      case _cyanTag:
        return SupaExtendedColorTokenGroup(
          text: cyanTagText,
          background: cyanTagBackground,
          border: cyanTagBorder,
        );
      case _geekblueTag:
        return SupaExtendedColorTokenGroup(
          text: geekblueTagText,
          background: geekblueTagBackground,
          border: geekblueTagBorder,
        );
      case _goldTag:
        return SupaExtendedColorTokenGroup(
          text: goldTagText,
          background: goldTagBackground,
          border: goldTagBorder,
        );
      case _greenTag:
        return SupaExtendedColorTokenGroup(
          text: greenTagText,
          background: greenTagBackground,
          border: greenTagBorder,
        );
      case _limeTag:
        return SupaExtendedColorTokenGroup(
          text: limeTagText,
          background: limeTagBackground,
          border: limeTagBorder,
        );
      case _magentaTag:
        return SupaExtendedColorTokenGroup(
          text: magentaTagText,
          background: magentaTagBackground,
          border: magentaTagBorder,
        );
      case _orangeTag:
        return SupaExtendedColorTokenGroup(
          text: orangeTagText,
          background: orangeTagBackground,
          border: orangeTagBorder,
        );
      case _purpleTag:
        return SupaExtendedColorTokenGroup(
          text: purpleTagText,
          background: purpleTagBackground,
          border: purpleTagBorder,
        );
      case _redTag:
        return SupaExtendedColorTokenGroup(
          text: redTagText,
          background: redTagBackground,
          border: redTagBorder,
        );
      case _volcanoTag:
        return SupaExtendedColorTokenGroup(
          text: volcanoTagText,
          background: volcanoTagBackground,
          border: volcanoTagBorder,
        );
      default:
        throw Exception('Invalid token group name: $name');
    }
  }

  // Helper methods to match SupaExtendedColorScheme interface
  Color getTextColor(String key) {
    switch (key) {
      case _warning:
        return warningText;
      case _processing:
        return informationText;
      case _information:
        return informationText;
      case _success:
        return successText;
      case _critical:
        return errorText;
      case _error:
        return errorText;
      case _default:
        return defaultText;
      case _blueTag:
        return blueTagText;
      case _cyanTag:
        return cyanTagText;
      case _geekblueTag:
        return geekblueTagText;
      case _goldTag:
        return goldTagText;
      case _greenTag:
        return greenTagText;
      case _limeTag:
        return limeTagText;
      case _magentaTag:
        return magentaTagText;
      case _orangeTag:
        return orangeTagText;
      case _purpleTag:
        return purpleTagText;
      case _redTag:
        return redTagText;
      case _volcanoTag:
        return volcanoTagText;
      default:
        return defaultText;
    }
  }

  Color getBackgroundColor(String key) {
    switch (key) {
      case _warning:
        return warningBackground;
      case _processing:
        return informationBackground;
      case _information:
        return informationBackground;
      case _success:
        return successBackground;
      case _critical:
        return errorBackground;
      case _error:
        return errorBackground;
      case _default:
      case 'defaultColor': // keep for backward compatibility if needed
        return defaultBackground;
      case _blueTag:
        return blueTagBackground;
      case _cyanTag:
        return cyanTagBackground;
      case _geekblueTag:
        return geekblueTagBackground;
      case _goldTag:
        return goldTagBackground;
      case _greenTag:
        return greenTagBackground;
      case _limeTag:
        return limeTagBackground;
      case _magentaTag:
        return magentaTagBackground;
      case _orangeTag:
        return orangeTagBackground;
      case _purpleTag:
        return purpleTagBackground;
      case _redTag:
        return redTagBackground;
      case _volcanoTag:
        return volcanoTagBackground;
      default:
        return defaultBackground;
    }
  }

  Color getBorderColor(String key) {
    switch (key) {
      case _warning:
        return warningBorder;
      case _processing:
        return informationBorder;
      case _information:
        return informationBorder;
      case _success:
        return successBorder;
      case _critical:
        return errorBorder;
      case _error:
        return errorBorder;
      case _default:
      case 'defaultColor': // keep for backward compatibility if needed
        return defaultBorder;
      case _blueTag:
        return blueTagBorder;
      case _cyanTag:
        return cyanTagBorder;
      case _geekblueTag:
        return geekblueTagBorder;
      case _goldTag:
        return goldTagBorder;
      case _greenTag:
        return greenTagBorder;
      case _limeTag:
        return limeTagBorder;
      case _magentaTag:
        return magentaTagBorder;
      case _orangeTag:
        return orangeTagBorder;
      case _purpleTag:
        return purpleTagBorder;
      case _redTag:
        return redTagBorder;
      case _volcanoTag:
        return volcanoTagBorder;
      default:
        return defaultBorder;
    }
  }
}
