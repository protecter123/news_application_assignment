import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:news_application_assignment/Models/article_model.dart';
import 'package:news_application_assignment/ViewController/news_controller.dart';

class StarredArticlesView extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Starred Articles'),
        elevation: 0,
      ),
      body: Obx(
        () => AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: controller.starredArticles.isEmpty
              ? Center(
                  child: Text(
                    'No starred articles yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: controller.starredArticles.length,
                  itemBuilder: (context, index) {
                    final article = controller.starredArticles[index];
                    return _buildStarredArticleCard(article, context);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildStarredArticleCard(Article article, BuildContext context) {
    return AnimatedOpacity(
      duration:const Duration(milliseconds: 300),
      opacity: 1.0,
      child: Card(
        margin:const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          contentPadding:const EdgeInsets.all(16),
          leading: article.urlToImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article.urlToImage!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          title: Text(
            article.title ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: IconButton(
            icon:const Icon(Icons.star, color: Colors.amber),
            onPressed: () => controller.toggleStar(article),
          ),
        ),
      ),
    );
  }
}