/// A class representing the configuration for reCAPTCHA.
///
/// This class holds the site key required for reCAPTCHA validation.
class RecaptchaConfig {
  /// The site key used for reCAPTCHA validation.
  final String siteKey;

  /// Constructs an instance of [RecaptchaConfig].
  ///
  /// **Parameters:**
  /// - `siteKey`: The site key for reCAPTCHA validation.
  const RecaptchaConfig({
    required this.siteKey,
  });
}
