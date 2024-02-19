import 'package:flutter/material.dart';
import 'package:flutter_hw1/article_view.dart';
import 'package:flutter_hw1/newsapi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(const NewsApp());

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      title: 'News',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const News(),
    );
  }

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }
}

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  Future<List<Article>>? _articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_night_outlined),
            onPressed: () =>
                context.findAncestorStateOfType<_NewsAppState>()!.toggleTheme(),
            tooltip: AppLocalizations.of(context)!.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {
              _articles = getArticles(context);
            }),
            tooltip:
                MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
          ),
        ],
        title: Text(AppLocalizations.of(context)!.news),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Article>>(
          key: ObjectKey(_articles),
          future: _articles ??= getArticles(context),
          builder:
              (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            Widget body;
            if (snapshot.hasData) {
              body = buildArticlesList(context, snapshot.data!);
            } else if (snapshot.hasError) {
              body = Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                        '${AppLocalizations.of(context)!.error}: ${getErrorMessage(snapshot.error!)}'),
                  ),
                ],
              );
            } else {
              body = const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              );
            }
            return body;
          },
        ),
      ),
    );
  }
}

Widget buildArticlesList(BuildContext context, List<Article> list) {
  if (list.isEmpty) {
    return Text(AppLocalizations.of(context)!.noArticles);
  }
  return ListView(
      children: list
          .map((article) => ListTile(
                title: Text(article.title),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ArticleView(article: article)),
                ),
              ))
          .toList());
}

String getErrorMessage(Object error) {
  try {
    return (error as dynamic).message;
  } on Error {
    return error.toString();
  }
}
