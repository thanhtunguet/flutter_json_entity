import 'package:flutter/material.dart';

import 'supa_extended_color_token_group.dart';

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
      case 'warning':
        return SupaExtendedColorTokenGroup(
          text: warningText,
          background: warningBackground,
          border: warningBorder,
        );
      case 'information':
        return SupaExtendedColorTokenGroup(
          text: informationText,
          background: informationBackground,
          border: informationBorder,
        );
      case 'success':
        return SupaExtendedColorTokenGroup(
          text: successText,
          background: successBackground,
          border: successBorder,
        );
      case 'default':
        return SupaExtendedColorTokenGroup(
          text: defaultText,
          background: defaultBackground,
          border: defaultBorder,
        );
      case 'error':
        return SupaExtendedColorTokenGroup(
          text: errorText,
          background: errorBackground,
          border: errorBorder,
        );
      case 'blueTag':
        return SupaExtendedColorTokenGroup(
          text: blueTagText,
          background: blueTagBackground,
          border: blueTagBorder,
        );
      case 'cyanTag':
        return SupaExtendedColorTokenGroup(
          text: cyanTagText,
          background: cyanTagBackground,
          border: cyanTagBorder,
        );
      case 'geekblueTag':
        return SupaExtendedColorTokenGroup(
          text: geekblueTagText,
          background: geekblueTagBackground,
          border: geekblueTagBorder,
        );
      case 'goldTag':
        return SupaExtendedColorTokenGroup(
          text: goldTagText,
          background: goldTagBackground,
          border: goldTagBorder,
        );
      case 'greenTag':
        return SupaExtendedColorTokenGroup(
          text: greenTagText,
          background: greenTagBackground,
          border: greenTagBorder,
        );
      case 'limeTag':
        return SupaExtendedColorTokenGroup(
          text: limeTagText,
          background: limeTagBackground,
          border: limeTagBorder,
        );
      case 'magentaTag':
        return SupaExtendedColorTokenGroup(
          text: magentaTagText,
          background: magentaTagBackground,
          border: magentaTagBorder,
        );
      case 'orangeTag':
        return SupaExtendedColorTokenGroup(
          text: orangeTagText,
          background: orangeTagBackground,
          border: orangeTagBorder,
        );
      case 'purpleTag':
        return SupaExtendedColorTokenGroup(
          text: purpleTagText,
          background: purpleTagBackground,
          border: purpleTagBorder,
        );
      case 'redTag':
        return SupaExtendedColorTokenGroup(
          text: redTagText,
          background: redTagBackground,
          border: redTagBorder,
        );
      case 'volcanoTag':
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
      case 'warning':
        return warningText;
      case 'processing':
        return informationText;
      case 'success':
        return successText;
      case 'critical':
        return errorText;
      case 'error':
        return errorText;
      case 'defaultColor':
        return defaultText;
      case 'blue':
        return blueTagText;
      case 'cyan':
        return cyanTagText;
      case 'geekblue':
        return geekblueTagText;
      case 'gold':
        return goldTagText;
      case 'green':
        return greenTagText;
      case 'lime':
        return limeTagText;
      case 'magenta':
        return magentaTagText;
      case 'orange':
        return orangeTagText;
      case 'purple':
        return purpleTagText;
      case 'red':
        return redTagText;
      case 'volcano':
        return volcanoTagText;
      default:
        return defaultText;
    }
  }

  Color getBackgroundColor(String key) {
    switch (key) {
      case 'warning':
        return warningBackground;
      case 'processing':
        return informationBackground;
      case 'success':
        return successBackground;
      case 'critical':
        return errorBackground;
      case 'error':
        return errorBackground;
      case 'defaultColor':
        return defaultBackground;
      case 'blue':
        return blueTagBackground;
      case 'cyan':
        return cyanTagBackground;
      case 'geekblue':
        return geekblueTagBackground;
      case 'gold':
        return goldTagBackground;
      case 'green':
        return greenTagBackground;
      case 'lime':
        return limeTagBackground;
      case 'magenta':
        return magentaTagBackground;
      case 'orange':
        return orangeTagBackground;
      case 'purple':
        return purpleTagBackground;
      case 'red':
        return redTagBackground;
      case 'volcano':
        return volcanoTagBackground;
      default:
        return defaultBackground;
    }
  }

  Color getBorderColor(String key) {
    switch (key) {
      case 'warning':
        return warningBorder;
      case 'processing':
        return informationBorder;
      case 'success':
        return successBorder;
      case 'critical':
        return errorBorder;
      case 'error':
        return errorBorder;
      case 'defaultColor':
        return defaultBorder;
      case 'blue':
        return blueTagBorder;
      case 'cyan':
        return cyanTagBorder;
      case 'geekblue':
        return geekblueTagBorder;
      case 'gold':
        return goldTagBorder;
      case 'green':
        return greenTagBorder;
      case 'lime':
        return limeTagBorder;
      case 'magenta':
        return magentaTagBorder;
      case 'orange':
        return orangeTagBorder;
      case 'purple':
        return purpleTagBorder;
      case 'red':
        return redTagBorder;
      case 'volcano':
        return volcanoTagBorder;
      default:
        return defaultBorder;
    }
  }

  Color fromKey(String key) {
    switch (key) {
      case 'warning':
        return warningText;
      case 'onWarning':
        return warningBackground;
      case 'warningContainer':
        return warningBorder;
      case 'onWarningContainer':
        return warningText;
      case 'information':
        return informationText;
      case 'onInformation':
        return informationBackground;
      case 'informationContainer':
        return informationBorder;
      case 'onInformationContainer':
        return informationText;
      case 'success':
        return successText;
      case 'onSuccess':
        return successBackground;
      case 'successContainer':
        return successBorder;
      case 'onSuccessContainer':
        return successText;
      case 'default':
      case 'defaultColor':
        return defaultText;
      case 'onDefault':
        return defaultBackground;
      case 'defaultContainer':
        return defaultBorder;
      case 'onDefaultContainer':
        return defaultText;
      case 'critical':
        return errorText;
      case 'onCritical':
        return errorBackground;
      default:
        return defaultText;
    }
  }
}
