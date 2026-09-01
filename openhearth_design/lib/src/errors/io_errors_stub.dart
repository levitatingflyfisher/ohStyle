// Platforms without dart:io (the web PWAs) cannot throw io exceptions, so
// there is nothing to classify.
String? ohIoErrorMessage(Object error) => null;
