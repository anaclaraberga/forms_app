import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:forms_app/app/features/posts/domain/use_cases/get_posts_usecase.dart';
import 'package:forms_app/app/features/posts/domain/repositories/post_repository.dart';
import 'package:forms_app/app/features/posts/domain/entities/post.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPostsUseCase useCase;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = GetPostsUseCase(mockRepository);
  });

  final tPosts = [const Post(id: 1, title: 'Test Title', body: 'Test Body')];

  test('Deve retornar uma lista de posts do repositório', () async {
    when(
      () => mockRepository.getPosts(),
    ).thenAnswer((_) async => Right(tPosts));

    final result = await useCase();

    expect(result, Right(tPosts));

    verify(() => mockRepository.getPosts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
