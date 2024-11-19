import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/core/resources/data_state.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/usecases/get_article.dart';

part 'remote_article_event.dart';
part 'remote_article_state.dart';

class RemoteArticleBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetArticleUsecase _getArticleUsecase;

  RemoteArticleBloc(this._getArticleUsecase) : super(RemoteArticleInitial()) {
    on<GetArticlesEvent>(_onGetArticles);
  }

  void _onGetArticles(
    RemoteArticleEvent event,
    Emitter<RemoteArticleState> emit,
  ) async {
    emit(RemoteArticleLoading());
    try {
      final dataSate = await _getArticleUsecase.call();

      if (dataSate is DataSuccess) {
        emit(
          RemoteArticleSuccess(dataSate.data!),
        );
      } else if (dataSate is DataFailed) {
        emit(RemoteArticleError(dataSate.error!.message!));
      }
    } catch (e) {
      emit(RemoteArticleError(e.toString()));
    }
  }
}
