import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadSingleImage(XFile? image, String folderName) async {
  print(image);
  if (image != null) {
    String? imageUrl;

    FirebaseStorage storage = FirebaseStorage.instance;
    var date = DateTime.now().millisecondsSinceEpoch;
    try {
      // Access the XFile object from Rx<XFile?> and then call readAsBytes() on it
      List<int> imageData = await image.readAsBytes();

      UploadTask task = storage.ref('$folderName/${date}_image.png').putData(
          Uint8List.fromList(imageData), SettableMetadata(contentType: 'image/jpeg'));

      TaskSnapshot downloadUrl = await task;

      String url = await downloadUrl.ref.getDownloadURL();

      imageUrl = url;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }

    return imageUrl;
  }

  return "";
  // throw Exception('No image selected');
}