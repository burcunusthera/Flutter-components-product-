/// Günlük planım (Hatırlatıcılar) veri modelleri. Bileşenler veri üretmez (R-04);
/// değerler dışarıdan gelir.
library;

enum ReminderThumb { tablet, softgel, blister, vitaminTablet, activity, fallback }

enum ReminderItemState {
  planned,
  upcoming,
  due,
  overdue,
  noRecord,
  saving,
  taken,
  savingSkipped,
  skippedUndo,
  skipped,
  activityNotStarted,
  activityStarting,
  activityInProgress,
  activityPaused,
  activitySaving,
  activityCompleted,
  activityAbandoned,
  loading,
}

class ReminderItemData {
  const ReminderItemData({
    required this.id,
    required this.title,
    this.meta,
    required this.state,
    this.statusText,
    this.thumbnail,
  });

  final String id;
  final String title;
  final String? meta;
  final ReminderItemState state;
  final String? statusText;
  /// null → etkinlikse `activity`, değilse `tablet` (DS varsayılanı).
  final ReminderThumb? thumbnail;
}

/// DS ReminderCard durumları + App'teki mesaj kartları (offlineError, entError, emptyToday).
enum ReminderCardState { collapsed, expanded, allDone, loading, empty, noneToday, loadError, locked, offlineError, entError, emptyToday }

class ReminderData {
  const ReminderData({
    required this.state,
    this.summary,
    this.items = const [],
    this.nextText,
    this.offline = false,
  });

  final ReminderCardState state;
  final String? summary;
  final List<ReminderItemData> items;

  /// noneToday: “Sıradaki hatırlatıcı: …”
  final String? nextText;

  /// Çevrimdışı: yazma aksiyonları pasif (C2/C3).
  final bool offline;
}
