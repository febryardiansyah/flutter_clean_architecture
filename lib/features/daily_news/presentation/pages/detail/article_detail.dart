import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_clean_architecture/features/daily_news/presentation/bloc/local/local_bloc.dart';
import 'package:flutter_clean_architecture/injection_container.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocalArticleBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(article.title ?? 'No Title'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            sl<LocalArticleBloc>().add(SaveArticleEvent(article: article));
          },
          child: const Icon(Icons.bookmark),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title ?? 'No Title',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'By ${article.author}',
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              Text(
                article.content ?? 'No Content',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
