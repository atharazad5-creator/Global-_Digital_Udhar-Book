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
              : const Center(child: Text('Sales Order History')),
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

  Future<void> _saveCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_customers);
    await prefs.setString('customers_items_key_v3', encodedData);
  }

  Future<void> _loadCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('customers_items_key_v3');
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
                  height: 100,
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
                        Icon(Icons.location_on, color: Colors.red, size: 30),
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
                                'balance': 0.0,
                                'orders': [],
                              };

                              if (itemToEdit == null) {
                                _customers.add(newItem);
                              } else if (index != null) {
                                newItem['balance'] = itemToEdit['balance'] ?? 0.0;
                                newItem['orders'] = itemToEdit['orders'] ?? [];
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

  void _showLongPressOptions(Map<String, dynamic> item, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            Container(
              color: Colors.indigo.shade900,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item['shopName'] ?? 'Customer Options',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            
            // 1. CREATE ORDER (TOP OPTION)
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.blue, size: 28),
              title: const Text('1. Create Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('Select items from stock & create bill'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateOrderScreen(
                      customer: item,
                      onOrderCreated: (newOrder, totalAmount, paidAmount) {
                        setState(() {
                          item['orders'] = item['orders'] ?? [];
                          item['orders'].add(newOrder);
                          double currentBalance = (item['balance'] ?? 0.0).toDouble();
                          item['balance'] = currentBalance + (totalAmount - paidAmount);
                          _saveCustomerData();
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const Divider(),

            // 2. RECOVERY
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
              title: const Text('2. Recovery'),
              subtitle: Text('Current Balance: RS ${item['balance'] ?? 0}'),
              onTap: () {
                Navigator.pop(context);
                _showRecoveryDialog(item, index);
              },
            ),

            // 3. WHATSAPP MESSAGE
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.teal),
              title: const Text('3. WhatsApp Message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening WhatsApp for ${item['mobile']}')),
                );
              },
            ),

            // 4. INVOICE
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.orange),
              title: const Text('4. Invoice'),
              onTap: () {
                Navigator.pop(context);
                _showInvoiceDialog(item);
              },
            ),

            // 5. WELCOME MESSAGE
            ListTile(
              leading: const Icon(Icons.waving_hand, color: Colors.purple),
              title: const Text('5. Welcome Message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Welcome message sent to ${item['shopName']}')),
                );
              },
            ),

            // 6. REMINDER
            ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.red),
              title: const Text('6. Reminder'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment reminder sent to ${item['shopName']}')),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _showRecoveryDialog(Map<String, dynamic> item, int index) {
    final recoveryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Recovery for ${item['shopName']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Balance: RS ${item['balance'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
              const SizedBox(height: 15),
              TextField(
                controller: recoveryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Received Amount (RS)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double received = double.tryParse(recoveryController.text) ?? 0.0;
                if (received > 0) {
                  setState(() {
                    double currentBal = (item['balance'] ?? 0.0).toDouble();
                    item['balance'] = currentBal - received;
                    _saveCustomerData();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Recovery of RS $received Saved!')),
                  );
                }
              },
              child: const Text('Save Recovery'),
            ),
          ],
        );
      },
    );
  }

  void _showInvoiceDialog(Map<String, dynamic> item) {
    List orders = item['orders'] ?? [];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invoice History - ${item['shopName']}'),
          content: SizedBox(
            width: double.maxFinite,
            child: orders.isEmpty
                ? const Text('No orders found for this customer.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: orders.length,
                    itemBuilder: (context, idx) {
                      final order = orders[idx];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text('Order Date: ${order['date']}'),
                          subtitle: Text('Total Bill: RS ${order['total']} | Paid: RS ${order['paid']}'),
                          trailing: Text('Bal: RS ${order['total'] - order['paid']}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
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
                            'Owner: ${item['contactPerson']} | City: ${item['cityName']}\nBalance: RS ${item['balance'] ?? 0}',
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

// ==================== Create Order Screen (Stock Integrated) ====================
class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic> customer;
  final Function(Map<String, dynamic>, double, double) onOrderCreated;

  const CreateOrderScreen({super.key, required this.customer, required this.onOrderCreated});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  List<Map<String, dynamic>> _stockItems = [];
  List<Map<String, dynamic>> _cartItems = [];
  final TextEditingController _paidController = TextEditingController();
  double _totalBill = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStockData();
  }

  Future<void> _loadStockData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('stock_items_key_v3');
    if (encodedData != null) {
      setState(() {
        _stockItems = List<Map<String, dynamic>>.from(jsonDecode(encodedData));
      });
    }
  }

  Future<void> _saveStockData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_stockItems);
    await prefs.setString('stock_items_key_v3', encodedData);
  }

  void _addItemToCart(Map<String, dynamic> stockItem, int cartons, int packets) {
    double cartonRate = double.tryParse(stockItem['cartonRate'] ?? '0') ?? 0.0;
    double packetRate = double.tryParse(stockItem['packetRate'] ?? '0') ?? 0.0;

    double itemTotal = (cartons * cartonRate) + (packets * packetRate);

    setState(() {
      _cartItems.add({
        'name': stockItem['name'],
        'cartons': cartons,
        'packets': packets,
        'total': itemTotal,
      });

      // Minus stock from available inventory
      int currentCartons = int.tryParse(stockItem['availCartons'] ?? '0') ?? 0;
      int currentPackets = int.tryParse(stockItem['availPackets'] ?? '0') ?? 0;

      stockItem['availCartons'] = (currentCartons - cartons).clamp(0, 999999).toString();
      stockItem['availPackets'] = (currentPackets - packets).clamp(0, 999999).toString();

      _totalBill += itemTotal;
      _saveStockData();
    });
  }

  void _showAddToCartDialog(Map<String, dynamic> stockItem) {
    final cartonsController = TextEditingController(text: '0');
    final packetsController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order: ${stockItem['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Avail Cartons: ${stockItem['availCartons']} | Rate: ${stockItem['cartonRate']}'),
              TextField(
                controller: cartonsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Order Cartons Quantity'),
              ),
              const SizedBox(height: 10),
              Text('Avail Packets: ${stockItem['availPackets']} | Rate: ${stockItem['packetRate']}'),
              TextField(
                controller: packetsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Order Packets Quantity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                int c = int.tryParse(cartonsController.text) ?? 0;
                int p = int.tryParse(packetsController.text) ?? 0;
                if (c > 0 || p > 0) {
                  _addItemToCart(stockItem, c, p);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add to Order'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double paid = double.tryParse(_paidController.text) ?? 0.0;
    double remaining = _totalBill - paid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order - ${widget.customer['shopName']}'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: const Row(
              children: [
                Icon(Icons.touch_app, color: Colors.blue),
                SizedBox(width: 8),
                Text('Tap on stock item below to add in order:', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _stockItems.isEmpty
                ? const Center(child: Text('No Stock Items Available.'))
                : ListView.builder(
                    itemCount: _stockItems.length,
                    itemBuilder: (context, index) {
                      final item = _stockItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: ListTile(
                          title: Text('${item['name']} (${item['size']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Cartons Left: ${item['availCartons']} | Packets Left: ${item['availPackets']}'),
                          trailing: const Icon(Icons.add_circle, color: Colors.green, size: 30),
                          onTap: () => _showAddToCartDialog(item),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(thickness: 2),
          const Text('Items Added in Order:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            flex: 1,
            child: _cartItems.isEmpty
                ? const Center(child: Text('No items added to cart yet.'))
                : ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, idx) {
                      final cart = _cartItems[idx];
                      return ListTile(
                        dense: true,
                        title: Text('${cart['name']}'),
                        subtitle: Text('Cartons: ${cart['cartons']} | Packets: ${cart['packets']}'),
                        trailing: Text('RS ${cart['total']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            color: Colors.white,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bill:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('RS $_totalBill', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _paidController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Payment Received Amount (RS)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remaining Balance:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('RS $remaining', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _cartItems.isEmpty
                          ? null
                          : () {
                              final newOrder = {
                                'date': DateTime.now().toString().split(' ')[0],
                                'items': _cartItems,
                                'total': _totalBill,
                                'paid': paid,
                              };
                              widget.onOrderCreated(newOrder, _totalBill, paid);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Order Saved Successfully! Stock Updated.')),
                              );
                            },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('SAVE ORDER', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    await prefs.setString('stock_items_key_v3', encodedData);
  }

  Future<void> _loadStockData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('stock_items_key_v3');
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
                              Text('Cartons Left: ${item['availCartons']} (Rate: ${item['cartonRate']})'),
                              Text('Packets Left: ${item['availPackets']} (Rate: ${item['packetRate']})'),
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
