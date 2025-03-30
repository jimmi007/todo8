import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/noteprovider.dart';

class Notedetails extends StatefulWidget {
  static const routeName = 'Notedetailsscreen';
  const Notedetails({super.key});

  @override
  State<Notedetails> createState() => _NotedetailsState();
}

class _NotedetailsState extends State<Notedetails> {
  late TextEditingController textedittitle;
  late TextEditingController texteditcontent;
  String? errortext;
  final now = DateTime.now();
  var existingNote;

  @override
  void initState() {
    super.initState();
    textedittitle = TextEditingController();
    texteditcontent = TextEditingController();

    // Delay initialization until after the build context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);

      final noteid = ModalRoute.of(context)!.settings.arguments as String;
      final getnotes = noteProvider.findNoteById(noteid);

      if (getnotes != null) {
        setState(() {
          existingNote = getnotes;
          textedittitle = TextEditingController(text: getnotes.title);
          texteditcontent = TextEditingController(text: getnotes.content);
        });
      }
    });
  }

  @override
  void dispose() {
    textedittitle.dispose();
    texteditcontent.dispose();
    super.dispose();
  }

  // Category conversion function (if needed)

  void _updateNote() {
    if (textedittitle.text.trim().isEmpty ||
        textedittitle.text.length > 10 ||
        texteditcontent.text.length > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ένα από τα πεδία δεν έχει συμπληρωθεί σωστά'),
        ),
      );
      return;
    }

    final updatedNote = Note(
      id: existingNote.id,
      title: textedittitle.text.trim(),
      content: texteditcontent.text.trim(),
      date: now,
    );

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    noteProvider.updateNote(existingNote.id, updatedNote);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Η σημείωση ενημερώθηκε με επιτυχία'),
      ),
    );

    // Delay navigation to allow SnackBar to be visible before popping
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Note Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Field
            TextField(
              controller: textedittitle,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Tίτλος',
                border: const UnderlineInputBorder(),
                errorText: errortext,
                errorStyle: const TextStyle(color: Colors.red),
                counterText: '',
              ),
              onChanged: (value) {
                setState(() {
                  errortext = textedittitle.text.length > 10
                      ? 'Υπέρβαση όριου χαρακτήρων'
                      : null;
                });
              },
            ),
            Text(
              existingNote.id,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 5),
            // Content Field
            TextField(
              controller: texteditcontent,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Περιγραφή',
                border: const UnderlineInputBorder(),
                errorText: errortext,
                errorStyle: const TextStyle(color: Colors.red),
              ),
              onChanged: (value) {
                setState(() {
                  errortext = texteditcontent.text.length > 60
                      ? 'Υπέρβαση όριου χαρακτήρων'
                      : null;
                });
              },
            ),
            const SizedBox(height: 20),
            // Update Button
            ElevatedButton(
              onPressed: () {
                _updateNote();
              },
              child: const Text('Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
