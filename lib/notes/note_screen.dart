import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/main.dart';
import 'package:todo/notes/new_note.dart';

import 'package:todo/providers/noteprovider.dart';
import 'package:todo/providers/dark_theme_provider.dart';

import 'package:todo/services/utils.dart';
import 'package:todo/notes/note_widget.dart';
import 'package:todo/widgets/maindrawer.dart';

class NoteScreen extends StatefulWidget {
  static const routeName = 'NoteScreen';
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController searchtext = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      noteProvider.loadNotes();
    });
  }

  @override
  void dispose() {
    searchtext.dispose();
    _searchTextFocusNode.dispose();
  }

  List<Note> searchlist = [];
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    List<Note> notesList = noteProvider.getNotes.values.toList();

    final themeState = Provider.of<DarkThemeProvider>(context);
    final theme = Utils(context).getTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          SizedBox(
            width: 250, // Adjust width if needed
            child: TextField(
              focusNode: _searchTextFocusNode,
              controller: searchtext,
              onChanged: (value) {
                setState(() {
                  searchlist = noteProvider.searchNotes(value);
                });
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      searchlist = noteProvider.searchNotes(searchtext.text);
                      searchtext.clear();
                      _searchTextFocusNode.unfocus();
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: _searchTextFocusNode.hasFocus
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const Maindrawer(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.8),
            child: Column(
              children: [
                if (searchtext.text.isNotEmpty && searchlist.isNotEmpty)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 0.6,
                    mainAxisSpacing: 0.6,
                    crossAxisCount: 2,
                    children: List.generate(
                      searchlist.length,
                      (index) {
                        return ChangeNotifierProvider.value(
                          value: searchlist[index],
                          child: const NoteWidget(),
                        );
                      },
                    ),
                  )
                else if (searchtext.text.isNotEmpty && searchlist.isEmpty)
                  const Center(
                    child: Text('No Notes'),
                  )
                else
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    crossAxisCount: 2,
                    children: List.generate(
                      notesList.length,
                      (index) {
                        return ChangeNotifierProvider.value(
                          value: notesList[index],
                          child: const NoteWidget(),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            top: 670,
            left: 260,
            child: FloatingActionButton(
              backgroundColor: kDarkColorScheme.secondary,
              foregroundColor: kColorScheme.surfaceBright,
              onPressed: () {
                showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (ctx) => NewNote());
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
