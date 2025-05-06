import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NewsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NewsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Últimas Notícias')),
      body: _buildBody(newsProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newsProvider.fetchNews(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(NewsProvider provider) {
    if (provider.isLoading) {
      // return const Center(child: CircularProgressIndicator());
      return shimmerLoadingList();
    }
    if (provider.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => provider.fetchNews(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    if (provider.news.isEmpty) {
      return const Center(child: Text('Nenhuma notícia encontrada'));
    }
    return RefreshIndicator(
      onRefresh: () => provider.fetchNews(),
      child: ListView.builder(
        itemCount: provider.news.length,
        itemBuilder: (ctx, index) {
          final news = provider.news[index];
          return Card(
            child: ListTile(
              leading: Image.network(news.urlToImage, width: 50),
              title: Text(news.title),
              subtitle: Text(news.description),
            ),
          );
        },
      ),
    );
  }
}

Widget shimmerLoadingList() {
  return ListView.builder(
    itemCount: 6,
    itemBuilder: (_, __) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 50, height: 50, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10, color: Colors.white),
                  const SizedBox(height: 5),
                  Container(height: 10, width: 150, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
