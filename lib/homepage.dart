import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:togethertask/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PaginationDemo();
  }
}

class PaginationDemo extends StatefulWidget {
  @override
  _PaginationDemoState createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<PaginationDemo> {
  final scrollController = ScrollController();
  List<dynamic> items = [];
  int page = 1;
  int limit = 10;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future referechData() async {
    setState(() {
      items.clear();
      page = 1;
      hasMore = true;
      isLoading = false;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    if (!hasMore || isLoading){ 
      return;}

    setState(() => isLoading = true);

   
    final url = 'https://api-stg.together.buzz/mocks/discovery?page=$page&limit=$limit';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> newItems = data['data'];
      setState(() {
        items.addAll(newItems);
        isLoading = false;
        page++;
        if (newItems.isEmpty) hasMore = false;
      });
    } else {
      setState(() => isLoading = false);
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Together Task'),
      ),
      body: RefreshIndicator(
        onRefresh: referechData,
        child: ListView.builder(
          controller: scrollController
            ..addListener(() {
              if (scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent) {
                fetchData();
              }
            }),
          padding: const EdgeInsets.all(12),
          itemCount: items.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < items.length) {
              return ItemWidget(title: items[index]['title'], image: items[index]['image_url'], desc: items[index]['description']);
            }
            else{
              //skeleton reloader 
              return const Center(
                child: Skeletonizer(child: 
                ItemWidget(title: "title", image: "image", desc: "desc")
              ));
            }
          },
        ),
      ),
    );
  }
}