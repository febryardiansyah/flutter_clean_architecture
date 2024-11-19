import 'package:flutter_clean_architecture/core/network/dio_client.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/data_sources/remote/news_remote_source.dart';
import 'package:flutter_clean_architecture/features/daily_news/data/repositories/article_repository_impl.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:flutter_clean_architecture/features/daily_news/presentation/bloc/remote/remote_article_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/daily_news/data/data_sources/local/app_database.dart';

final sl = GetIt.instance;

Future<void> registerInjection() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);
  // dio
  sl.registerSingleton<DioClient>(DioClient());

  // dependencies
  sl.registerSingleton<NewsRemoteSource>(NewsRemoteSourceImpl(sl()));
  sl.registerSingleton<ArticleRepository>(ArticleRepostioryImpl(sl()));

  // usecases
  sl.registerSingleton<GetArticleUsecase>(GetArticleUsecase(sl()));

  // bloc
  sl.registerFactory<RemoteArticleBloc>(() => RemoteArticleBloc(sl()));
}
