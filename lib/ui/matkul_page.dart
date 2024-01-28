import 'package:flutter/material.dart';
import 'matkul_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'matkul_form.dart';

class Matkul {
  final String id; // Ubah tipe data id menjadi String
  final String kodeMatkul;
  final String namaMatkul;
  final int sks;

  Matkul({
    required this.id, // Ubah tipe data id menjadi String
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.sks,
  });

  factory Matkul.fromJson(Map<String, dynamic> json) {
    return Matkul(
      id: json['id'],
      kodeMatkul: json['kode_matkul'],
      namaMatkul: json['nama_matkul'],
      sks: int.parse(json['sks']),
    );
  }
}

class MatkulPage extends StatefulWidget {
  const MatkulPage({Key? key}) : super(key: key);

  @override
  State<MatkulPage> createState() => _MatkulPageState();
}

class _MatkulPageState extends State<MatkulPage> {
  List<Matkul> matkulList = [];

  @override
  void initState() {
    super.initState();
    fetchDataPage();
  }

  Future<void> fetchDataPage() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/toko-api/public/matkul'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> matkuls = data['data'];

      setState(() {
        matkulList = matkuls.map((item) => Matkul.fromJson(item)).toList();
      });
    }
  }

  Future<void> deleteMatkul(String id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2/toko-api/public/matkul/$id'),
    );

    if (response.statusCode == 200) {
      fetchDataPage(); // Perbarui daftar setelah penghapusan berhasil
    } else {
// Tangani kesalahan jika penghapusan gagal
// ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Matkul'),
        actions: [
          GestureDetector(
            child: const Icon(Icons.add),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatkulForm(
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: matkulList.length,
        itemBuilder: (context, index) {
          final matkul = matkulList[index];
          return ItemMatkul(
            id: matkul.id,
            kodeMatkul: matkul.kodeMatkul,
            namaMatkul: matkul.namaMatkul,
            sks: matkul.sks,
            fetchDataPage: fetchDataPage,
            onDelete: () {
// Panggil fungsi penghapusan saat item dihapus
              deleteMatkul(matkul.id);
            },
          );
        },
      ),
    );
  }
}

class ItemMatkul extends StatelessWidget {
  final String id;
  final String kodeMatkul;
  final String namaMatkul;
  final int sks;
  final Function() fetchDataPage;
  final Function() onDelete;

  const ItemMatkul({
    Key? key,
    required this.id,
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.sks,
    required this.fetchDataPage,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text("$kodeMatkul - $namaMatkul"),
          subtitle: Text("$sks SKS"),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
// Tambahkan logika penghapusan di sini
              showDeleteConfirmationDialog(context);
            },
          ),
        ),
      ),
      onTap: () {
// fetchData();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatkulDetail(
              id: id,
              fetchDataPage: fetchDataPage,
              fetchDataDetail: () {},
            ),
          ),
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi Penghapusan'),
            content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  onDelete(); // Panggil fungsi onDelete untuk menghapus item
                  Navigator.of(context).pop();
                },
                child: const Text('Hapus'),
              ),
            ],
          );
        });
  }
}
