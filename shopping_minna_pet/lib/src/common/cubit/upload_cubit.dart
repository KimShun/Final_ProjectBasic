import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadCubit extends Cubit<UploadState> {
  FirebaseStorage storage;
  UploadCubit(this.storage) : super(UploadState());

  // 단일 이미지 업로드 경우 - 회원가입 or 이벤트
  void uploadImage(File file, String uid, String path, String name) {
    emit(state.copyWith(status: UploadStatus.uploading));
    final storageRef = storage.ref();
    var uploadTask = storageRef.child("$path/$uid/$name.jpg").putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch(taskSnapshot.state) {
        case TaskState.running:
          final progress = 100 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          emit(state.copyWith(percent: progress));
          break;
        case TaskState.success:
          final ImageUrl = await storageRef.child("$path/$uid/$name.jpg").getDownloadURL();
          emit(state.copyWith(url: ImageUrl, status: UploadStatus.success));
          break;
        case TaskState.paused:
        case TaskState.canceled:
        case TaskState.error:
          break;
      }
    });
  }

  // 다중 이미지 업로드 경우 - 자유게시판 or 판매
  void uploadImages(List<File> file, String uid, String path) {
    List<String> ImageUrls = [];

    emit(state.copyWith(status: UploadStatus.uploading));
    final storageRef = storage.ref();

    for(int i=0; i<file.length; i++) {
      var uploadTask = storageRef.child("$path/$uid/$i.jpg").putFile(file[i]);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch(taskSnapshot.state) {
          case TaskState.running:
            final progress = 100 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            emit(state.copyWith(percent: progress));
            break;
          case TaskState.success:
            final ImageUrl = await storageRef.child("$path/$uid/$i.jpg").getDownloadURL();
            ImageUrls.add(ImageUrl);

            if(i == file.length-1) {
              emit(state.copyWith(urls: ImageUrls, status: UploadStatus.success));
            } else {
              emit(state.copyWith(status: UploadStatus.success));
            }
            break;
          case TaskState.paused:
          case TaskState.canceled:
          case TaskState.error:
            break;
        }
      });
    }
  }
}

enum UploadStatus {
  init,
  uploading,
  success,
  error
}

class UploadState extends Equatable {
  final UploadStatus status;
  final double? percent;
  final String? url;
  final List<String>? urls;

  const UploadState({
    this.status = UploadStatus.init,
    this.percent = 0,
    this.url,
    this.urls,
  });

  UploadState copyWith({
    UploadStatus? status,
    double? percent,
    String? url,
    List<String>? urls,
  }) {
    return UploadState(
      status: status ?? this.status,
      percent: percent ?? this.percent,
      url: url ?? this.url,
      urls: urls ?? this.urls,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, percent, url, urls];
}