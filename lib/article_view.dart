import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'newsapi.dart';

class ArticleView extends StatefulWidget {
  final Article article;

  const ArticleView({super.key, required this.article});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.author ?? ""),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.article.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            widget.article.description != null
                ? Text(widget.article.description!)
                : null,
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                  text: widget.article.url.toString(),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async => await launchUrl(
                          widget.article.url,
                          mode: LaunchMode.inAppBrowserView,
                        )),
            ),
            widget.article.urlToImage != null
                ? Image.network(
                    widget.article.urlToImage.toString(),
                  )
                : null,
            Text(widget.article.publishedAt.toString()),
            widget.article.content != null
                ? Text(widget.article.content!)
                : null,
          ].nonNulls.toList(),
        ),
      ),
    );
  }
}
