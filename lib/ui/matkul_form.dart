import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class MatkulForm extends StatefulWidget {
  const MatkulForm({Key? key}) : super(key: key);

  @override
  _MatkulFormState createState() => _MatkulFormState();
}

class _MatkulFormState extends State<MatkulForm> {
  final _kodeMatkulTextboxController = TextEditingController();
  final _namaMatkulTextboxController = TextEditingController();
  final _sksMatkulTextboxController = TextEditingController();

  late String _kodeMatkul = '';
  late String _namaMatkul = '';
  late String _sks = '';

  Future<String> _simpanData() async {
    const String url = 'http://10.0.2.2/toko-api/public/matkul';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'kode_matkul': _kodeMatkulTextboxController.text,
        'nama_matkul': _namaMatkulTextboxController.text,
        'sks': _sksMatkulTextboxController.text,
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw 'Failed to submit data.';
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Matkul'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _textboxKodeMatkul(),
            _textboxNamaMatkul(),
            _textboxSksMatkul(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _simpanData().then((id) {
                  _kodeMatkul = _kodeMatkulTextboxController.text;
                  _namaMatkul = _namaMatkulTextboxController.text;
                  _sks = _sksMatkulTextboxController.text;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        id: id,
                        kodeMatkul: _kodeMatkul,
                        namaMatkul: _namaMatkul,
                        sks: _sks,
                      ),
                    ),
                  );

                  _showNotification('Data berhasil dimasukkan.');
                }).catchError((error) {
                  _showNotification(error.toString());
                });
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textboxKodeMatkul() {
    return TextField(
      decoration: const InputDecoration(labelText: "Kode Matkul"),
      controller: _kodeMatkulTextboxController,
    );
  }

  Widget _textboxNamaMatkul() {
    return TextField(
      decoration: const InputDecoration(labelText: "Nama Matkul"),
      controller: _namaMatkulTextboxController,
    );
  }

  Widget _textboxSksMatkul() {
    return TextField(
      decoration: const InputDecoration(labelText: "Sks Matkul"),
      controller: _sksMatkulTextboxController,
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String? id;
  final String kodeMatkul;
  final String namaMatkul;
  final String sks;

  const ResultScreen({
    Key? key,
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.sks,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResult("Kode Matkul", kodeMatkul),
            _buildResult("Nama Matkul", namaMatkul),
            _buildResult("Sks", sks),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainApp(),
                  ),
                );
              },
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
