import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageProvider = FutureProvider(
  (ref) => CommonFirebaseStorage(firebaseStorage: FirebaseStorage.instance),
);

class CommonFirebaseStorage {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorage({
    required this.firebaseStorage,
  });

  Future<String> saveFileInFirebaseStorage(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
