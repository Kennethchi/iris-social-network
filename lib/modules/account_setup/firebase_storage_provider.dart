import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'dart:io';


class FirebaseStorageProvider{


  static Future<String> uploadImage({@required String storagePath, File imageFile}) async{

    StorageReference ref = FirebaseStorage.instance.ref().child(storagePath);


    StorageUploadTask task = ref.putFile(imageFile);


    task.events.listen((StorageTaskEvent event){

      double bytesTransferred = event.snapshot.bytesTransferred.toDouble();
      double totalByteCount = event.snapshot.totalByteCount.toDouble();
      String progressPercent = "${(bytesTransferred / totalByteCount * 100.0).toStringAsFixed(2)}%";
      print("------------------------------------" + progressPercent);
    });


    return await (await task.onComplete).ref.getDownloadURL();
  }


}













