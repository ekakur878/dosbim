import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Jadwal extends StatefulWidget {
  const Jadwal({super.key});

  @override
  _JadwalState createState() => _JadwalState();
}

class _JadwalState extends State<Jadwal> {
  List<List<String>> _data = [];
  List<List<String>> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCSV();
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCSV() async {
    final rawData = await rootBundle.loadString('assets/data/jadwal.csv');
    final lines = const LineSplitter().convert(rawData);
    final List<List<String>> csvData = lines
        .map((line) => line.split(','))
        .toList();

    final int columnCount = csvData[0].length;
    // Hapus baris yang kolomnya tidak sesuai dengan header
    csvData.removeWhere((row) => row.length != columnCount);

    setState(() {
      _data = csvData;
      _filteredData = csvData;
    });
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredData = _data);
    } else {
      setState(() {
        _filteredData = [
          _data[0], // header
          ..._data
              .sublist(1)
              .where(
                (row) => row.any((cell) => cell.toLowerCase().contains(query)),
              ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: _filteredData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari mata kuliah, dosen, atau hari...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFF6dd5ed),
                              ),
                              headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              dataTextStyle: const TextStyle(fontSize: 12),
                              columns: _filteredData[0]
                                  .map(
                                    (header) => DataColumn(label: Text(header)),
                                  )
                                  .toList(),
                              rows: _filteredData.length <= 1
                                  ? []
                                  : _filteredData.sublist(1).map((row) {
                                      final cells = List.generate(
                                        _filteredData[0].length,
                                        (index) => DataCell(
                                          Text(
                                            index < row.length
                                                ? row[index]
                                                : '',
                                          ),
                                        ),
                                      );
                                      return DataRow(cells: cells);
                                    }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
