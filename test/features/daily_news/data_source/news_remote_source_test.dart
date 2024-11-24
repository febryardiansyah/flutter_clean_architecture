import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/constants/constants.dart';
import 'package:flutter_clean_architecture/core/network/dio_client.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/data_sources/remote/news_remote_source.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_test.dart';

void main() {
  late MockDio mockDio;
  late DioClient dioClient;
  late NewsRemoteSourceImpl mockNewsRemoteSource;

  setUp(() {
    mockDio = MockDio();
    dioClient = DioClient(dio: mockDio);
    mockNewsRemoteSource = NewsRemoteSourceImpl(dioClient);
  });

  group('daily news remote source', () {
    final responseData = Response(
      requestOptions: RequestOptions(
        path: '/top-headlines',
        queryParameters: _params,
      ),
      statusCode: 200,
      data: _articles,
    );
    final responseEmptyData = Response(
      requestOptions: RequestOptions(
        path: '/top-headlines',
        queryParameters: _params,
      ),
      statusCode: 200,
      data: _emptyArticles,
    );

    test(
      'should return list of article model when the response code is 200',
      () async {
        when(
          () => mockDio.get('/top-headlines', queryParameters: _params),
        ).thenAnswer(
          (_) async => responseData,
        );

        final result = await mockNewsRemoteSource.getNewsArticles(
          apiKey: newsApiKey,
          country: 'us',
        );

        expect(result, isA<List<ArticleModel>>());
        expect(result.first.id, 1);

        verify(
          () => mockDio.get('/top-headlines', queryParameters: _params),
        ).called(1);
      },
    );

    test('should return empty article when response code is 200', () async {
      when(
        () => mockDio.get('/top-headlines', queryParameters: _params),
      ).thenAnswer(
        (_) async => responseEmptyData,
      );

      final result = await mockNewsRemoteSource.getNewsArticles(
        apiKey: newsApiKey,
        country: 'us',
      );

      expect(result, isEmpty);
      verify(
        () => mockDio.get('/top-headlines', queryParameters: _params),
      ).called(1);
    });

    test(
      'should throw DioException when response code is not 200',
      () async {
        when(
          () => mockDio.get('/top-headlines', queryParameters: _params),
        ).thenThrow(DioException(
          requestOptions: RequestOptions(
            path: '/top-headlines',
            queryParameters: _params,
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: '/top-headlines',
              queryParameters: _params,
            ),
            statusCode: 500,
          ),
        ));

        expect(
          () async => await mockNewsRemoteSource.getNewsArticles(
            apiKey: newsApiKey,
            country: 'us',
          ),
          throwsA(isA<DioException>()),
        );
        verify(
          () => mockDio.get('/top-headlines', queryParameters: _params),
        ).called(1);
      },
    );
  });
}

const _articles = {
  'articles': [
    {
      'id': 1,
      'author': 'author',
      'title': 'title',
      'description': 'description',
      'url': 'url',
      'urlToImage': 'urlToImage',
      'publishedAt': 'publishedAt',
      'content': 'content',
    }
  ]
};

const _emptyArticles = {'articles': []};
const _params = {
  'apiKey': newsApiKey,
  'country': 'us',
};
