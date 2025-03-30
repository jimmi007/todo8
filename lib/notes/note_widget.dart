import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/main.dart';
import 'package:todo/notes/note_details.dart';

import 'package:todo/providers/noteprovider.dart';
import 'package:todo/responsive.dart';
import 'package:todo/services/utils.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    final note = Provider.of<Note>(context);
    Size size = Utils(context).getScreenSize;
    final noteprovider = Provider.of<NoteProvider>(context);
    var inkWell = InkWell(
      onDoubleTap: () {
        noteprovider.removeNote(note.id);
        setState(() {
          // Trigger a rebuild after the state has been updated
        });
      },
      child: const Icon(
        Icons.delete,
        size: 22,
      ),
    );
    return InkWell(
      onTap: () {
        print('Navigating to details screen for ID: ${note.title}');
        Navigator.pushNamed(context, Notedetails.routeName, arguments: note.id);
      },
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Card(
                child: Responsive(
                  mobile: Container(
                    height: size.height * 0.17,
                    width: size.width * 0.40,
                    decoration: BoxDecoration(
                      border: Border.all(width: 7.0, color: Colors.black12),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            note.content,
                            style: Theme.of(context).textTheme.displaySmall,
                            overflow:
                                TextOverflow.ellipsis, // Truncates the text
                            maxLines: 5,
                          ),
                        ),
                        inkWell,
                      ],
                    ),
                  ),
                  desktop: Container(
                    height: size.height * 0.2,
                    width: size.width * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(width: 7.0, color: Colors.black12),
                      borderRadius: const BorderRadius.horizontal(),
                      color: kColorScheme.primaryContainer,
                    ),
                    child: Row(
                      children: [
                        Text(
                          note.title,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const InkWell(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
