import 'dart me/convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GlobalDigitalKhataApp());
}

class GlobalDigitalKhataApp extends StatefulWidget {
  const GlobalDigitalKhataApp({super.key});

  @override
  State<GlobalDigitalKhataApp> createState() => _GlobalDigitalKhataAppState();
}

class _GlobalDigitalKhataAppState extends State<GlobalDigitalKhataApp> {
  List<Map<String, dynamic>> outlets = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> dailyOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromStorage();
  }

  Future<void> _loadDataFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? outletsJson = prefs.getString('saved_outlets');
    final String? productsJson = prefs.getString('saved_products');
    final String? ordersJson = prefs.getString('saved_orders');

    setState(() {
      if (outletsJson != null) {
        outlets = List<Map<String, dynamic>>.from(json.decode(outletsJson));
      }
      if (productsJson != null) {
        products = List<Map<String, dynamic>>.from(json.decode(productsJson));
      }
      if (ordersJson != null) {
        dailyOrders = List<Map<String, dynamic>>.from(json.decode(ordersJson));
      }
      isLoading = false;
    });
  }

  Future<void> _saveDataToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_outlets', json.encode(outlets));
    await prefs.setString('saved_products', json.encode(products));
    await prefs.setString('saved_orders', json.encode(dailyOrders));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.indigo))),
      );
    }

    return MaterialApp(
      title: 'Global Digital Khata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: MainDashboardScreen(
        outlets: outlets,
        products: products,
        dailyOrders: dailyOrders,
        onUpdateOutlets: (updated) {
          setState(() => outlets = updated);
          _saveDataToStorage();
        },
        onUpdateProducts: (updated) {
          setState(() => products = updated);
          _saveDataToStorage();
        },
        onUpdateDailyOrders: (updated) {
          setState(() => dailyOrders = updated);
          _saveDataToStorage();
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// 1. MAIN MENU DASHBOARD
// ---------------------------------------------------------
class MainDashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> outlets;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> dailyOrders;
  final Function(List<Map<String, dynamic>>) onUpdateOutlets;
  final Function(List<Map<String, dynamic>>) onUpdateProducts;
  final Function(List<Map<String, dynamic>>) onUpdateDailyOrders;

  const MainDashboardScreen({
    super.key,
    required this.outlets,
    required this.products,
    required this.dailyOrders,
    required this.onUpdateOutlets,
    required this.onUpdateProducts,
    required this.onUpdateDailyOrders,
  });

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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(vertical: 20)),
              icon: const Icon(Icons.store, color: Colors.white, size: 28),
              label: const Text('1. My Outlet', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOutletScreen(
                      outlets: outlets,
                      products: products,
                      dailyOrders: dailyOrders,
                      onUpdateOutlets: onUpdateOutlets,
                      onUpdateProducts: onUpdateProducts,
                      onUpdateDailyOrders: onUpdateDailyOrders,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(vertical: 20)),
              icon: const Icon(Icons.inventory, color: Colors.white, size: 28),
              label: const Text('2. Stock / Products', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockProductScreen(
                      products: products,
                      onUpdateProducts: onUpdateProducts,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(vertical: 20)),
              icon: const Icon(Icons.receipt_long, color: Colors.white, size: 28),
              label: const Text('3. Daily Sale Order', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailySaleOrderScreen(dailyOrders: dailyOrders),
                  ),
                );
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
  final List<Map<String, dynamic>> outlets;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> dailyOrders;
  final Function(List<Map<String, dynamic>>) onUpdateOutlets;
  final Function(List<Map<String, dynamic>>) onUpdateProducts;
  final Function(List<Map<String, dynamic>>) onUpdateDailyOrders;

  const MyOutletScreen({
    super.key,
    required this.outlets,
    required this.products,
    required this.dailyOrders,
    required this.onUpdateOutlets,
    required this.onUpdateProducts,
    required this.onUpdateDailyOrders,
  });

  @override
  State<MyOutletScreen> createState() => _MyOutletScreenState();
}

class _MyOutletScreenState extends State<MyOutletScreen> {
  String searchQuery = '';

  void _navigateToAddOutlet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOutletDetailScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      List<Map<String, dynamic>> updated = List.from(widget.outlets)..add(result);
      widget.onUpdateOutlets(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOutlets = widget.outlets.where((o) {
      final name = o['shopName'].toString().toLowerCase();
      final owner = o['ownerName'].toString().toLowerCase();
      final city = o['city'].toString().toLowerCase();
      final q = searchQuery.toLowerCase();
      return name.contains(q) || owner.contains(q) || city.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Outlets', style: TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              textCapitalization: TextCapitalization.words,
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search Shop, Owner or City...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                      num totalBill = item['totalBill'] ?? 0;
                      num paidAmount = item['paidAmount'] ?? 0;
                      num balance = item['balance'] ?? (totalBill - paidAmount);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.store, color: Colors.white)),
                          title: Text(item['shopName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black87, fontSize: 12),
                              children: [
                                TextSpan(text: 'Owner: ${item['ownerName']} | WA: ${item['whatsapp']}\n'),
                                TextSpan(text: '${item['street']}, ${item['area']}, ${item['city']}\n'),
                                TextSpan(text: 'Total Bill: Rs. $totalBill | Paid: Rs. $paidAmount | '),
                                TextSpan(
                                  text: 'Balance: Rs. $balance',
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OutletOptionMenuScreen(
                                  outletIndex: widget.outlets.indexOf(item),
                                  outletData: item,
                                  products: widget.products,
                                  dailyOrders: widget.dailyOrders,
                                  onSaveUpdatedOutlet: (updatedOutlet) {
                                    List<Map<String, dynamic>> updatedList = List.from(widget.outlets);
                                    updatedList[widget.outlets.indexOf(item)] = updatedOutlet;
                                    widget.onUpdateOutlets(updatedList);
                                  },
                                  onSaveOrder: (orderData, updatedProducts) {
                                    item['totalBill'] = (item['totalBill'] ?? 0) + orderData['totalAmount'];
                                    item['balance'] = (item['totalBill'] ?? 0) - (item['paidAmount'] ?? 0);
                                    widget.onUpdateOutlets(List.from(widget.outlets));

                                    widget.onUpdateProducts(updatedProducts);

                                    List<Map<String, dynamic>> updatedOrders = List.from(widget.dailyOrders)..add(orderData);
                                    widget.onUpdateDailyOrders(updatedOrders);
                                  },
                                  onUpdateDailyOrders: widget.onUpdateDailyOrders,
                                ),
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

// ADD / EDIT OUTLET DETAILS & TODAY'S PRODUCT SALES
class AddOutletDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final List<Map<String, dynamic>>? outletOrders;
  final Function(List<Map<String, dynamic>>)? onUpdateOrders;

  const AddOutletDetailScreen({
    super.key,
    this.initialData,
    this.outletOrders,
    this.onUpdateOrders,
  });

  @override
  State<AddOutletDetailScreen> createState() => _AddOutletDetailScreenState();
}

class _AddOutletDetailScreenState extends State<AddOutletDetailScreen> {
  late TextEditingController _shopController;
  late TextEditingController _ownerController;
  late TextEditingController _whatsappController;
  late TextEditingController _streetController;
  late TextEditingController _areaController;
  late TextEditingController _cityController;
  late TextEditingController _totalBillController;
  late TextEditingController _paidAmountController;

  List<Map<String, dynamic>> currentOrders = [];

  @override
  void initState() {
    super.initState();
    _shopController = TextEditingController(text: widget.initialData?['shopName'] ?? '');
    _ownerController = TextEditingController(text: widget.initialData?['ownerName'] ?? '');
    _whatsappController = TextEditingController(text: widget.initialData?['whatsapp'] ?? '');
    _streetController = TextEditingController(text: widget.initialData?['street'] ?? '');
    _areaController = TextEditingController(text: widget.initialData?['area'] ?? '');
    _cityController = TextEditingController(text: widget.initialData?['city'] ?? '');
    _totalBillController = TextEditingController(text: widget.initialData?['totalBill']?.toString() ?? '0');
    _paidAmountController = TextEditingController(text: widget.initialData?['paidAmount']?.toString() ?? '0');

    if (widget.outletOrders != null) {
      currentOrders = List<Map<String, dynamic>>.from(widget.outletOrders!);
    }
  }

  void _save() {
    if (_shopController.text.isEmpty || _ownerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Shop Name & Owner Name')));
      return;
    }

    double bill = double.tryParse(_totalBillController.text) ?? 0.0;
    double paid = double.tryParse(_paidAmountController.text) ?? 0.0;
    double bal = bill - paid;

    if (widget.onUpdateOrders != null) {
      widget.onUpdateOrders!(currentOrders);
    }

    Navigator.pop(context, {
      'shopName': _shopController.text,
      'ownerName': _ownerController.text,
      'whatsapp': _whatsappController.text,
      'street': _streetController.text,
      'area': _areaController.text,
      'city': _cityController.text,
      'totalBill': bill,
      'paidAmount': paid,
      'balance': bal,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.initialData == null ? 'Enter Outlet Details' : 'Edit Outlet & Product Orders', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _shopController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: '1. Shop Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _ownerController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: '2. Owner Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _whatsappController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: '3. WhatsApp Number', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _streetController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: '4. Street', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _areaController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: '5. Area', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _cityController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: '6. City', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: TextField(controller: _totalBillController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Bill (Rs)', border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _paidAmountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Recovery / Paid (Rs)', border: OutlineInputBorder()))),
              ],
            ),
            if (currentOrders.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Edit Today Product Orders:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentOrders.length,
                itemBuilder: (context, idx) {
                  final ord = currentOrders[idx];
                  return Card(
                    color: Colors.indigo.shade50,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(ord['productName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Cartons: ${ord['orderedCartons']} | Amount: Rs. ${ord['totalAmount']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            currentOrders.removeAt(idx);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: const Size.fromHeight(50)),
              onPressed: _save,
              child: const Text('Save Outlet & Order Details', style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

// OUTLET OPTION MENU
class OutletOptionMenuScreen extends StatelessWidget {
  final int outletIndex;
  final Map<String, dynamic> outletData;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> dailyOrders;
  final Function(Map<String, dynamic>) onSaveUpdatedOutlet;
  final Function(Map<String, dynamic>, List<Map<String, dynamic>>) onSaveOrder;
  final Function(List<Map<String, dynamic>>) onUpdateDailyOrders;

  const OutletOptionMenuScreen({
    super.key,
    required this.outletIndex,
    required this.outletData,
    required this.products,
    required this.dailyOrders,
    required this.onSaveUpdatedOutlet,
    required this.onSaveOrder,
    required this.onUpdateDailyOrders,
  });

  @override
  Widget build(BuildContext context) {
    final shopOrders = dailyOrders.where((o) => o['shopName'] == outletData['shopName']).toList();

    return Scaffold(
      appBar: AppBar(title: Text(outletData['shopName'] ?? 'Menu', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.indigo),
              title: const Text('1. Edit Outlet & Product Sales'),
              subtitle: const Text('Edit Shop Info, Recovery & Current Date Sales'),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOutletDetailScreen(
                      initialData: outletData,
                      outletOrders: shopOrders,
                      onUpdateOrders: (updatedShopOrders) {
                        List<Map<String, dynamic>> newGlobalOrders = dailyOrders.where((o) => o['shopName'] != outletData['shopName']).toList();
                        newGlobalOrders.addAll(updatedShopOrders);
                        onUpdateDailyOrders(newGlobalOrders);
                      },
                    ),
                  ),
                );
                if (result != null && result is Map<String, dynamic>) {
                  onSaveUpdatedOutlet(result);
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.indigo),
              title: const Text('2. Create Order'),
              subtitle: const Text('Open Full Stock Page with Prices & Balances'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateOrderScreen(
                      outletData: outletData,
                      products: products,
                      onOrderCreated: (order, updatedProds) {
                        onSaveOrder(order, updatedProds);
                      },
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.receipt, color: Colors.indigo),
              title: const Text('3. Invoice History'),
              subtitle: const Text('Full Invoice with Global Header & WhatsApp Migration'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceHistoryScreen(
                      outletData: outletData,
                      dailyOrders: shopOrders,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.indigo),
              title: const Text('4. Payment Details'),
              subtitle: Text('Paid: Rs. ${outletData['paidAmount'] ?? 0} | Balance: Rs. ${outletData['balance'] ?? 0}'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// INVOICE HISTORY SCREEN
class InvoiceHistoryScreen extends StatelessWidget {
  final Map<String, dynamic> outletData;
  final List<Map<String, dynamic>> dailyOrders;

  const InvoiceHistoryScreen({super.key, required this.outletData, required this.dailyOrders});

  void _sendWhatsAppFullInvoice(BuildContext context) async {
    String phone = outletData['whatsapp'] ?? '';
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('WhatsApp number missing')));
      return;
    }

    phone = phone.replaceAll('+', '').replaceAll(' ', '').replaceAll('-', '');
    if (phone.startsWith('0')) {
      phone = '92${phone.substring(1)}';
    }

    num totalBill = outletData['totalBill'] ?? 0;
    num paid = outletData['paidAmount'] ?? 0;
    num balance = outletData['balance'] ?? (totalBill - paid);

    StringBuffer invoiceBuffer = StringBuffer();
    invoiceBuffer.writeln("==============================");
    invoiceBuffer.writeln("    GLOBAL DIGITAL KHATA");
    invoiceBuffer.writeln("==============================");
    invoiceBuffer.writeln("Shop: ${outletData['shopName']}");
    invoiceBuffer.writeln("Owner: ${outletData['ownerName']}");
    invoiceBuffer.writeln("Phone: ${outletData['whatsapp']}");
    invoiceBuffer.writeln("Address: ${outletData['street']}, ${outletData['area']}, ${outletData['city']}");
    invoiceBuffer.writeln("Date: ${DateTime.now().toString().substring(0, 10)}");
    invoiceBuffer.writeln("------------------------------");
    invoiceBuffer.writeln("ITEMS DELIVERED:");

    if (dailyOrders.isEmpty) {
      invoiceBuffer.writeln("No specific items recorded.");
    } else {
      for (var order in dailyOrders) {
        invoiceBuffer.writeln("- ${order['productName']}: ${order['orderedCartons']} Cartons = Rs. ${order['totalAmount']}");
      }
    }

    invoiceBuffer.writeln("------------------------------");
    invoiceBuffer.writeln("Total Bill: Rs. $totalBill");
    invoiceBuffer.writeln("Received/Paid: Rs. $paid");
    invoiceBuffer.writeln("Remaining Balance: Rs. $balance");
    invoiceBuffer.writeln("==============================");
    invoiceBuffer.writeln("Thank you for your business!");

    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(invoiceBuffer.toString())}";
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    num totalBill = outletData['totalBill'] ?? 0;
    num paid = outletData['paidAmount'] ?? 0;
    num balance = outletData['balance'] ?? (totalBill - paid);

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Details', style: TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'GLOBAL DIGITAL KHATA',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              ),
              const Center(child: Text('Official Sales & Order Invoice', style: TextStyle(color: Colors.grey))),
              const Divider(height: 30, thickness: 2),
              Text('Shop Name: ${outletData['shopName']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Owner Name: ${outletData['ownerName']}'),
              Text('Phone / WA: ${outletData['whatsapp']}'),
              Text('Address: ${outletData['street']}, ${outletData['area']}, ${outletData['city']}'),
              Text('Invoice Date: ${DateTime.now().toString().substring(0, 10)}'),
              const Divider(height: 25),
              const Text('Item Breakdown:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo)),
              const SizedBox(height: 8),
              dailyOrders.isEmpty
                  ? const Text('No itemized orders found.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dailyOrders.length,
                      itemBuilder: (context, idx) {
                        final item = dailyOrders[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('${item['productName']} (${item['orderedCartons']} Cartons)')),
                              Text('Rs. ${item['totalAmount']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                    ),
              const Divider(height: 25, thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Bill:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Rs. $totalBill', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Paid Amount:'),
                  Text('Rs. $paid'),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remaining Balance:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  Text('Rs. $balance', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Send WhatsApp Invoice', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () => _sendWhatsAppFullInvoice(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CREATE ORDER SCREEN (FULL LIVE STOCK PAGE DISPLAY)
class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic> outletData;
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>, List<Map<String, dynamic>>) onOrderCreated;

  const CreateOrderScreen({super.key, required this.outletData, required this.products, required this.onOrderCreated});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  late List<Map<String, dynamic>> currentProducts;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    currentProducts = List<Map<String, dynamic>>.from(widget.products);
    for (var p in currentProducts) {
      _controllers[p['id']] = TextEditingController();
    }
  }

  void _processSingleOrder(Map<String, dynamic> prod) {
    final controller = _controllers[prod['id']];
    if (controller == null || controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter carton quantity')));
      return;
    }

    int orderedCartons = int.tryParse(controller.text) ?? 0;
    int availableCartons = prod['cartons'] ?? 0;

    if (orderedCartons <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid carton quantity')));
      return;
    }

    if (orderedCartons > availableCartons) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Insufficient Stock! Only $availableCartons cartons available.')));
      return;
    }

    double cartonRate = (prod['cartonRate'] as num).toDouble();
    double total = orderedCartons * cartonRate;

    setState(() {
      prod['cartons'] = availableCartons - orderedCartons;
    });

    controller.clear();

    Map<String, dynamic> order = {
      'shopName': widget.outletData['shopName'],
      'productName': '${prod['name']} (${prod['size']})',
      'orderedCartons': orderedCartons,
      'totalAmount': total,
      'date': DateTime.now().toString().substring(0, 10),
    };

    widget.onOrderCreated(order, currentProducts);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${prod['name']} Order Created Successfully! Added Rs. $total to Bill.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order - ${widget.outletData['shopName']}', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: currentProducts.isEmpty
          ? const Center(child: Text('No Stock Items Available. Add Products in Stock First.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: currentProducts.length,
              itemBuilder: (context, index) {
                final p = currentProducts[index];
                int cartons = p['cartons'] ?? 0;
                int pktsPerCarton = p['pktsPerCarton'] ?? 8;
                int totalPackets = cartons * pktsPerCarton;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${p['name']} (${p['size']})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: cartons > 0 ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                cartons > 0 ? 'In Stock' : 'Out of Stock',
                                style: TextStyle(color: cartons > 0 ? Colors.green.shade900 : Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Packet Rate: Rs. ${p['pktRate']} | Carton Rate: Rs. ${p['cartonRate']}'),
                        Text('Available Stock: $cartons Cartons ($totalPackets Total Units/Packets)', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controllers[p['id']],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Cartons to Order',
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                              icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                              label: const Text('Add Order', style: TextStyle(color: Colors.white)),
                              onPressed: () => _processSingleOrder(p),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ---------------------------------------------------------
// 3. STOCK / PRODUCTS SCREEN
// ---------------------------------------------------------
class StockProductScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(List<Map<String, dynamic>>) onUpdateProducts;

  const StockProductScreen({super.key, required this.products, required this.onUpdateProducts});

  @override
  State<StockProductScreen> createState() => _StockProductScreenState();
}

class _StockProductScreenState extends State<StockProductScreen> {
  String searchQuery = '';

  void _openAddEditProductModal([Map<String, dynamic>? existingProduct, int? index]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddProductModal(initialData: existingProduct),
    ).then((newProd) {
      if (newProd != null && newProd is Map<String, dynamic>) {
        List<Map<String, dynamic>> updated = List.from(widget.products);
        if (index != null) {
          updated[index] = newProd;
        } else {
          updated.add(newProd);
        }
        widget.onUpdateProducts(updated);
      }
    });
  }

  void _deleteProduct(int index) {
    List<Map<String, dynamic>> updated = List.from(widget.products);
    updated.removeAt(index);
    widget.onUpdateProducts(updated);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      return p['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Stock / Products Management', style: TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              textCapitalization: TextCapitalization.words,
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search Product Name...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No Products Added. Click + to Add Stock.'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      int cartons = p['cartons'] ?? 0;
                      int pktsPerCarton = p['pktsPerCarton'] ?? 8;
                      int totalPackets = cartons * pktsPerCarton;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.inventory_2, color: Colors.indigo, size: 36),
                          title: Text('${p['name']} (${p['size']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Cartons in Stock: $cartons | Total Packets/Units: $totalPackets\n'
                            'Packet Rate: Rs. ${p['pktRate']} | Carton Rate: Rs. ${p['cartonRate']}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.indigo),
                                onPressed: () => _openAddEditProductModal(p, index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteProduct(index),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        onPressed: () => _openAddEditProductModal(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// MODAL FORM FOR STOCK
class AddProductModal extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddProductModal({super.key, this.initialData});

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  late TextEditingController _nameController;
  late TextEditingController _sizeController;
  late TextEditingController _cartonsController;
  late TextEditingController _pktsPerCartonController;
  late TextEditingController _pktRateController;
  late TextEditingController _cartonRateController;
  late TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    _sizeController = TextEditingController(text: widget.initialData?['size'] ?? '');
    _cartonsController = TextEditingController(text: widget.initialData?['cartons']?.toString() ?? '');
    _pktsPerCartonController = TextEditingController(text: widget.initialData?['pktsPerCarton']?.toString() ?? '8');
    _pktRateController = TextEditingController(text: widget.initialData?['pktRate']?.toString() ?? '');
    _cartonRateController = TextEditingController(text: widget.initialData?['cartonRate']?.toString() ?? '');
    _discountController = TextEditingController(text: widget.initialData?['discount']?.toString() ?? '0');
  }

  void _calculateCartonRateFromPacket(String val) {
    double pktRate = double.tryParse(val) ?? 0.0;
    int pktsPerCarton = int.tryParse(_pktsPerCartonController.text) ?? 8;
    double calculatedCartonRate = pktRate * pktsPerCarton;
    _cartonRateController.text = calculatedCartonRate.toStringAsFixed(0);
  }

  void _saveProduct() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Product Name')));
      return;
    }

    Navigator.pop(context, {
      'id': widget.initialData?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
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
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.initialData == null ? 'Add New Stock Product' : 'Edit Stock Product', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 12),
            TextField(controller: _nameController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _sizeController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Product Size', border: OutlineInputBorder())),
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
                Expanded(
                  child: TextField(
                    controller: _pktRateController,
                    keyboardType: TextInputType.number,
                    onChanged: _calculateCartonRateFromPacket,
                    decoration: const InputDecoration(labelText: 'Packet/Unit Rate (Rs)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _cartonRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Carton Rate (Auto)', border: OutlineInputBorder()),
                  ),
                ),
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
  final List<Map<String, dynamic>> dailyOrders;
  const DailySaleOrderScreen({super.key, required this.dailyOrders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Sale Order', style: TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
      body: dailyOrders.isEmpty
          ? const Center(child: Text('No Daily Sale Orders Created Yet.'))
          : ListView.builder(
              itemCount: dailyOrders.length,
              itemBuilder: (context, index) {
                final order = dailyOrders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white)),
                    title: Text('${order['shopName']} - Rs. ${order['totalAmount']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Item: ${order['productName']} | Cartons: ${order['orderedCartons']}\nDate: ${order['date']}'),
                  ),
                );
              },
            ),
    );
  }
}
