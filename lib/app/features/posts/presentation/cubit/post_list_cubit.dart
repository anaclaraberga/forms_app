import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/app/features/posts/domain/use_cases/get_posts_usecase.dart';
import 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  final GetPostsUseCase getPostsUseCase;

  PostListCubit({required this.getPostsUseCase}) : super(PostListInitial());

  Future<void> fetchPosts() async {
    emit(PostListLoading());

    final result = await getPostsUseCase();

    result.fold(
      (failure) => emit(PostListError(failure.message)),
      (posts) => emit(PostListSuccess(posts: posts)),
    );
  }

  void filterPosts(String query) {
      if (state is PostListSuccess) {
        final currentState = state as PostListSuccess;

        if (query.isEmpty) {
          emit(
            PostListSuccess(
              posts: currentState.posts,
              filteredPosts: currentState.posts,
              searchQuery: '',
            ),
          );
        } else {
          final filtered = currentState.posts.where((post) {
            return post.title.toLowerCase().contains(query.toLowerCase());
          }).toList();

          emit(
            PostListSuccess(
              posts: currentState.posts,
              filteredPosts: filtered,
              searchQuery: query,
            ),
          );
        }
      }
    }
}
