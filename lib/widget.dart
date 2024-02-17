import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.desc});
  final title;
  final image;
  final desc;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Image.network(
              image,
              width: 80,
              height: 80,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  );
                }
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Text('Error loading image');
              },
            ),
            Expanded(
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                   overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(desc,  overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 10), ),
                ],
              ),
            ),
          ])),
    );
  }
}
