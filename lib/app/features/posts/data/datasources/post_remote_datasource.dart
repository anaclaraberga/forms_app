import '../../../../core/network/http_client.dart';
import '../models/post_model.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> createPost(PostModel post);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final HttpClient httpClient;

  PostRemoteDatasourceImpl({required this.httpClient});

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await httpClient.get('/posts');
    final List<dynamic> data = response.data;

    return data.map((json) => PostModel.fromJson(json)).toList();
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    final response = await httpClient.post('/posts', data: post.toJson());

    return PostModel.fromJson(response.data);
  }
}
