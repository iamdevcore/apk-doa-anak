class RewardService {
  /// 🔹 Badge dummy (bisa dikembangkan)
  static List<Map<String, dynamic>> getBadges() {
    return [
      {
        'title': 'Pemula',
        'desc': 'Membaca 1 doa',
        'unlocked': true,
      },
      {
        'title': 'Rajin',
        'desc': 'Membaca 5 doa',
        'unlocked': true,
      },
      {
        'title': 'Hebat',
        'desc': 'Membaca 10 doa',
        'unlocked': false,
      },
      {
        'title': 'Bintang Anak',
        'desc': 'Membaca doa setiap hari',
        'unlocked': false,
      },
    ];
  }
}
