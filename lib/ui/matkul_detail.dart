import 'package:flutter/material.dart';
import 'matkul_update.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatkulDetail extends StatefulWidget {
  final String id; // Menggunakan id sebagai parameter
  final Function() fetchDataPage;
  final Function() fetchDataDetail;

  const MatkulDetail({
    Key? key,
    required this.id,
    required this.fetchDataPage,
    required this.fetchDataDetail,
  }) : super(key: key);

  @override
  State<MatkulDetail> createState() => _MatkulDetailState();
}

class _MatkulDetailState extends State<MatkulDetail> {
  String? kodeMatkul;
  String? namaMatkul;
  int? sks;

  @override
  void initState() {
    super.initState();
    fetchDataDetail();
  }

  Future<void> fetchDataDetail() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/toko-api/public/matkul/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final sksValue = data['data']['sks'];

      if (sksValue != null) {
        setState(() {
          kodeMatkul = data['data']['kode_matkul'];
          namaMatkul = data['data']['nama_matkul'];
          sks = int.tryParse(sksValue) ?? 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Matkul'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailColumn("Kode Matkul", kodeMatkul),
            _buildDetailColumn("Nama Matkul", namaMatkul),
            _buildDetailColumn("Sks", sks?.toString()),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatkulUpdate(
                      id: widget.id,
                      kodeMatkul: kodeMatkul,
                      namaMatkul: namaMatkul,
                      sks: sks,
                      fetchDataDetail: widget.fetchDataDetail,
                    ),
                  ),
                ).then((_) {
                  widget.fetchDataPage();
                  fetchDataDetail();
                });
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
            content ?? 'N/A',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
