import 'package:flutter_clean_architecture/core/resources/data_state.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  // remote
  Future<DataState<List<ArticleEntity>>> getArticles();

  // local
  Future<List<ArticleEntity>> getSavedArticles();
  Future<void> removeSavedArticle(ArticleEntity article);
  Future<void> saveArticle(ArticleEntity article);
}
