import 'dart:io';

extension FileRemoval on File {
  Future<void> deleteIfExists() async {
    try {
      await this.delete();
    } on FileSystemException {}
  }
}
