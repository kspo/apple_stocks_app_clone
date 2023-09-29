import 'package:flutter/material.dart';

class NewsCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String summary;

  const NewsCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      color: const Color.fromARGB(255, 45, 45, 45),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Resim
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Haber İçeriği
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Başlık
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  // Haber Özeti
                  Text(
                    summary,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
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
