part of 'remote_article_bloc.dart';

sealed class RemoteArticleState extends Equatable {
  final List<ArticleEntity>? articles;
  final String? error;

  const RemoteArticleState({
    this.articles,
    this.error,
  });

  @override
  List<Object?> get props => [articles, error];
}

final class RemoteArticleInitial extends RemoteArticleState {}

final class RemoteArticleLoading extends RemoteArticleState {}

final class RemoteArticleSuccess extends RemoteArticleState {
  const RemoteArticleSuccess(List<ArticleEntity> articles)
      : super(articles: articles);
}

final class RemoteArticleError extends RemoteArticleState {
  const RemoteArticleError(String error) : super(error: error);
}
