import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'server_rest_api_provider.dart';

abstract class VideoViewerBlocBlueprint{

  Future<File> downLoadFile({@required String urlPath, @required String savePath, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

  void dispose();
}


class VideoViewerBloc implements VideoViewerBlocBlueprint{



  // progress byte
  BehaviorSubject<int> _progressTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getProgressTransferDataStream => _progressTransferDataBehaviorSubject.stream;
  StreamSink<int> get getProgressTransferDataSink => _progressTransferDataBehaviorSubject.sink;

  void addProgressTransferDataToStream(int progressTransferData){
    getProgressTransferDataSink.add(progressTransferData);
  }

  // total byte
  BehaviorSubject<int> _totalTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getTotalTransferDataStream => _totalTransferDataBehaviorSubject.stream;
  StreamSink<int> get getTotalTransferDataSink => _totalTransferDataBehaviorSubject.sink;

  void addTotalTransferDataToStream(int totalTransferData){
    getTotalTransferDataSink.add(totalTransferData);
  }

  // percent ratio progress stream
  BehaviorSubject<double> _percentRatioProgressBehaviorSubject = BehaviorSubject<double>();
  Stream<double> get getPercentRatioProgressStream => _percentRatioProgressBehaviorSubject.stream;
  Sink<double> get _getPercentRatioProgressSink => _percentRatioProgressBehaviorSubject.sink;

  void addPercentRatioProgress(double percentRatioProgress){
    _getPercentRatioProgressSink.add(percentRatioProgress);
  }

  // Stream subscription for observing latest combination of ongoing progress transfer and total transfer
  StreamSubscription<double> _observeCombineLatestProgressAndTotalTransfer;



  
  



  BehaviorSubject<bool> _isVideoInitialisedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsVideoInitialisedStream => _isVideoInitialisedBehaviorSubject.stream;
  StreamSink<bool> get _getIsVideoInitialisedSink => _isVideoInitialisedBehaviorSubject.sink;


  // Is Media Downloading stream
  BehaviorSubject<bool> _isMediaDownloadingBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsMediaDownloadingStream => _isMediaDownloadingBehaviorSubject.stream;
  Sink<bool> get _getIsMediaDownloadSink => _isMediaDownloadingBehaviorSubject.sink;



  VideoViewerBloc(){


    // obserbing percentage ratio transfer
    _observeCombineLatestProgressAndTotalTransfer = Observable.combineLatest2(getProgressTransferDataStream, getTotalTransferDataStream, (int progressTransfer, int totalTransfer){

      print("Sent: $progressTransfer, total: $totalTransfer");

      return progressTransfer / totalTransfer;
    }).listen((double percentProgressRatio){
      addPercentRatioProgress(percentProgressRatio);
    });


    addIsMediaDownloadingToStream(false);
  }



  void addIsMediaDownloadingToStream(bool isMediaDownloading){
    _getIsMediaDownloadSink.add(isMediaDownloading);
  }



  @override
  Future<File> downLoadFile(
      {@required String urlPath, @required String savePath, @required StreamSink<
          int> progressSink, @required StreamSink<int> totalSink})async {
    return await ServerRestApiProvider.downLoadFile(urlPath: urlPath, savePath: savePath, progressSink: progressSink, totalSink: totalSink);
  }

  void addIsVideoInitialisedToStream(bool isVideoInitialised){
    _getIsVideoInitialisedSink.add(isVideoInitialised);
  }

  @override
  void dispose() {

    _isVideoInitialisedBehaviorSubject?.close();
    _isMediaDownloadingBehaviorSubject?.close();
    _percentRatioProgressBehaviorSubject?.close();
    _progressTransferDataBehaviorSubject?.close();
    _totalTransferDataBehaviorSubject?.close();
  }
}


