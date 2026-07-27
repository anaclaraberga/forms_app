import 'package:get_it/get_it.dart';
import '../network/http_client.dart';

import 'package:forms_app/app/features/posts/domain/use_cases/create_post_usecase.dart';
import 'package:forms_app/app/features/posts/domain/use_cases/get_posts_usecase.dart';
import 'package:forms_app/app/features/posts/domain/repositories/post_repository.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<HttpClient>(() => HttpClient(null));
  sl.registerFactory(() => GetPostsUseCase(sl<PostRepository>()));
  sl.registerFactory(() => CreatePostUseCase(sl<PostRepository>()));
}
