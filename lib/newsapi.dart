import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
// $ dart run build_runner build
part 'newsapi.g.dart';

@JsonSerializable()
class Article {
  final String title;
  final String? author, description, content;
  final Uri url;
  final Uri? urlToImage;
  final DateTime publishedAt;

  Article(
      {required this.title,
      this.author,
      this.description,
      required this.url,
      this.urlToImage,
      required this.publishedAt,
      this.content});

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}

Future<List<Article>> getArticles(BuildContext context) async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?language=${Localizations.localeOf(context).languageCode}&apiKey=010dfd3cd58b4d419cc7b577791cda4e'));
  final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
  if (responseJson['status'] != 'ok') {
    throw HttpException(responseJson['message']);
  }
  final List<dynamic> articlesJson = responseJson['articles'];
  return articlesJson.map((json) => Article.fromJson(json)).toList();
}
