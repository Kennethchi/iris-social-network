import 'package:meta/meta.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';



class FirebaseStorageProvider{


  static Future<String> uploadFile({@required String storagePath, @required File file}) async{

    StorageReference ref = FirebaseStorage.instance.ref().child(storagePath);

    StorageUploadTask task = await ref.putFile(file);

    return await (await task.onComplete).ref.getDownloadURL();
  }


}






