import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.getPosts();
  }
}
