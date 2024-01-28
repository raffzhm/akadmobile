import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatkulUpdate extends StatefulWidget {
  final String? id; // Menggunakan id sebagai parameter
  final String? kodeMatkul;
  final String? namaMatkul;
  final int? sks;
  // final Function() fetchData;
  final Function() fetchDataDetail;

  const MatkulUpdate({Key? key,
    this.id,
    this.kodeMatkul,
    this.namaMatkul,
    this.sks,
    // required this.fetchData
    required this.fetchDataDetail
  }) : super(key: key);

  @override
  State<MatkulUpdate> createState() => _MatkulUpdateState();
}

class _MatkulUpdateState extends State<MatkulUpdate> {

  final TextEditingController _kodeMatkulController = TextEditingController();
  final TextEditingController _namaMatkulController = TextEditingController();
  final TextEditingController _sksMatkulController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _kodeMatkulController.text = widget.kodeMatkul ?? '';
    _namaMatkulController.text = widget.namaMatkul ?? '';
    _sksMatkulController.text = widget.sks?.toString() ?? '';
  }

  Future<void> _updateMatkul() async {
    final String url = 'http://10.0.2.2/toko-api/public/matkul/${widget.id}';

    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode({
        'kode_matkul': _kodeMatkulController.text,
        'nama_matkul': _namaMatkulController.text,
        'sks': int.parse(_sksMatkulController.text),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Data berhasil diperbarui
      // Tambahkan notifikasi atau tindakan lain yang sesuai
      // Membersihkan kontroller teks

      _kodeMatkulController.clear();
      _namaMatkulController.clear();
      _sksMatkulController.clear();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notifikasi'),
            content: const Text('Data berhasil diperbarui.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                },
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    } else {
      // Tangani kesalahan jika ada masalah dengan permintaan HTTP
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notifikasi'),
            content: const Text('Gagal memperbarui data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Matkul'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Kode Matkul", _kodeMatkulController),
            _buildTextField("Nama Matkul", _namaMatkulController),
            _buildTextField("Sks", _sksMatkulController),
            ElevatedButton(
              onPressed: () {
                _updateMatkul().then((_) {
                  widget.fetchDataDetail();
                  Navigator.pop(context);
                });
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
