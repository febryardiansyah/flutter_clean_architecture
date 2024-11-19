import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/daily_news/presentation/bloc/remote/remote_article_bloc.dart';
import 'package:flutter_clean_architecture/features/daily_news/presentation/pages/detail/article_detail.dart';
import 'package:flutter_clean_architecture/injection_container.dart';

class DailyNewsPage extends StatelessWidget {
  const DailyNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily News'),
      ),
      body: BlocProvider(
        create: (_) => sl<RemoteArticleBloc>()..add(const GetArticlesEvent()),
        child: BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
          builder: (context, state) {
            if (state is RemoteArticleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RemoteArticleError) {
              return Center(child: Text(state.error!));
            }
            if (state is RemoteArticleSuccess) {
              return ListView.builder(
                itemCount: state.articles!.length,
                itemBuilder: (context, index) {
                  final article = state.articles![index];

                  return ListTile(
                    title: Text(article.title ?? 'No Title'),
                    subtitle: Text(article.content ?? 'No Content'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetail(article: article),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
