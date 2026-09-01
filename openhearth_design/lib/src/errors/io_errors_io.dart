import 'dart:io';

import 'messages.dart';

/// Classifies the dart:io exceptions. Kept behind a conditional import so the
/// package still compiles for the web PWAs, where dart:io does not exist.
String? ohIoErrorMessage(Object error) {
  if (error is SocketException ||
      error is HttpException ||
      error is HandshakeException ||
      error is TlsException) {
    return OhErrorMessages.network;
  }
  if (error is FileSystemException) return OhErrorMessages.file;
  return null;
}
