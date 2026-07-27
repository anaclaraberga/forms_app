import '../../../../core/storage/database_helper.dart';
import '../models/post_model.dart';

abstract class PostLocalDatasource {
  Future<void> cachePosts(List<PostModel> posts);
  Future<List<PostModel>> getLocalPosts();
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final DatabaseHelper dbHelper;

  PostLocalDatasourceImpl({required this.dbHelper});

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    for (var post in posts) {
      await dbHelper.insertPost(post);
    }
  }

  @override
  Future<List<PostModel>> getLocalPosts() async {
    return await dbHelper.getPosts();
  }
}
