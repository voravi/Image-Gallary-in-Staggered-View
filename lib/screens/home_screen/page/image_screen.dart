import 'package:flutter/material.dart';
import 'package:staggered_grid_view/screens/home_screen/page/home_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ImagePreviewScreen extends StatefulWidget {
  final int index;

  const ImagePreviewScreen({Key? key, required this.index}) : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Preview"),
        ),
        body: FutureBuilder(
          future: ImageAPIHelper.imageAPIHelper.fetchImageData(id: id!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              List<Images>? data = snapshot.data as List<Images>?;
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: "${data![widget.index].url}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Name : ${data[widget.index].name}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Twitter Name : ${data[widget.index].twitterUsername}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Download link : ",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final Uri launchUri = Uri(
                              scheme: "http",
                              path: data[widget.index].downloadLink,
                            );
                            await launchUrl(launchUri);
                          },
                          child: Text(
                            "\n${data[widget.index].downloadLink}",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            else {
              return const  Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
