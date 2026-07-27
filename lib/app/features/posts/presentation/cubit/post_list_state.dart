import '../../domain/entities/post.dart';

abstract class PostListState {}

class PostListInitial extends PostListState {}

class PostListLoading extends PostListState {}

class PostListSuccess extends PostListState {
  final List<Post> posts;
  final List<Post> filteredPosts;
  final String searchQuery;

  PostListSuccess({
    required this.posts,
    List<Post>? filteredPosts,
    this.searchQuery = '',
  }) : filteredPosts = filteredPosts ?? posts;
}

class PostListError extends PostListState {
  final String message;
  PostListError(this.message);
}
