
import 'package:flutter/material.dart';
import '../services/hitung_service.dart';
import '../services/print_service.dart';
import '../models/transaksi.dart';
import 'package:intl/intl.dart';

class PomPage extends StatefulWidget {
  const PomPage({super.key});
  @override
  State<PomPage> createState() => _PomPageState();
}

class _PomPageState extends State<PomPage> {
  final nominalCtrl = TextEditingController();
  final bayarCtrl = TextEditingController();
  final platCtrl = TextEditingController();

  double harga = 10000;
  double liter = 0;
  double kembali = 0;

  void proses() async {
    final nominal = double.tryParse(nominalCtrl.text) ?? 0;
    final bayar = double.tryParse(bayarCtrl.text) ?? 0;
    liter = HitungService.liter(nominal, harga);
    kembali = HitungService.kembali(bayar, nominal);

    final t = Transaksi(
      noTrans: DateTime.now().millisecondsSinceEpoch,
      operator: 'OPERATOR',
      bbm: 'PERTALITE',
      harga: harga,
      liter: liter,
      total: nominal,
      plat: platCtrl.text,
      waktu: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
    );

    await PrintService.printStruk(t);

    nominalCtrl.clear();
    bayarCtrl.clear();
    platCtrl.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POM')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            TextField(controller: nominalCtrl, decoration: const InputDecoration(labelText: 'Jumlah Beli'), keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            Text('Liter: ${liter.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            TextField(controller: bayarCtrl, decoration: const InputDecoration(labelText: 'Jumlah Bayar'), keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            TextField(controller: platCtrl, decoration: const InputDecoration(labelText: 'Plat Nomor')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: proses, child: const Text('SIMPAN & CETAK')),
          ],
        ),
      ),
    );
  }
}
