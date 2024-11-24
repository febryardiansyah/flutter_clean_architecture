import 'package:flutter_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:flutter_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/json_reader.dart';

void main() {
  group('ArticleModel test', () {
    const articleData = ArticleModel(
      id: 1,
      title: 'title',
      description: 'description',
      url: 'url',
      urlToImage: 'urlToImage',
      publishedAt: 'publishedAt',
      content: 'content',
      author: 'author',
    );

    test('should be a subclass of ArticleEntity', () {
      expect(articleData, isA<ArticleEntity>());
    });

    test('should return a valid model from json', () {
      final result = ArticleModel.fromJson(
        articleListDummyResponse['articles'][0],
      );

      expect(result, equals(articleData));
    });

    test('should return a valid model from entity', () {
      final result = ArticleModel.fromEntity(articleData);

      expect(result, equals(articleData));
    });

    test('should return a valid model to entity', () {
      final result = articleData.toEntity();

      expect(
        result,
        equals(const ArticleEntity(
          id: 1,
          title: 'title',
          description: 'description',
          url: 'url',
          urlToImage: 'urlToImage',
          publishedAt: 'publishedAt',
          content: 'content',
          author: 'author',
        )),
      );
    });
  });
}
