class News {
  final String title;
  final String description;
  final String urlToImage;

  News({
    required this.title,
    required this.description,
    required this.urlToImage,
  });
  
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'Sem título',
      description: json['description'] ?? 'Sem descrição',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
    );
  }
}
