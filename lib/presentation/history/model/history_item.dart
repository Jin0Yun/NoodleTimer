class HistoryItem {
  final String id;
  final String ramenId;
  final String name;
  final String imageUrl;
  final DateTime cookedAt;
  final Duration cookTime;
  final String noodleState;
  final String eggPreference;

  const HistoryItem({
    required this.id,
    required this.ramenId,
    required this.name,
    required this.imageUrl,
    required this.cookedAt,
    required this.cookTime,
    required this.noodleState,
    required this.eggPreference,
  });
}
