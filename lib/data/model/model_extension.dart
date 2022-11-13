extension ToMapExtension on Map<String, dynamic> {
  Map<String, dynamic> withId(int id, {bool cancel = false}) {
    if (!cancel) this["id"] = id;
    return this;
  }
}