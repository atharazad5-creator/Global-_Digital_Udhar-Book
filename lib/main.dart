import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MainDashboardScreen(),
    );
  }
}

// ---------------------------------------------------------
// 1. MAIN MENU DASHBOARD (3 MAIN STEPS)
// ---------------------------------------------------------
class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Digital Khata', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // STEP 1: MY OUTLET
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.store, color: Colors.white, size: 28),
              label: const Text('1. My Outlet', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOutletScreen()));
              },
            ),
            const SizedBox(height: 20),

            // STEP 2: STOCK / PRODUCTS
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.inventory, color: Colors.white, size: 28),
              label: const Text('2. Stock / Products', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StockProductScreen()));
              },
            ),
            const SizedBox(height: 20),

            // STEP 3: DAILY SALE ORDER
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.receipt_long, color: Colors.white, size: 28),
              label: const Text('3. Daily Sale Order', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DailySaleOrderScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. MY OUTLET SCREEN
// ---------------------------------------------------------
class MyOutletScreen extends StatefulWidget {
  const MyOutletScreen({super.key});

  @override
  State<MyOutletScreen> createState() => _MyOutletScreenState();
}

class _MyOutletScreenState extends State<MyOutletScreen> {
  List<Map<String, String>> outlets = [];
  List<Map<String, String>> filteredOutlets = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredOutlets = outlets;
  }

  void _filterOutlets(String query) {
    setState(() {
      filteredOutlets = outlets
          .where((outlet) =>
              outlet['shopName']!.toLowerCase().contains(query.toLowerCase()) ||
              outlet['ownerName']!.toLowerCase().contains(query.toLowerCase()) ||
              outlet['city']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToAddOutlet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOutletDetailScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        outlets.add(result);
        filteredOutlets = List.from(outlets);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Outlets', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterOutlets,
              decoration: InputDecoration(
                hintText: 'Search Shop, Owner or City...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: filteredOutlets.isEmpty
                ? const Center(child: Text('No Outlet Found. Click + to Add Shop.'))
                : ListView.builder(
                    itemCount: filteredOutlets.length,
                    itemBuilder: (context, index) {
                      final item = filteredOutlets[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.indigo,
                            child: Icon(Icons.store, color: Colors.white),
                          ),
                          title: Text(item['shopName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Owner: ${item['ownerName']} | WA: ${item['whatsapp']}\n'
                            '${item['street']}, ${item['area']}, ${item['city']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OutletOptionMenuScreen(outletData: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _navigateToAddOutlet,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

// 6 FIELDS ADD OUTLET FORM
class AddOutletDetailScreen extends StatefulWidget {
  const AddOutletDetailScreen({super.key});

  @override
  State<AddOutletDetailScreen> createState() => _AddOutletDetailScreenState();
}

class _AddOutletDetailScreenState extends State<AddOutletDetailScreen> {
  final _shopController = TextEditingController();
  final _ownerController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();

  void _save() {
    if (_shopController.text.isEmpty || _ownerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Shop Name & Owner Name')));
      return;
    }
    Navigator.pop(context, {
      'shopName': _shopController.text,
      'ownerName': _ownerController.text,
      'whatsapp': _whatsappController.text,
      'street': _streetController.text,
      'area': _areaController.text,
      'city': _cityController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Outlet Details', style: TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _shopController, decoration: const InputDecoration(labelText: '1. Shop Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _ownerController, decoration: const InputDecoration(labelText: '2. Owner Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _whatsappController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: '3. WhatsApp Number (e.g. 923001234567)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _streetController, decoration: const InputDecoration(labelText: '4. Street', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _areaController, decoration: const InputDecoration(labelText: '5. Area', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: '6. City', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: const Size.fromHeight(50)),
              onPressed: _save,
              child: const Text('Save Outlet Details', style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

// OUTLET OPTIONS MENU WITH WHATSAPP INVOICE FUNCTION
class OutletOptionMenuScreen extends StatelessWidget {
  final Map<String, String> outletData;
  const OutletOptionMenuScreen({super.key, required this.outletData});

  void _sendWhatsAppInvoice(BuildContext context) async {
    final phone = outletData['whatsapp'] ?? '';
    final shopName = outletData['shopName'] ?? '';
    final ownerName = outletData['ownerName'] ?? '';

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp number is missing for this outlet.')),
      );
      return;
    }

    final message = "Dear $ownerName ($shopName),\n\nHere is your Sale Invoice from Global Digital Khata.\nTotal Amount: Rs. 0\nPaid Amount: Rs. 0\nRemaining Balance: Rs. 0\n\nThank you for your business!";
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(outletData['shopName'] ?? 'Menu', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.indigo),
              title: const Text('1. Edit Outlet Details'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.indigo),
              title: const Text('2. Create Order'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.receipt, color: Colors.indigo),
              title: const Text('3. Invoice History'),
              subtitle: const Text('View history & manual bill gallery upload'),
              trailing: IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: () => _sendWhatsAppInvoice(context),
              ),
              onTap: () => _sendWhatsAppInvoice(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.indigo),
              title: const Text('4. Payment Details'),
              subtitle: const Text('Amount Paid & Remaining Balance'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. STOCK / PRODUCTS SCREEN (WITH SEARCH & ADD FUNCTION)
// ---------------------------------------------------------
class StockProductScreen extends StatefulWidget {
  const StockProductScreen({super.key});

  @override
  State<StockProductScreen> createState() => _StockProductScreenState();
}

class _StockProductScreenState extends State<StockProductScreen> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((p) => p['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _openAddProductForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddProductModal(),
    ).then((newProd) {
      if (newProd != null && newProd is Map<String, dynamic>) {
        setState(() {
          products.add(newProd);
          filteredProducts = List.from(products);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock / Products Management', style: TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: Column(
        children: [
          // SEARCH BAR FOR STOCK
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search Product Name...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('No Products Added. Click + to Add Stock.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.inventory_2, color: Colors.indigo, size: 36),
                          title: Text('${p['name']} (${p['size']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Cartons in Stock: ${p['cartons']} | Pkts/Carton: ${p['pktsPerCarton']}\n'
                            'Packet Rate: Rs. ${p['pktRate']} | Carton Rate: Rs. ${p['cartonRate']}\n'
                            'Discount: ${p['discount']}%',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        onPressed: _openAddProductForm,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// MODAL FORM TO ADD PRODUCT / STOCK
class AddProductModal extends StatefulWidget {
  const AddProductModal({super.key});

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController();
  final _cartonsController = TextEditingController();
  final _pktsPerCartonController = TextEditingController(text: '8');
  final _pktRateController = TextEditingController();
  final _cartonRateController = TextEditingController();
  final _discountController = TextEditingController(text: '0');

  void _saveProduct() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Product Name')));
      return;
    }

    Navigator.pop(context, {
      'name': _nameController.text,
      'size': _sizeController.text,
      'cartons': int.tryParse(_cartonsController.text) ?? 0,
      'pktsPerCarton': int.tryParse(_pktsPerCartonController.text) ?? 8,
      'pktRate': double.tryParse(_pktRateController.text) ?? 0.0,
      'cartonRate': double.tryParse(_cartonRateController.text) ?? 0.0,
      'discount': double.tryParse(_discountController.text) ?? 0.0,
    });
  }

  @override
  Widget build(BuildContext context) {
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
            const Text('Add New Stock Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _sizeController, decoration: const InputDecoration(labelText: 'Product Size', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _cartonsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Cartons', border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _pktsPerCartonController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Packets/Carton', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _pktRateController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Packet Rate', border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _cartonRateController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Carton Rate', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: _discountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Discount Rate (%)', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: const Size.fromHeight(50)),
              onPressed: _saveProduct,
              child: const Text('Save Stock Item', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. DAILY SALE ORDER SCREEN
// ---------------------------------------------------------
class DailySaleOrderScreen extends StatelessWidget {
  const DailySaleOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Sale Order', style: TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: const Center(
        child: Text(
          'Daily Sale Orders from Outlets will convert and list here automatically.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
