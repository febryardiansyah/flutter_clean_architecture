part of 'local_bloc.dart';

sealed class LocalArticleEvent extends Equatable {
  final ArticleEntity? article;
  const LocalArticleEvent({this.article});

  @override
  List<Object?> get props => [article];
}

class GetSavedArticlesEvent extends LocalArticleEvent {}

class SaveArticleEvent extends LocalArticleEvent {
  const SaveArticleEvent({required ArticleEntity article})
      : super(article: article);
}

class RemoveSavedArticleEvent extends LocalArticleEvent {
  const RemoveSavedArticleEvent({required ArticleEntity article})
      : super(article: article);
}
