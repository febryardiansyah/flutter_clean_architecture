import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/resources/data_state.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticleUsecase usecase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    usecase = GetArticleUsecase(mockArticleRepository);
  });

  group('get article usecase test', () {
    test('should returns DataSuccess state', () async {
      when(() => mockArticleRepository.getArticles()).thenAnswer(
        (_) async => const DataSuccess<List<ArticleEntity>>([]),
      );

      final result = await usecase.call();

      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
      verify(() => mockArticleRepository.getArticles()).called(1);
    });

    test('should return DataFailed', () async {
      when(() => mockArticleRepository.getArticles()).thenAnswer(
        (_) async => DataFailed(DioException(
          requestOptions: RequestOptions(path: '/top-headlines'),
        )),
      );

      final result = await usecase.call();

      expect(result, isA<DataFailed>());
      verify(() => mockArticleRepository.getArticles()).called(1);
    });
  });
}
