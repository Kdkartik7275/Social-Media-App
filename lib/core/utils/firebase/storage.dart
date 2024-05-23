import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_x/core/utils/file_utils.dart';

Future<String> uploadMediaToStorage(
    {required String path, required File image, required String postId}) async {
  String ext = FileUtils.getFileExtension(image);
  Reference storageReference =
      FirebaseStorage.instance.ref(path).child("$postId.$ext");
  UploadTask uploadTask = storageReference.putFile(image);
  await uploadTask.whenComplete(() => null);
  String imageUrl = await storageReference.getDownloadURL();
  return imageUrl;
}
