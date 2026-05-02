// Path: lib/model/enum/sync_status.dart

/// Enum untuk merepresentasikan status sinkronisasi data.
enum SyncStatus {
  /// Data sudah sinkron dengan Firebase.
  synced,

  // Data untuk di tulis ulang di firebase
  write,

  /// Data dihapus secara lokal dan perlu dihapus di Firebase.
  deleted,
}
