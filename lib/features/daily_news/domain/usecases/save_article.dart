import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class SaveArticleUsecase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _articleRepository;
  SaveArticleUsecase(this._articleRepository);

  @override
  Future<void> call({ArticleEntity? params}) {
    assert(params != null, 'params cannot be null');
    return _articleRepository.saveArticle(params!);
  }
}
