import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: Text(_selectedIndex == 0
            ? 'My Outlet'
            : _selectedIndex == 1
                ? 'Stock'
                : 'Sales Order'),
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
                'Menu',
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
      body: _selectedIndex == 0
          ? const MyOutletScreen()
          : _selectedIndex == 1
              ? const StockScreen()
              : const Center(child: Text('Sales Order Screen Coming Soon')),
    );
  }
}

// ==================== My Outlet Screen ====================
class MyOutletScreen extends StatefulWidget {
  const MyOutletScreen({super.key});

  @override
  State<MyOutletScreen> createState() => _MyOutletScreenState();
}

class _MyOutletScreenState extends State<MyOutletScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  // Permanent Storage Functions
  Future<void> _saveCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_customers);
    await prefs.setString('customers_items_key_v2', encodedData);
  }

  Future<void> _loadCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('customers_items_key_v2');
    if (encodedData != null) {
      setState(() {
        _customers = List<Map<String, dynamic>>.from(jsonDecode(encodedData));
        _filteredCustomers = _customers;
      });
    }
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = _customers;
      } else {
        _filteredCustomers = _customers.where((item) {
          final shop = item['shopName'].toString().toLowerCase();
          final person = item['contactPerson'].toString().toLowerCase();
          final city = item['cityName'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return shop.contains(searchLower) ||
              person.contains(searchLower) ||
              city.contains(searchLower);
        }).toList();
      }
    });
  }

  void _showCustomerDialog({Map<String, dynamic>? itemToEdit, int? index}) {
    final shopNameController = TextEditingController(text: itemToEdit?['shopName'] ?? '');
    final contactPersonController = TextEditingController(text: itemToEdit?['contactPerson'] ?? '');
    final mobileController = TextEditingController(text: itemToEdit?['mobile'] ?? '');
    final whatsappController = TextEditingController(text: itemToEdit?['whatsapp'] ?? '');
    final addressController = TextEditingController(text: itemToEdit?['address'] ?? '');
    final cityNameController = TextEditingController(text: itemToEdit?['cityName'] ?? '');
    final areaNameController = TextEditingController(text: itemToEdit?['areaName'] ?? '');

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
                  itemToEdit == null ? 'New Customer' : 'Edit Customer',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: shopNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Shop Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contactPersonController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile #',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: whatsappController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Whatsapp #',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cityNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'City Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: areaNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Area Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 36),
                        SizedBox(height: 4),
                        Text('Location Pinned', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('CANCEL'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade900,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (shopNameController.text.isNotEmpty) {
                            setState(() {
                              final newItem = {
                                'shopName': shopNameController.text,
                                'contactPerson': contactPersonController.text,
                                'mobile': mobileController.text,
                                'whatsapp': whatsappController.text,
                                'address': addressController.text,
                                'cityName': cityNameController.text,
                                'areaName': areaNameController.text,
                              };

                              if (itemToEdit == null) {
                                _customers.add(newItem);
                              } else if (index != null) {
                                _customers[index] = newItem;
                              }
                              _saveCustomerData();
                              _filterCustomers(_searchController.text);
                            });
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: Text(itemToEdit == null ? 'SAVE CUSTOMER' : 'UPDATE'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // 5 Long Press Options Sheet
  void _showLongPressOptions(Map<String, dynamic> item, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item['shopName'] ?? 'Customer Options',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
              title: const Text('1. Recovery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recovery option selected for ${item['shopName']}')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.teal),
              title: const Text('2. WhatsApp Message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening WhatsApp for ${item['shopName']}')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.orange),
              title: const Text('3. Invoice'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invoice option selected for ${item['shopName']}')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.waving_hand, color: Colors.blue),
              title: const Text('4. Welcome Message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Welcome Message sent to ${item['shopName']}')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.purple),
              title: const Text('5. Reminder'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reminder set for ${item['shopName']}')),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCustomers,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Search customer, shop or city...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredCustomers.isEmpty
                ? const Center(
                    child: Text('No customers found. Tap + to add new customer.'),
                  )
                : ListView.builder(
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final item = _filteredCustomers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          onTap: () => _showCustomerDialog(itemToEdit: item, index: index),
                          onLongPress: () => _showLongPressOptions(item, index),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.indigo,
                            child: Icon(Icons.store, color: Colors.white),
                          ),
                          title: Text(
                            item['shopName'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Owner: ${item['contactPerson']} | City: ${item['cityName']}\nMobile: ${item['mobile']}',
                          ),
                          trailing: const Icon(Icons.more_vert),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade900,
        onPressed: () => _showCustomerDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ==================== Stock Screen ====================
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _stockItems = [];
  List<Map<String, dynamic>> _filteredItems = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadStockData();
  }

  Future<void> _saveStockData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_stockItems);
    await prefs.setString('stock_items_key_v2', encodedData);
  }

  Future<void> _loadStockData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('stock_items_key_v2');
    if (encodedData != null) {
      setState(() {
        _stockItems = List<Map<String, dynamic>>.from(jsonDecode(encodedData));
        _filteredItems = _stockItems;
      });
    }
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

  void _showItemOptions(Map<String, dynamic> item, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Edit Item'),
              onTap: () {
                Navigator.pop(context);
                _showStockDialog(itemToEdit: item, index: index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Item'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _stockItems.removeAt(index);
                  _saveStockData();
                  _filterStock(_searchController.text);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showStockDialog({Map<String, dynamic>? itemToEdit, int? index}) {
    final nameController = TextEditingController(text: itemToEdit?['name'] ?? '');
    final sizeController = TextEditingController(text: itemToEdit?['size'] ?? '');
    final cartonRateController = TextEditingController(text: itemToEdit?['cartonRate'] ?? '');
    final cartonPackingController = TextEditingController(text: itemToEdit?['cartonPacking'] ?? '');
    final availCartonsController = TextEditingController(text: itemToEdit?['availCartons'] ?? '');
    final packetRateController = TextEditingController(text: itemToEdit?['packetRate'] ?? '');
    final pcsPerPacketController = TextEditingController(text: itemToEdit?['pcsPerPacket'] ?? '');
    final availPacketsController = TextEditingController(text: itemToEdit?['availPackets'] ?? '');
    File? selectedImage = itemToEdit?['image'] != null ? File(itemToEdit!['image']) : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickImage() async {
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setModalState(() {
                  selectedImage = File(image.path);
                });
              }
            }

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
                      itemToEdit == null ? 'Add New Stock' : 'Edit Stock Details',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    Center(
                      child: GestureDetector(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blueAccent.shade100,
                          backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                          child: selectedImage == null
                              ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text('Tap to select image from Gallery/Files', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: sizeController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Size',
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
                              labelText: 'Carton Rate',
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
                              labelText: 'Carton Packing',
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
                        labelText: 'Available Cartons',
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
                              labelText: 'Packet / Unit Rate',
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
                              labelText: 'Pcs Per Packet / Unit',
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
                        labelText: 'Available Packets / Units',
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
                                'image': selectedImage?.path,
                              };

                              if (itemToEdit == null) {
                                _stockItems.add(newItem);
                              } else if (index != null) {
                                _stockItems[index] = newItem;
                              }
                              _saveStockData();
                              _filterStock(_searchController.text);
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          itemToEdit == null ? 'Save' : 'Update',
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterStock,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Search product or digit...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Text('No stock available. Tap + to add stock.'),
                  )
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (indexContext, index) {
                      final item = _filteredItems[index];
                      final imagePath = item['image'];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          onLongPress: () => _showItemOptions(item, index),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
                            child: imagePath == null
                                ? const Icon(Icons.inventory_2, color: Colors.white)
                                : null,
                          ),
                          title: Text(
                            '${item['name']} (${item['size']})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Cartons: ${item['availCartons']} (Rate: ${item['cartonRate']})'),
                              Text('Packets/Units: ${item['availPackets']} (Rate: ${item['packetRate']})'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => _showStockDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
