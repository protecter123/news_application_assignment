// news_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_application_assignment/Models/article_model.dart';
import 'package:news_application_assignment/Services/api_service.dart';

class NewsController extends GetxController {
  final ApiService _apiService = ApiService();
  var allArticles = <Article>[].obs;
  var displayedArticles = <Article>[].obs;
  var filteredArticles = <Article>[].obs;
  var isLoading = true.obs;
  var hasMoreData = true.obs;
  var searchQuery = ''.obs;
  var starredArticles = <Article>[].obs;
  var isSearching = false.obs;
  
  static const int batchSize = 10;
  var currentBatchIndex = 0;

  @override
  void onInit() {
    super.onInit();
    fetchInitialNews();
  }

  Future<void> fetchInitialNews() async {
    try {
      isLoading(true);
      
      final response = await _apiService.fetchNews();
      final List<dynamic> articlesJson = response['articles'] ?? [];
      
      allArticles.value = articlesJson
          .map((json) => Article.fromJson(json))
          .toList();
      
      loadNextBatch();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load news articles',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void loadNextBatch() {
    if (!hasMoreData.value || isSearching.value) return;
    
    final start = currentBatchIndex * batchSize;
    final end = start + batchSize;
    
    if (start >= allArticles.length) {
      hasMoreData(false);
      return;
    }
    
    final nextBatch = allArticles.sublist(
      start,
      end > allArticles.length ? allArticles.length : end,
    );
    
    displayedArticles.addAll(nextBatch);
    filterArticles();
    
    currentBatchIndex++;
    hasMoreData(end < allArticles.length);
  }

  void filterArticles() {
    if (searchQuery.isEmpty) {
      filteredArticles.value = displayedArticles;
      isSearching(false);
    } else {
      isSearching(true);
      filteredArticles.value = allArticles
          .where((article) =>
              article.title?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false)
          .toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      isSearching(false);
      displayedArticles.clear();
      currentBatchIndex = 0;
      loadNextBatch();
    } else {
      isSearching(true);
      filteredArticles.value = allArticles
          .where((article) =>
              article.title?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    }
  }

  void removeArticle(int index) {
    final article = filteredArticles[index];
    allArticles.remove(article);
    displayedArticles.remove(article);
    filterArticles();
  }

  bool isStarred(Article article) {
    return starredArticles.any((a) => a.url == article.url);
  }

  void toggleStar(Article article) {
    final index = starredArticles.indexWhere((a) => a.url == article.url);
    if (index >= 0) {
      starredArticles.removeAt(index);
    } else {
      starredArticles.add(article);
    }
  }
  
}

// In your NewsListView, update the _buildNewsList method:
