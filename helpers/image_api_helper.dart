import 'dart:convert';
import 'package:http/http.dart' as http;

import '../modals/image.dart';

class ImageAPIHelper {

  ImageAPIHelper._();

  static final ImageAPIHelper imageAPIHelper = ImageAPIHelper._();

  Future<List<Images>?> fetchImageData() async {
    http.Response response = await http.get(
      Uri.parse(
        "https://api.unsplash.com/photos/?client_id=VjZlYag5OWZkUxi7Hkz--8x9r7iE-io6IQqlJ8wYU94",
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> decodedData = jsonDecode(response.body);

      List<Images>? imageData =
          decodedData.map((e) => Images.fromMap(data: e)).toList();

      return imageData;
    }
    return null;
  }
}
