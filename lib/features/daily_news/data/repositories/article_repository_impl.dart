import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/constants/constants.dart';
import 'package:flutter_clean_architecture/core/resources/data_state.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/data_sources/remote/news_remote_source.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class ArticleRepostioryImpl implements ArticleRepository {
  final NewsRemoteSource _newsApiService;
  final AppDatabase _appDatabase;
  
  const ArticleRepostioryImpl(this._newsApiService, this._appDatabase);

  @override
  Future<DataState<List<ArticleEntity>>> getArticles() async {
    try {
      final data = await _newsApiService.getNewsArticles(
        apiKey: newsApiKey,
        country: 'us',
      );

      return DataSuccess(data.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() {
    return _appDatabase.articleDao.getArticles();
  }

  @override
  Future<void> removeSavedArticle(ArticleEntity article) {
    return _appDatabase.articleDao
        .deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDatabase.articleDao
        .insertArticle(ArticleModel.fromEntity(article));
  }
}
