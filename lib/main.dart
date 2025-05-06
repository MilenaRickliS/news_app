import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/models/news.dart';

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
      return const Center(child: CircularProgressIndicator());
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
