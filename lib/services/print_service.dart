
import 'package:blue_thermal_printer_plus/blue_thermal_printer_plus.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import '../models/transaksi.dart';

class PrintService {
  static final printer = BlueThermalPrinter.instance;

  static Future<void> printStruk(Transaksi t) async {
    final profile = await CapabilityProfile.load();
    final gen = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];
    bytes += gen.text('PERTAMINA', styles: PosStyles(bold: true, align: PosAlign.center));
    bytes += gen.text('SPBU HM. SULCHAN', align: PosAlign.center);
    bytes += gen.hr();
    bytes += gen.text('BBM     : ${t.bbm}');
    bytes += gen.text('Volume  : ${t.liter.toStringAsFixed(2)} L');
    bytes += gen.text('Total   : Rp ${t.total}');
    bytes += gen.hr();
    bytes += gen.text('CASH');
    bytes += gen.text('Plat: ${t.plat}');
    bytes += gen.hr();
    bytes += gen.text('Subsidi BBM dari Pemerintah', align: PosAlign.center);
    bytes += gen.cut();

    if (!(await printer.isConnected ?? false)) {
      final devices = await printer.getBondedDevices();
      if (devices.isNotEmpty) {
        await printer.connect(devices.first);
      }
    }
    printer.writeBytes(bytes);
  }
}
