import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_datasource.dart';
import '../datasources/post_remote_datasource.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;
  final PostLocalDatasource localDatasource;

  PostRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, Post>> createPost(Post post) async {
    try {
      final postModel = PostModel.fromEntity(post);

      final createRemotePost = await remoteDatasource.createPost(postModel);
      await localDatasource.cachePosts([createRemotePost]);

      return Right(createRemotePost);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(
        ServerFailure('Erro ao salvar registro no banco local ou na API.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final localPosts = await localDatasource.getLocalPosts();

      try {
        final remotePosts = await remoteDatasource.getPosts();
        final combinedPosts = [...localPosts, ...remotePosts];

        return Right(combinedPosts);
      } catch (e) {
        if (localPosts.isNotEmpty) {
          return Right(localPosts);
        }

        if (e is Failure) return Left(e);
        return Left(ServerFailure('Falha ao se comunicar com a API.'));
      }
    } catch (e) {
      return Left(ServerFailure('Ocorreu um erro ao carregar os dados.'));
    }
  }
}
