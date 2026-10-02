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
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MainOutletScreen(),
    );
  }
}

// 1. MAIN PAGE: MY OUTLET
class MainOutletScreen extends StatefulWidget {
  const MainOutletScreen({super.key});

  @override
  State<MainOutletScreen> createState() => _MainOutletScreenState();
}

class _MainOutletScreenState extends State<MainOutletScreen> {
  List<Map<String, String>> outlets = [];

  void _navigateToAddOutlet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOutletScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        outlets.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Outlets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: outlets.isEmpty
          ? const Center(
              child: Text(
                'No Outlet Added Yet.\nClick + to add shop details.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: outlets.length,
              itemBuilder: (context, index) {
                final item = outlets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.store, color: Colors.white),
                    ),
                    title: Text(item['shopName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item['ownerName']} - ${item['whatsapp']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutletMenuScreen(outletData: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _navigateToAddOutlet,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

// 2. INFORMATION DETAIL FORM PAGE
class AddOutletScreen extends StatefulWidget {
  const AddOutletScreen({super.key});

  @override
  State<AddOutletScreen> createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();

  void _saveOutlet() {
    if (_shopNameController.text.isEmpty || _ownerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Shop Name and Owner Name')),
      );
      return;
    }

    Navigator.pop(context, {
      'shopName': _shopNameController.text,
      'ownerName': _ownerNameController.text,
      'whatsapp': _whatsappController.text,
      'street': _streetController.text,
      'area': _areaController.text,
      'city': _cityController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Outlet Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _shopNameController, decoration: const InputDecoration(labelText: 'Shop Name')),
            const SizedBox(height: 10),
            TextField(controller: _ownerNameController, decoration: const InputDecoration(labelText: 'Owner Name')),
            const SizedBox(height: 10),
            TextField(controller: _whatsappController, decoration: const InputDecoration(labelText: 'WhatsApp Number'), keyboardType: TextInputType.phone),
            const SizedBox(height: 10),
            TextField(controller: _streetController, decoration: const InputDecoration(labelText: 'Street')),
            const SizedBox(height: 10),
            TextField(controller: _areaController, decoration: const InputDecoration(labelText: 'Area')),
            const SizedBox(height: 10),
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _saveOutlet,
              child: const Text('Save Outlet', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. MENU OPTIONS PAGE (Edit, Create Order, History, Payment)
class OutletMenuScreen extends StatelessWidget {
  final Map<String, String> outletData;

  const OutletMenuScreen({super.key, required this.outletData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(outletData['shopName'] ?? 'Menu', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Button 1: Edit
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.indigo),
              title: const Text('Edit Outlet Details'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Divider(),

            // Button 2: Create Order
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.indigo),
              title: const Text('Create Order'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Divider(),

            // Button 3: History & Manual Bill Upload
            ListTile(
              leading: const Icon(Icons.history, color: Colors.indigo),
              title: const Text('Order History & Manual Bill'),
              subtitle: const Text('View history, gallery bill upload & WhatsApp text'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Divider(),

            // Button 4: Payment Details
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.indigo),
              title: const Text('Payment & Balance'),
              subtitle: const Text('Paid amount and remaining balance'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
