import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../common/model/post_model.dart';
import '../common/model/user_model.dart';
import '../common/repository/post_repository.dart';

class PostCubit extends Cubit<PostState> {
  final UserModel userModel;
  final PostRepository _postRepository;
  PostCubit(this.userModel, this._postRepository) : super(PostState(writerUid: userModel.uid));

  void init() {
    emit(state.copyWith(posts: PostModelResult.init(), status: PostStatus.init));
    loadPosts(10, true, null);
  }

  void reset() {
    emit(state.copyWith(title: null, content: null, imageFiles: []));
  }

  void loadPosts(int limit, bool isInit, String? uid) async {
    emit(state.copyWith(status: PostStatus.loading));
    List<PostModel>? postModels = await _postRepository.loadPosts(limit, isInit, uid);

    if(postModels != null) {
      emit(state.copyWith(posts: state.posts!.copyWithFromList(postModels), status: PostStatus.success));
    } else {
      emit(state.copyWith(status: PostStatus.error));
    }
  }

  void changeUuid(String uuid) {
    emit(state.copyWith(uuid: uuid));
  }

  void changeTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void changeContent(String content) {
    emit(state.copyWith(content: content));
  }

  void uploadPercent(String percent) {
    emit(state.copyWith(percent: percent));
  }

  void changePostImage(XFile? imageFile) {
    if(imageFile == null) { return; }

    var file = File(imageFile.path);
    var updatedImageFiles = List<File>.from(state.imageFiles)..add(file);
    emit(state.copyWith(imageFiles: updatedImageFiles));
  }

  void deletePostImage(int index) {
    var updatedImageFiles = List<File>.from(state.imageFiles)..removeAt(index);
    emit(state.copyWith(imageFiles: updatedImageFiles));
  }

  void changeDate() {
    emit(state.copyWith(date: DateTime.now()));
  }

  void updateImagesPost(List<String> urls) {
    emit(state.copyWith(postModel: state.postModel!.copyWith(images: urls), status: PostStatus.loading));
    submit();
  }

  void save() {
    if(state.title == null || state.title == "" || state.content == null || state.content == "") return;
    emit(state.copyWith(status: PostStatus.loading));

    PostModel newPost = PostModel(title: state.title, writerUid: state.writerUid, content: state.content, date: state.date, uuid: state.uuid, images: [], likeCount: 0);
    emit(state.copyWith(postModel: newPost));

    if(state.imageFiles.isNotEmpty) {
      emit(state.copyWith(status: PostStatus.uploading));
    } else {
      submit();
    }
  }

  void submit() async {
    var result = await _postRepository.createPost(state.postModel!);

    if(result) {
      emit(state.copyWith(status: PostStatus.success));
    } else {
      emit(state.copyWith(status: PostStatus.error));
    }
  }
}

enum PostStatus {
  init,
  loading,
  uploading,
  success,
  error
}

class PostState extends Equatable {
  final String? uuid;
  final String? title;
  final String? content;
  final List<File> imageFiles;
  final DateTime? date;
  final PostModel? postModel;
  final PostModelResult? posts;
  final PostStatus status;
  final String? writerUid;
  final String? percent;

  const PostState({
    this.uuid,
    this.title,
    this.content,
    this.imageFiles = const [],
    this.date,
    this.postModel,
    this.posts,
    this.status = PostStatus.init,
    this.writerUid,
    this.percent,
  });

  PostState copyWith({
    String? uuid,
    String? title,
    String? content,
    List<File>? imageFiles,
    DateTime? date,
    PostModel? postModel,
    PostModelResult? posts,
    String? writerUid,
    PostStatus? status,
    String? percent
  }) {
    return PostState(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      content: content ?? this.content,
      imageFiles: imageFiles ?? this.imageFiles,
      date: date ?? this.date,
      postModel: postModel ?? this.postModel,
      posts: posts ?? this.posts,
      writerUid: writerUid ?? this.writerUid,
      status: status ?? this.status,
      percent: percent ?? this.percent,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid, title, content, imageFiles, date, postModel, posts, writerUid, status, percent];
}