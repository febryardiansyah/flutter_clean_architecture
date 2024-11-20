import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/daily_news/presentation/bloc/local/local_bloc.dart';
import 'package:flutter_clean_architecture/features/daily_news/presentation/pages/detail/article_detail.dart';
import 'package:flutter_clean_architecture/injection_container.dart';

class SavedArticlePage extends StatelessWidget {
  const SavedArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocalArticleBloc>()..add(GetSavedArticlesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved Articles'),
        ),
        body: BlocBuilder<LocalArticleBloc, LocalArticleState>(
          builder: (context, state) {
            if (state is LocalArticleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LocalArticleLoaded) {
              return ListView.builder(
                itemCount: state.articles!.length,
                itemBuilder: (context, index) {
                  final article = state.articles![index];
                  return ListTile(
                    title: Text(article.title ?? 'No Title'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<LocalArticleBloc>()
                            .add(RemoveSavedArticleEvent(article: article));
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailPage(article: article),
                      ),
                    ),
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

void main() {
  runApp(MaterialApp(
    home: SavedArticlePage(),
  ));
}
