import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  if (Platform.isAndroid) {
    var manageExternalStatus = await Permission.manageExternalStorage.status;
    var storageStatus = await Permission.storage.status;

    if (!manageExternalStatus.isGranted) {
      manageExternalStatus = await Permission.manageExternalStorage.request();
    }
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }

    print("Manage External Storage: $manageExternalStatus");
    print("Storage Permission: $storageStatus");
  }
}

Future<File?> pickImage() async {
  await requestStoragePermission();
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.path!);
    }
    return null;
  } catch (e) {
    print("Error picking image: $e");
    return null;
  }
}

Future<File?> pickAudio() async {
  await requestStoragePermission();
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.path!);
    }
    return null;
  } catch (e) {
    print("Error picking audio: $e");
    return null;
  }
}
