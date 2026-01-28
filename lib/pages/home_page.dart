import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doa_anak/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  final bool kidMode;

  const HomePage({
    super.key,
    required this.kidMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool kidMode = true;
  String category = 'Semua';

  final categories = [
    'Semua',
    'Makan',
    'Tidur',
    'Rumah',
    'Belajar',
  ];

  IconData getIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('makan')) return Icons.restaurant;
    if (t.contains('tidur')) return Icons.bedtime;
    if (t.contains('rumah')) return Icons.home;
    if (t.contains('belajar')) return Icons.school;
    return Icons.menu_book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF81C784),
        title: const Text('Aplikasi Doa Anak-Anak'),
        actions: [
          IconButton(
            icon: const Icon(Icons.child_care),
            onPressed: () => setState(() => kidMode = !kidMode),
          ),
        ],
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF81C784), Color(0xFFA5D6A7)],
              ),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aplikasi Belajar Doa\nSehari-hari ',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Dengan suara & tampilan ramah anak',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // CHIP KATEGORI
          SizedBox(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: categories.map((c) {
                final active = category == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: active,
                    onSelected: (_) => setState(() => category = c),
                    selectedColor: const Color(0xFF81C784),
                    labelStyle: TextStyle(
                      color: active ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // LIST DOA
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('doa')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs.where((d) {
                  if (category == 'Semua') return true;

                  final data = d.data() as Map<String, dynamic>;
                  final doaKategori =
                      (data['kategori'] ?? '').toString().toLowerCase();

                  return doaKategori == category.toLowerCase();
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF81C784),
                          child: Icon(
                            getIcon(d['judul']),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          d['judul'],
                          style: TextStyle(
                            fontSize: kidMode ? 18 : 16,
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
                                kidMode: kidMode,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
