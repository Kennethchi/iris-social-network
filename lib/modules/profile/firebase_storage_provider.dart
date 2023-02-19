import 'package:meta/meta.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseStorageProvider{

  static Future<String> uploadFile({@required storagePath, @required File file})async{

    StorageReference ref = FirebaseStorage.instance.ref().child(storagePath);
    StorageUploadTask task = await ref.putFile(file);


    return await  (await task.onComplete).ref.getDownloadURL();
  }


  static Future<bool> removeFile({@required String urlPath})async{

    StorageReference ref = await FirebaseStorage.instance.getReferenceFromUrl(urlPath);

    if (ref != null){
      await ref.delete();
      return true;
    }

    return false;
  }


}