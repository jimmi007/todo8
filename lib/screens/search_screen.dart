import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchTextController;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    focusNode = FocusNode();
  }

  List<String> searchlist = [];
  bool isSearching = false;

  void dispose() {
    if (mounted) {
      _searchTextController.dispose();
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          GestureDetector(
            onTap: () {
              focusNode.unfocus();
              Navigator.pop(context);
            },
            child: const Icon(Icons.ads_click),
          ),
          Flexible(
              child: TextField(
            focusNode: focusNode,
            controller: _searchTextController,
            style: TextStyle(),
            autofocus: true,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            onEditingComplete: () async {
              isSearching = true;
              focusNode.unfocus();
              setState(() {});
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                bottom: 8 / 5,
              ),
              hintText: "Search",
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    _searchTextController.clear();
                    focusNode.unfocus();
                    isSearching = false;
                    // searchList =[];
                    searchlist.clear();
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
