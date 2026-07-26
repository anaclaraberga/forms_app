import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, Post>> call(Post post) async {
    return await repository.createPost(post);
  }
}
