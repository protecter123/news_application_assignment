import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_application_assignment/Models/article_model.dart';
import 'package:news_application_assignment/View/news_detail_view.dart';
import 'package:news_application_assignment/View/starred_article.dart';
import 'package:news_application_assignment/ViewController/news_controller.dart';
import 'package:shimmer/shimmer.dart';

class NewsListView extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Today\'s News'),
        actions: [
          Obx(
            () => AnimatedOpacity(
              opacity: controller.starredArticles.isEmpty ? 0.0 : 1.0,
              duration: Duration(milliseconds: 500),
              child: IconButton(
                icon:const Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                onPressed: () => Get.to(
                  () => StarredArticlesView(),
                  transition: Transition.cupertino,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(
              () => controller.isLoading.value && controller.displayedArticles.isEmpty
                  ? _buildShimmerEffect()
                  : _buildNewsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin:const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow:const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search news...',
          prefixIcon:const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    if (controller.filteredArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Icon(Icons.article_outlined, size: 50, color: Colors.grey),
           const SizedBox(height: 16),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'No articles found for "${controller.searchQuery.value}"'
                  : 'No articles available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!controller.isLoading.value &&
            controller.hasMoreData.value &&
            controller.searchQuery.isEmpty &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          controller.loadNextBatch();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        itemCount: controller.filteredArticles.length +
            (controller.hasMoreData.value && controller.searchQuery.isEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.filteredArticles.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final article = controller.filteredArticles[index];
          return _buildNewsCard(context, article, index);
        },
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, Article article, int index) {
    return Dismissible(
      key: Key(article.url ?? '$index'),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          controller.toggleStar(article);
          Get.snackbar(
            'Article Starred',
            'Article has been added to your favorites',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          controller.removeArticle(index);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          controller.toggleStar(article);
          return false;
        }
        return true;
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.amber,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.star, color: Colors.white),
      ),
      child: Hero(
        tag: article.url ?? '$index',
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () => Get.to(
              () => NewsDetailView(article: article),
              transition: Transition.fadeIn,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (article.urlToImage != null)
                    ClipRRect(
                      borderRadius:
                       const   BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        article.urlToImage!,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 190,
                          color: Colors.grey[300],
                          child:const Icon(Icons.error),
                        ),
                      ),
                    ),
                  Padding(
                    padding:const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                       const SizedBox(height: 8),
                        Text(
                          article.description ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const  SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              article.source?.name ?? '',
                              style:const TextStyle(color: Colors.grey),
                            ),
                            Obx(
                              () => Icon(
                                Icons.star,
                                color: controller.isStarred(article)
                                    ? Colors.amber
                                    : Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 44, 54, 250)!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Card(
          margin:const EdgeInsets.all(8),
          child: Container(
            height: 300,
            padding:const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  color: Colors.white,
                ),
               const SizedBox(height: 8),
                Container(
                  height: 20,
                  color: Colors.white,
                ),
               const SizedBox(height: 8),
                Container(
                  height: 20,
                  width: 200,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}