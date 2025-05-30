class CouldStorageException implements Exception {
  const CouldStorageException();
}

// C en CRUD
class CouldNotCreateNoteException extends CouldStorageException {}

// R en CRUD
class CouldNotGetAllNotesException extends CouldStorageException {}

// U en CRUD
class CouldNotUpdateNoteException extends CouldStorageException {}

// D en CRUD
class CouldNotDeleteNoteException extends CouldStorageException {}
