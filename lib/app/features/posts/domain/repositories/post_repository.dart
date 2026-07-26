import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, Post>> createPost(Post post);
}
