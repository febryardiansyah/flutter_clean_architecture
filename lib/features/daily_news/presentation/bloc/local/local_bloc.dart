import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/usecases/get_saved_article.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/usecases/remove_article.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/usecases/save_article.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalArticleBloc extends Bloc<LocalArticleEvent, LocalArticleState> {
  final GetSavedArticleUsecase _getSavedArticleUsecase;
  final SaveArticleUsecase _saveArticleUsecase;
  final RemoveArticleUsecase _removeArticleUsecase;

  LocalArticleBloc(
    this._getSavedArticleUsecase,
    this._saveArticleUsecase,
    this._removeArticleUsecase,
  ) : super(LocalArticleInitial()) {
    on<GetSavedArticlesEvent>(_fetchSavedArticles);
    on<SaveArticleEvent>(_onSaveArticle);
    on<RemoveSavedArticleEvent>(_onRemoveArticle);
  }

  void _fetchSavedArticles(
    GetSavedArticlesEvent event,
    Emitter<LocalArticleState> emit,
  ) async {
    emit(LocalArticleLoading());

    final result = await _getSavedArticleUsecase.call();
    emit(LocalArticleLoaded(articles: result));
  }

  void _onSaveArticle(
    SaveArticleEvent event,
    Emitter<LocalArticleState> emit,
  ) async {
    await _saveArticleUsecase.call(params: event.article);
    final result = await _getSavedArticleUsecase.call();
    emit(LocalArticleLoaded(articles: result));
  }

  void _onRemoveArticle(
    RemoveSavedArticleEvent event,
    Emitter<LocalArticleState> emit,
  ) async {
    await _removeArticleUsecase.call(params: event.article);
    final result = await _getSavedArticleUsecase.call();
    emit(LocalArticleLoaded(articles: result));
  }
}
