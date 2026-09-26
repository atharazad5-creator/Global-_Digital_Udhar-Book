import 'package:flutter/material.dart';

void main() {
  runApp(const GlobalDigitalKhataApp());
}

class GlobalDigitalKhataApp extends StatelessWidget {
  const GlobalDigitalKhataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Digital Khata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Digital Khata'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'مینو',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('My Outlet'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Stock'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Sales Order'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),
          ],
        ),
      ),
      body: _selectedIndex == 1
          ? const StockScreen()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.inventory),
                    label: const Text('Stock Screen پر جائیں'),
                    onPressed: () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

// ==================== اسٹاک کا مکمل صفحہ (مع ایڈٹ اور ڈیلیٹ) ====================
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _stockItems = [];
  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _stockItems;
  }

  void _filterStock(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _stockItems;
      } else {
        _filteredItems = _stockItems.where((item) {
          final name = item['name'].toString().toLowerCase();
          final size = item['size'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower) || size.contains(searchLower);
        }).toList();
      }
    });
  }

  // نیا اسٹاک شامل کرنے یا پرانے کو ایڈٹ کرنے کا فنکشن
  void _showStockDialog({Map<String, dynamic>? itemToEdit, int? index}) {
    final nameController = TextEditingController(text: itemToEdit?['name'] ?? '');
    final sizeController = TextEditingController(text: itemToEdit?['size'] ?? '');
    final cartonRateController = TextEditingController(text: itemToEdit?['cartonRate'] ?? '');
    final cartonPackingController = TextEditingController(text: itemToEdit?['cartonPacking'] ?? '');
    final availCartonsController = TextEditingController(text: itemToEdit?['availCartons'] ?? '');
    final packetRateController = TextEditingController(text: itemToEdit?['packetRate'] ?? '');
    final pcsPerPacketController = TextEditingController(text: itemToEdit?['pcsPerPacket'] ?? '');
    final availPacketsController = TextEditingController(text: itemToEdit?['availPackets'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemToEdit == null ? 'نیا اسٹاک شامل کریں' : 'اسٹاک کی تفصیلات ایڈٹ کریں',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'پروڈکٹ کا نام (Product Name)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: sizeController,
                  decoration: const InputDecoration(
                    labelText: 'سائز (Size)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cartonRateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'کارٹن ریٹ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: cartonPackingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'کارٹن پیکنگ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: availCartonsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'دستیاب کارٹن (Available Cartons)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: packetRateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'پیکٹ ریٹ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: pcsPerPacketController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'پیکٹ میں پیسز',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: availPacketsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'دستیاب پیکٹ (Available Packets)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        setState(() {
                          final newItem = {
                            'name': nameController.text,
                            'size': sizeController.text,
                            'cartonRate': cartonRateController.text,
                            'cartonPacking': cartonPackingController.text,
                            'availCartons': availCartonsController.text,
                            'packetRate': packetRateController.text,
                            'pcsPerPacket': pcsPerPacketController.text,
                            'availPackets': availPacketsController.text,
                          };

                          if (itemToEdit == null) {
                            _stockItems.add(newItem);
                          } else if (index != null) {
                            _stockItems[index] = newItem;
                          }
                          _filterStock(_searchController.text);
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      itemToEdit == null ? 'سیو کریں (Save)' : 'اپ ڈیٹ کریں (Update)',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // سرچ بار اور وائس مائیک
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterStock,
              decoration: InputDecoration(
                hintText: 'پروڈکٹ کا نام یا ہندسہ تلاش کریں...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic, color: Colors.blueAccent),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('وائس سرچ جلد فعال کی جائے گی')),
                    );
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // اسٹاک آئٹمز کی لسٹ
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Text('کوئی اسٹاک موجود نہیں ہے، + پر کلک کر کے شامل کریں۔'),
                  )
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(
                            '${item['name']} (${item['size']})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'کارٹن: ${item['availCartons']} (ریٹ: ${item['cartonRate']}) | پیکٹ: ${item['availPackets']} (ریٹ: ${item['packetRate']})',
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.inventory_2, color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ایڈٹ کا بٹن
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {
                                  _showStockDialog(itemToEdit: item, index: index);
                                },
                              ),
                              // ڈیلیٹ کا بٹن
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _stockItems.removeAt(index);
                                    _filterStock(_searchController.text);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // پلس کا بٹن
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => _showStockDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
