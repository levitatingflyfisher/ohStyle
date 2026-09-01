/// The plain sentences [ohFriendlyErrorMessage] returns. Public so an app can
/// reuse the exact wording (and a test can pin it) without re-typing it.
abstract final class OhErrorMessages {
  static const timeout =
      'That took too long. Check your connection and try again.';
  static const network =
      "Couldn't reach the internet. Check your connection and try again.";
  static const file = "Couldn't read or save a file on this device.";
  static const format =
      "Some data wasn't in the shape we expected, so it couldn't be read.";
  static const generic = 'Something unexpected went wrong. Please try again.';
}
