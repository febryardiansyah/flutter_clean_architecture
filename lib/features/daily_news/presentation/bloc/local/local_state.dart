part of 'local_bloc.dart';

sealed class LocalArticleState extends Equatable {
  final List<ArticleEntity>? articles;
  const LocalArticleState({this.articles});

  @override
  List<Object?> get props => [articles];
}

final class LocalArticleInitial extends LocalArticleState {}

final class LocalArticleLoading extends LocalArticleState {}

final class LocalArticleLoaded extends LocalArticleState {
  const LocalArticleLoaded({required List<ArticleEntity> articles})
      : super(articles: articles);
}
