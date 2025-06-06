// import 'dart:async';
// import 'package:notesbycj/extensions/list/filter.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
// import 'package:notesbycj/services/crud/crud_exeptions.dart';

// class NotesService {
//   Database? _db;

//   List<DatabaseNote> _notes = [];

//   DatabaseUser? _user;

//   static final NotesService _shared = NotesService._sharedInstance();

//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;

//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   Stream<List<DatabaseNote>> get allNotes =>
//       _notesStreamController.stream.localFilter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotesException();
//         }
//       });

//   // Utilisateur

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (result.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DatabaseUser(id: userId, email: email);
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (result.isEmpty) {
//       throw CouldNotFindUserException();
//     }
//     return DatabaseUser.fromRow(result.first);
//   }

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUserException {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   // Notes

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();

//     // S'assurer que l'utilisateur existe
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUserException();
//     }

//     const text = '';
//     // Créer la note
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });

//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );

//     _notes.add(note);
//     _notesStreamController.add(_notes);

//     return note;
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(noteTable);

//     return notes.map((note) => DatabaseNote.fromRow(note));
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNoteException();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();

//     // S'assurer que la note existe
//     await getNote(id: note.id);

//     // Mettre à jour la note
//     final updatedNote = await db.update(
//       noteTable,
//       {textColumn: text, isSyncedWithCloudColumn: 0},
//       where: 'id= ?',
//       whereArgs: [note.id],
//     );

//     if (updatedNote == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updateNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updateNote.id);
//       _notes.add(updateNote);
//       _notesStreamController.add(_notes);
//       return updateNote;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletedNotes = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletedNotes;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDatabaseIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedNote = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedNote == 0) {
//       throw CouldNotDeleteNoteException();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<void> _cachesNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   // Autres

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpenException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensureDatabaseIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       // Creation de la table utilisateur
//       await db.execute(createUserTable);
//       // Création de la table note
//       await db.execute(createNoteTable);
//       await _cachesNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectoryException();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({required this.id, required this.email});

//   DatabaseUser.fromRow(Map<String, Object?> map)
//     : id = map[idColumn] as int,
//       email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID=$id, email=$email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   const DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });

//   DatabaseNote.fromRow(Map<String, Object?> map)
//     : id = map[idColumn] as int,
//       userId = map[userIdColumn] as int,
//       text = map[textColumn] as String,
//       isSyncedWithCloud =
//           map[isSyncedWithCloudColumn] as int == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note, ID=$id, userId=$userId, text=$text, isSyncedWithCloud=$isSyncedWithCloud';

//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'notesbycj.db';
// const noteTable = 'note';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
// 	      "id"	INTEGER NOT NULL,
// 	      "email"	TEXT NOT NULL UNIQUE,
// 	      PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
//       "user_id"	INTEGER NOT NULL,
//       "id"	INTEGER NOT NULL,
//       "text"	TEXT,
//       "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//       PRIMARY KEY("id" AUTOINCREMENT),
//       FOREIGN KEY("user_id") REFERENCES "user"("id")
//     );''';
