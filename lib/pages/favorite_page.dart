import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  final bool kidMode;

  const FavoritePage({
    super.key,
    required this.kidMode,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Set<String> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      favoriteIds = prefs
          .getKeys()
          .where((k) => prefs.getBool(k) == true)
          .toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⭐ Doa Favorit Kalian'),
        backgroundColor: Colors.green,
      ),
      body: favoriteIds.isEmpty
          ? const Center(
              child: Text(
                'Belum ada doa favorit Kalian ⭐',
                style: TextStyle(fontSize: 16),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('doa')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Doa favorit tidak ditemukan'),
                  );
                }

                final docs = snapshot.data!.docs
                    .where((d) => favoriteIds.contains(d.id))
                    .toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Doa favorit Kalian tidak ditemukan'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.star, color: Colors.yellow),
                        ),
                        title: Text(
                          d['judul'],
                          style: TextStyle(
                            fontSize: widget.kidMode ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text('Ketuk untuk membaca'),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                data: d,
                                kidMode: widget.kidMode,
                              ),
                            ),
                          ).then((_) => _loadFavorites());
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
