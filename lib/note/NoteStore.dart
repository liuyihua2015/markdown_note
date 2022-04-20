import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/note.dart';

enum NoteOperationRet { SUCCESS, NoteIsAlreadyExist, NoteIsNotExisted }

class NoteStore extends StatefulWidget {
  final Widget child;

  const NoteStore(this.child);

  @override
  State<NoteStore> createState() => _NoteStoreState();

  //getState
  static _NoteStoreState _getState(BuildContext context) {
    final _NoteStoreScope? _noteStoreScope =
        context.dependOnInheritedWidgetOfExactType<_NoteStoreScope>();
    return _noteStoreScope!._noteStoreState;
  }

  //get notes
  static List<Note> notes(BuildContext context) {
    return _getState(context).notes.values.toList();
  }

  // async create note by Note model return NoteOperationRet
  static Future<NoteOperationRet> createNote(
      BuildContext context, Note note) async {
    return _getState(context).createNewNote(note);
  }

// async update note by Note model return NoteOperationRet
  static Future<NoteOperationRet> updateNote(
      BuildContext context, Note note) async {
    return _getState(context).updateExistedNote(note);
  }

// async remove by Note model return NoteOperationRet
  static Future<NoteOperationRet> removeNote(
      BuildContext context, Note note) async {
    return _getState(context).removeExistedNote(note);
  }
}

class _NoteStoreState extends State<NoteStore> {
  late Map<String, Note> notes = <String, Note>{};

  //get all notes from shared_preferences return Map<String, Note>
  Future<Map<String, Note>?> _getAllNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic>? notesJson =
        json.decode(prefs.getString('notes') ?? '{}');
    return notesJson?.map<String, Note>((String key, dynamic value) {
      return MapEntry<String, Note>(key, Note.fromJson(value));
    });
  }

  @override
  initState() {
    super.initState();
    Future<Map<String, Note>?> t_notes = _getAllNotes();
    t_notes.then((Map<String, Note>? notes) {
      setState(() {
        this.notes = notes ?? <String, Note>{};
      });
    });
  }

  // create new note by note return NoteOperationRet
  Future<NoteOperationRet> createNewNote(Note note) async {
    if (notes.containsKey(note.uuid)) {
      return NoteOperationRet.NoteIsAlreadyExist;
    }
    await _saveNoteToDisk(note);
    setState(() {
      notes[note.uuid] = note;
    });
    _saveAllNoteToDisk();
    return NoteOperationRet.SUCCESS;
  }

  // update note by note return NoteOperationRet
  Future<NoteOperationRet> updateExistedNote(Note note) async {
    if (!notes.containsKey(note.uuid)) {
      return NoteOperationRet.NoteIsNotExisted;
    }
    await _saveNoteToDisk(note);
    setState(() {
      notes[note.uuid] = note;
    });
    _saveAllNoteToDisk();
    return NoteOperationRet.SUCCESS;
  }

  //remove note by note return NoteOperationRet
  Future<NoteOperationRet> removeExistedNote(Note note) async {
    if (!notes.containsKey(note.uuid)) {
      return NoteOperationRet.NoteIsNotExisted;
    }
    await _removeNoteFromDisk(note);
    setState(() {
      notes.remove(note.uuid);
    });
    _saveAllNoteToDisk();
    return NoteOperationRet.SUCCESS;
  }

  //save Note To Disk
  Future<void> _saveNoteToDisk(Note note) async {
    debugPrint("_saveNoteToDisk");
    SharedPreferences pres = await SharedPreferences.getInstance();
    pres.setString(note.uuid, json.encode(note.toJson()));
  }

  //save allNote To Disk
  Future<void> _saveAllNoteToDisk() async {
    debugPrint("_saveAllNoteToDisk");
    SharedPreferences pres = await SharedPreferences.getInstance();
    final Map<String, dynamic> notesMap = notes.map((String key, Note value) {
      return MapEntry(key, value.toJson());
    });
    final String notesJson = json.encode(notesMap);
    await pres.setString('notes', notesJson);
  }

  //remove Note From Disk
  Future<void> _removeNoteFromDisk(Note note) async {
    debugPrint("_removeNoteFromDisk");
    SharedPreferences pres = await SharedPreferences.getInstance();
    pres.remove(note.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return _NoteStoreScope(this, widget.child);
  }
}

class _NoteStoreScope extends InheritedWidget {
  final _NoteStoreState _noteStoreState;

  const _NoteStoreScope(this._noteStoreState, Widget child)
      : super(child: child);

  @override
  bool updateShouldNotify(_NoteStoreScope old) {
    return true;
  }
}
