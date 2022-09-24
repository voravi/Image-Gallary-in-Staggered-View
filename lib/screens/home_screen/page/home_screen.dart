import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:staggered_grid_view/screens/home_screen/page/image_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

  int? id;
class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Staggered View",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                id = (id! + 1);
              });
            },
            icon: Icon(Icons.refresh),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: FutureBuilder(
        future: ImageAPIHelper.imageAPIHelper.fetchImageData(id: id!),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            List<Images>? data = snapShot.data as List<Images>?;
            return MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: 30,
              itemBuilder: (context, index) {
                return index.isEven
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            //.....
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImagePreviewScreen(
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: "${data![index].url}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            //.......
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImagePreviewScreen(
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: "${data![index].url}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ImageAPIHelper {
  ImageAPIHelper._();

  static final ImageAPIHelper imageAPIHelper = ImageAPIHelper._();

  Future<List<Images>?> fetchImageData({required int id}) async {
    http.Response response = await http.get(
      Uri.parse(
        "https://api.unsplash.com/photos?per_page=400&page=$id&client_id=VjZlYag5OWZkUxi7Hkz--8x9r7iE-io6IQqlJ8wYU94",
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

class Images {
  final String? name;
  final String? url;
  final String? twitterUsername;
  final String? downloadLink;

  Images({
    required this.name,
    required this.url,
    required this.downloadLink,
    required this.twitterUsername,
  });

  factory Images.fromMap({required Map data}) {
    return Images(
      name: data["user"]["name"],
      url: data["urls"]["full"],
      downloadLink: data["links"]["download"],
      twitterUsername: data["user"]["twitter_username"],
    );
  }
}
