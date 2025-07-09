import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Nilaipage extends StatefulWidget {
  const Nilaipage({Key? key}) : super(key: key);

  @override
  _NilaipageState createState() => _NilaipageState();
}

class _NilaipageState extends State<Nilaipage> {
  List<List<String>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    final rawData = await rootBundle.loadString('assets/data/nilai.csv');
    final lines = const LineSplitter().convert(rawData);
    final List<List<String>> csvData = lines
        .map((line) => line.split(','))
        .toList();

    setState(() {
      _data = csvData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tabel Nilai Mahasiswa'),
      ),
      body: _data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Supaya tabel bisa digeser
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: _data[0]
                      .map(
                        (header) => DataColumn(
                          label: Text(
                            header,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      .toList(),
                  rows: _data.sublist(1).map((row) {
                    return DataRow(
                      cells: row.map((cell) => DataCell(Text(cell))).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
