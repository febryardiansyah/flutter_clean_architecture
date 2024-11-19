import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/network/dio_client.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/models/article_model.dart';

abstract class NewsRemoteSource {
  Future<List<ArticleModel>> getNewsArticles({
    required String apiKey,
    required String country,
  });
}

class NewsRemoteSourceImpl implements NewsRemoteSource {
  final DioClient _dioClient;

  NewsRemoteSourceImpl(this._dioClient);

  @override
  Future<List<ArticleModel>> getNewsArticles({
    required String apiKey,
    required String country,
  }) async {
    final res = await _dioClient.get(
      '/top-headlines',
      queryParameters: {
        'apiKey': apiKey,
        'country': country,
      },
    );

    if (res.statusCode == 200) {
      final data = (res.data['articles'] as List)
          .map((e) => ArticleModel.fromJson(e))
          .toList();
      return data;
    } else {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
