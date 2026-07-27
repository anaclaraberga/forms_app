import 'package:forms_app/app/features/posts/data/datasources/post_local_datasource.dart';
import 'package:forms_app/app/features/posts/data/datasources/post_remote_datasource.dart';
import 'package:forms_app/app/features/posts/data/repositories/post_repository_impl.dart';
import 'package:get_it/get_it.dart';
import '../network/http_client.dart';

import 'package:forms_app/app/core/storage/database_helper.dart';

import 'package:forms_app/app/features/posts/presentation/cubit/post_list_cubit.dart';
import 'package:forms_app/app/features/posts/domain/use_cases/create_post_usecase.dart';
import 'package:forms_app/app/features/posts/domain/use_cases/get_posts_usecase.dart';
import 'package:forms_app/app/features/posts/domain/repositories/post_repository.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<HttpClient>(() => HttpClient());

  // Database Helper
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Datasources
  sl.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasourceImpl(httpClient: sl<HttpClient>()),
  );

  sl.registerLazySingleton<PostLocalDatasource>(
    () => PostLocalDatasourceImpl(dbHelper: sl<DatabaseHelper>()),
  );

  // Repositories
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDatasource: sl<PostRemoteDatasource>(),
      localDatasource: sl<PostLocalDatasource>(),
    ),
  );

  // Use Cases
  sl.registerFactory<GetPostsUseCase>(
    () => GetPostsUseCase(sl<PostRepository>()),
  );

  sl.registerFactory<CreatePostUseCase>(
    () => CreatePostUseCase(sl<PostRepository>()),
  );

  // Cubits
  sl.registerFactory<PostListCubit>(
    () => PostListCubit(getPostsUseCase: sl<GetPostsUseCase>()),
  );
}
