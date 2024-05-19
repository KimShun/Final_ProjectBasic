import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../common/model/post_model.dart';
import '../common/model/user_model.dart';
import '../common/repository/post_repository.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository _postRepository;
  PostCubit(UserModel userModel, this._postRepository) : super(PostState(writerUid: userModel.uid));

  void init() {
    emit(state.copyWith(posts: PostModelResult.init()));
    loadPosts(10, true);
  }

  void loadPosts(int limit, bool isInit) async {
    emit(state.copyWith(status: PostStatus.loading));
    List<PostModel>? postModels = await _postRepository.loadPosts(limit, isInit);

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

  void changePostImage(XFile? imageFile) {
    if(imageFile == null) { return; }

    var file = File(imageFile.path);
    emit(state.copyWith(imageFile: file));
  }

  void changeDate() {
    emit(state.copyWith(date: DateTime.now()));
  }

  void save() {
    if(state.title == null || state.title == "" || state.content == null || state.content == "") return;
    emit(state.copyWith(status: PostStatus.loading));

    if(state.imageFile != null) {
      emit(state.copyWith(status: PostStatus.uploading));
    } else {
      submit();
    }
  }

  void submit() async {
    PostModel newPost = PostModel(title: state.title, writerUid: state.writerUid, content: state.content, date: state.date, uuid: state.uuid);

    emit(state.copyWith(postModel: newPost));
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
  final File? imageFile;
  final DateTime? date;
  final PostModel? postModel;
  final PostModelResult? posts;
  final PostStatus status;
  final String? writerUid;

  const PostState({
    this.uuid,
    this.title,
    this.content,
    this.imageFile,
    this.date,
    this.postModel,
    this.posts,
    this.status = PostStatus.init,
    this.writerUid,
  });

  PostState copyWith({
    String? uuid,
    String? title,
    String? content,
    File? imageFile,
    DateTime? date,
    PostModel? postModel,
    PostModelResult? posts,
    String? writerUid,
    PostStatus? status,
  }) {
    return PostState(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      content: content ?? this.content,
      imageFile: imageFile ?? this.imageFile,
      date: date ?? this.date,
      postModel: postModel ?? this.postModel,
      posts: posts ?? this.posts,
      writerUid: writerUid ?? this.writerUid,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid, title, content, imageFile, date, postModel, posts, writerUid, status];
}