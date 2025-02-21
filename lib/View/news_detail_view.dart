import 'package:flutter/material.dart';

import 'package:news_application_assignment/Models/article_model.dart';

class NewsDetailView extends StatelessWidget {
  final Article article;

  const NewsDetailView({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: article.url ?? '',
                child: article.urlToImage != null
                    ? Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 100),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style:const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const  SizedBox(height: 8),
                  Text(
                    'By ${article.author ?? 'Unknown'} • ${article.source?.name ?? ''}',
                    style: TextStyle(color: Colors.grey),
                  ),
                const  SizedBox(height: 16),
                  Text(
                    article.description ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                const  SizedBox(height: 16),
                  Text(
                    article.content ?? '',
                    style:const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}