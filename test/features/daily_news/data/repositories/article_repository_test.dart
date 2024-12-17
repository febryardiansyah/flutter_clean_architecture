import 'package:dio/dio.dart';
import 'package:floor/floor.dart';
import 'package:flutter_clean_architecture/core/constants/constants.dart';
import 'package:flutter_clean_architecture/core/resources/data_state.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/data_sources/local/article_dao.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/data_sources/remote/news_remote_source.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/repositories/article_repository_impl.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/json_reader.dart';

class MockNewsRemoteDataSource extends Mock implements NewsRemoteSource {}

class MockFloorDatabase extends Mock implements FloorDatabase {}

class MockArticleDao extends Mock implements ArticleDao {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  late MockNewsRemoteDataSource mockNewsRemoteDataSource;
  late MockAppDatabase mockAppDatabase;
  late MockArticleDao mockArticleDao;
  late ArticleRepostioryImpl articleRepository;

  setUp(() {
    mockNewsRemoteDataSource = MockNewsRemoteDataSource();
    mockAppDatabase = MockAppDatabase();
    mockArticleDao = MockArticleDao();

    when(() => mockAppDatabase.articleDao).thenReturn(mockArticleDao);

    registerFallbackValue(articleListDummyResponse['articles'][0]);

    articleRepository = ArticleRepostioryImpl(
      mockNewsRemoteDataSource,
      mockAppDatabase,
    );
  });

  group('ArticleRepositoy', () {
    test('get articles with DataSuccess', () async {
      when(
        () => mockNewsRemoteDataSource.getNewsArticles(
          apiKey: newsApiKey,
          country: 'us',
        ),
      ).thenAnswer(
        (_) async => (articleListDummyResponse['articles'] as List)
            .map((e) => ArticleModel.fromJson(e))
            .toList(),
      );

      final result = await articleRepository.getArticles();

      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
      verify(
        () => mockNewsRemoteDataSource.getNewsArticles(
          apiKey: newsApiKey,
          country: 'us',
        ),
      ).called(1);
    });

    test('get articles with DataFailed', () async {
      when(
        () => mockNewsRemoteDataSource.getNewsArticles(
          apiKey: newsApiKey,
          country: 'us',
        ),
      ).thenThrow(
        DataFailed(
          DioException(requestOptions: RequestOptions(path: '/top-headlines')),
        ),
      );

      final result = articleRepository.getArticles();

      expect(result, throwsA(isA<DataFailed>()));
      verify(
        () => mockNewsRemoteDataSource.getNewsArticles(
          apiKey: newsApiKey,
          country: 'us',
        ),
      ).called(1);
    });

    test('get saved articles', () async {
      when(
        () => mockArticleDao.getArticles(),
      ).thenAnswer(
        (_) async => (articleListDummyResponse['articles'] as List)
            .map((e) => ArticleModel.fromJson(e))
            .toList(),
      );

      final result = await articleRepository.getSavedArticles();

      expect(
          result,
          equals((articleListDummyResponse['articles'] as List)
              .map((e) => ArticleModel.fromJson(e))
              .toList()));
      verify(
        () => mockArticleDao.getArticles(),
      ).called(1);
    });

    test('remove saved article', () async {
      when(
        () => mockArticleDao.deleteArticle(
          ArticleModel.fromJson(articleListDummyResponse['articles'][0]),
        ),
      ).thenAnswer((_) async => {});

      await articleRepository.removeSavedArticle(
        ArticleModel.fromJson(articleListDummyResponse['articles'][0]),
      );

      verify(
        () => mockArticleDao.deleteArticle(
          ArticleModel.fromJson(articleListDummyResponse['articles'][0]),
        ),
      ).called(1);
    });
  });
}
