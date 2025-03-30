import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/noteprovider.dart';
import 'package:todo/services/utils.dart';
import 'package:uuid/uuid.dart';

class NewNote extends StatefulWidget {
  static const routeName = 'NewNote';
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? errortext;

  @override
  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void submitnote() {
    var uuid = Uuid();
    final noteprovider = Provider.of<NoteProvider>(context, listen: false);
    if (contentController.text.trim().isEmpty ||
        contentController.text.length > 60 ||
        titleController.text.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ένα απο τα πεδία δεν έχουν συμπληρωθεί σωστά')),
      );
      return;
    }
    Note newnote = Note(
      id: uuid.v4(),
      content:
          contentController.text, // Corrected: title and content were swapped
      title: titleController.text,
      date: DateTime.now(),
    );

    noteprovider.addNote(newnote);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Σημειωση καταχωρήθηκε')),
    );

// Ensure notes are updated
  }

  @override
  Widget build(BuildContext context) {
    final noteprovider = Provider.of<NoteProvider>(context);
    Size size = Utils(context).getScreenSize;
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    return Scaffold(
      body: Card(
        elevation: 2.0,
        child: SizedBox(
          height: size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        submitnote();
                        noteprovider.loadNotes();
                        titleController.clear();
                        contentController.clear();
                      },
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
                TextField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Τίτλος',
                    border: const UnderlineInputBorder(),
                    errorText: errortext,
                    errorStyle: const TextStyle(color: Colors.red),
                    counterText: '',
                  ),
                  onChanged: (value) {
                    setState(() {
                      errortext = value.length > 10
                          ? 'Υπέρβαση όριου χαρακτήρων'
                          : null;
                    });
                  },
                ),
                const SizedBox(height: 4),
                Text(formattedDate),
                const SizedBox(height: 4),
                TextField(
                  controller: contentController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Περιγραφή',
                    border: const UnderlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      errortext = value.length > 60
                          ? 'Υπέρβαση όριου χαρακτήρων'
                          : null;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
