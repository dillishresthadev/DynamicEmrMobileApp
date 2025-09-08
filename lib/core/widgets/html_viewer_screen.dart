import 'package:dynamic_emr/core/widgets/appbar/dynamic_emr_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';

class HtmlViewerScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const HtmlViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
  });

  Future<String> loadHtmlFromAssets() async {
    return await rootBundle.loadString(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DynamicEMRAppBar(title: title, automaticallyImplyLeading: true),
      body: FutureBuilder<String>(
        future: loadHtmlFromAssets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading HTML'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Html(data: snapshot.data),
              ),
            );
          }
        },
      ),
    );
  }
}
