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
      home: const ProductStockScreen(),
    );
  }
}

// PRODUCT / STOCK MANAGEMENT SCREEN
class ProductStockScreen extends StatefulWidget {
  const ProductStockScreen({super.key});

  @override
  State<ProductStockScreen> createState() => _ProductStockScreenState();
}

class _ProductStockScreenState extends State<ProductStockScreen> {
  List<Map<String, dynamic>> productsList = [];

  void _openAddProductModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddProductForm(),
    ).then((newProduct) {
      if (newProduct != null) {
        setState(() {
          productsList.add(newProduct);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock / Product Management', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: productsList.isEmpty
          ? const Center(
              child: Text(
                'No Products Added to Stock Yet.\nClick + to Add New Product / Stock.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                final prod = productsList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.inventory_2, color: Colors.indigo),
                    ),
                    title: Text(prod['productName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Cartons: ${prod['totalCartons']} (${prod['packetsPerCarton']} Pkts/Carton)\n'
                      'Packet Price: Rs. ${prod['packetPrice']} | Carton Price: Rs. ${prod['cartonPrice']}\n'
                      'Discount: ${prod['discount']}%',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.edit, color: Colors.indigo),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        onPressed: _openAddProductModal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product / Stock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ADD PRODUCT FORM COMPONENT
class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _nameController = TextEditingController();
  final _cartonsController = TextEditingController();
  final _packetsPerCartonController = TextEditingController(text: '8'); // Default 8 Packets
  final _packetPriceController = TextEditingController();
  final _cartonPriceController = TextEditingController();
  final _discountController = TextEditingController(text: '0');

  void _saveProduct() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Product Name')),
      );
      return;
    }

    Navigator.pop(context, {
      'productName': _nameController.text,
      'totalCartons': _cartonsController.text,
      'packetsPerCarton': _packetsPerCartonController.text,
      'packetPrice': _packetPriceController.text,
      'cartonPrice': _cartonPriceController.text,
      'discount': _discountController.text,
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
            const Text(
              'Add New Stock / Product',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 15),

            // Image Upload Placeholder Button
            OutlinedButton.icon(
              onPressed: () {
                // Photo upload functionality will connect here
              },
              icon: const Icon(Icons.add_a_photo, color: Colors.indigo),
              label: const Text('Upload Product Image'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
              ),
            ),
            const SizedBox(height: 12),

            // Product Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product / Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Carton Details Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cartonsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Cartons',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _packetsPerCartonController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Packets per Carton',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price Details Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _packetPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Packet / Unit Rate',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _cartonPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Carton Rate',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Discount Input
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Discount Rate (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Save Product Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _saveProduct,
              child: const Text('Save Product to Stock', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
