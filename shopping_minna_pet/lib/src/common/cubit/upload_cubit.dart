import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadCubit extends Cubit<UploadState> {
  FirebaseStorage storage;
  UploadCubit(this.storage) : super(UploadState());

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

  const UploadState({
    this.status = UploadStatus.init,
    this.percent = 0,
    this.url,
  });

  UploadState copyWith({
    UploadStatus? status,
    double? percent,
    String? url,
  }) {
    return UploadState(
      status: status ?? this.status,
      percent: percent ?? this.percent,
      url: url ?? this.url,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, percent, url];
}