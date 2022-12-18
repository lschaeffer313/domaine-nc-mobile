import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    var url = Uri(
        scheme: 'https',
        host: 'raw.githubusercontent.com',
        path: 'lschaeffer313/domaine-nc-mobile/main/CONTRIBUTORS.md');
    return Scaffold(
      appBar: AppBar(
        title: const Text("A propos"),
      ),
      body: FutureBuilder<Response>(
        future: http.get(url),
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.data != null) {
            return Markdown(
              data: snapshot.data!.body,
              onTapLink: (text, url, title) {
                launchUrl(
                  Uri.parse(url!),
                  mode: LaunchMode.externalApplication,
                );
              },
            );
          } else {
            return const Text("");
          }
        },
      ),
    );
  }
}
