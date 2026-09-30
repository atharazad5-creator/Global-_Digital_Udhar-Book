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
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// Data Models
class StockItem {
  String name;
  String size;
  int cartons;
  int packetsPerCarton;
  int looseUnits;
  double unitRate;

  StockItem({
    required this.name,
    required this.size,
    required this.cartons,
    required this.packetsPerCarton,
    required this.looseUnits,
    required this.unitRate,
  });

  // Auto Calculations
  double get cartonRate => unitRate * packetsPerCarton;
  int get totalUnits => (cartons * packetsPerCarton) + looseUnits;
}

class InvoiceItem {
  final String name;
  final String size;
  final int qty;
  final double price;

  InvoiceItem({
    required this.name,
    required this.size,
    required this.qty,
    required this.price,
  });

  double get total => qty * price;
}

class Outlet {
  final String name;
  final String phone;
  final double totalBill;
  final double paidAmount;
  final List<InvoiceItem> items;

  Outlet({
    required this.name,
    required this.phone,
    required this.totalBill,
    required this.paidAmount,
    required this.items,
  });

  double get balance => totalBill - paidAmount;
}

// Global Preserved Data
List<StockItem> globalStock = [
  StockItem(
    name: "Rocket Pamper",
    size: "Newborn (NB)",
    cartons: 25,
    packetsPerCarton: 8,
    looseUnits: 10,
    unitRate: 600.0,
  ),
  StockItem(
    name: "Rocket Pamper",
    size: "Small (S)",
    cartons: 0,
    packetsPerCarton: 8,
    looseUnits: 0,
    unitRate: 650.0,
  ),
  StockItem(
    name: "Rocket Pamper",
    size: "Medium (M)",
    cartons: 25,
    packetsPerCarton: 8,
    looseUnits: 5,
    unitRate: 700.0,
  ),
  StockItem(
    name: "Rocket Pamper",
    size: "Large (L)",
    cartons: 25,
    packetsPerCarton: 8,
    looseUnits: 0,
    unitRate: 750.0,
  ),
];

List<Outlet> globalOutlets = [
  Outlet(
    name: "Ghousia Atta Chakki",
    phone: "+923001234567",
    totalBill: 12100.0,
    paidAmount: 5000.0,
    items: [
      InvoiceItem(name: "Rocket Pamper", size: "Newborn (NB)", qty: 1, price: 4800.0),
      InvoiceItem(name: "Rocket Pamper", size: "Medium (M)", qty: 1, price: 5600.0),
    ],
  ),
  Outlet(
    name: "ABC Traders",
    phone: "+923009876543",
    totalBill: 10400.0,
    paidAmount: 10400.0,
    items: [
      InvoiceItem(name: "Rocket Pamper", size: "Small (S)", qty: 2, price: 5200.0),
    ],
  ),
];

// Helper: Convert Number to Words
String convertToWords(double amount) {
  int val = amount.toInt();
  if (val == 0) return "Zero Rupees Only";
  return "$val Rupees Only";
}

// Main Dashboard with Navigation Drawer
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1; // Default to Stock Screen

  final List<Widget> _screens = [
    const OutletsScreen(),
    const StockScreen(),
    const SalesOrderScreen(),
    const InvoiceHistoryListScreen(),
  ];

  void _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

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
            const UserAccountsDrawerHeader(
              accountName: Text("Global Digital Khata", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: Text("Inventory & Khata Management System"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.storefront, size: 40, color: Colors.blueAccent),
              ),
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.blueAccent),
              title: const Text('My Outlets'),
              selected: _selectedIndex == 0,
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2, color: Colors.blueAccent),
              title: const Text('Stock Management'),
              selected: _selectedIndex == 1,
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.blueAccent),
              title: const Text('Sales Order'),
              selected: _selectedIndex == 2,
              onTap: () => _onSelectItem(2),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.blueAccent),
              title: const Text('Invoice History'),
              selected: _selectedIndex == 3,
              onTap: () => _onSelectItem(3),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}

// 1. MY OUTLETS SCREEN
class OutletsScreen extends StatelessWidget {
  const OutletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: globalOutlets.length,
        itemBuilder: (context, index) {
          final outlet = globalOutlets[index];
          final double balance = outlet.balance;
          final Color balanceColor = balance > 0 ? Colors.red : Colors.blue;

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                outlet.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    "Balance: Rs. ${balance.toStringAsFixed(0)}",
                    style: TextStyle(
                      color: balanceColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "In Words: ${convertToWords(balance)}",
                    style: TextStyle(
                      color: balanceColor,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceHistoryDetailScreen(outlet: outlet),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 2. STOCK MANAGEMENT SCREEN WITH AUTO-CALCULATION & FORMAT 25/8
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  void _addOrEditStockDialog([StockItem? itemToEdit]) {
    final nameController = TextEditingController(text: itemToEdit?.name ?? "");
    final sizeController = TextEditingController(text: itemToEdit?.size ?? "");
    final cartonsController = TextEditingController(text: itemToEdit != null ? itemToEdit.cartons.toString() : "0");
    final pcsPerCartonController = TextEditingController(text: itemToEdit != null ? itemToEdit.packetsPerCarton.toString() : "8");
    final looseUnitsController = TextEditingController(text: itemToEdit != null ? itemToEdit.looseUnits.toString() : "0");
    final unitRateController = TextEditingController(text: itemToEdit != null ? itemToEdit.unitRate.toString() : "0");

    double calculatedCartonRate = itemToEdit != null ? itemToEdit.cartonRate : 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void updateCalculations() {
              int pcsPerCarton = int.tryParse(pcsPerCartonController.text) ?? 0;
              double unitRate = double.tryParse(unitRateController.text) ?? 0.0;
              setDialogState(() {
                calculatedCartonRate = pcsPerCarton * unitRate;
              });
            }

            return AlertDialog(
              title: Text(itemToEdit == null ? "Add New Stock Item" : "Edit Stock Item"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Item Name"),
                    ),
                    TextField(
                      controller: sizeController,
                      decoration: const InputDecoration(labelText: "Size (e.g. Newborn / Small)"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cartonsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Cartons Quantity"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: pcsPerCartonController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Pcs/Packets per Carton"),
                            onChanged: (_) => updateCalculations(),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: looseUnitsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Loose Packets/Units Quantity"),
                    ),
                    TextField(
                      controller: unitRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Packet/Unit Rate (Rs)"),
                      onChanged: (_) => updateCalculations(),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Calculated Carton Rate:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "Rs. ${calculatedCartonRate.toStringAsFixed(0)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        int ctn = int.tryParse(cartonsController.text) ?? 0;
                        int pcsPerCtn = int.tryParse(pcsPerCartonController.text) ?? 8;
                        int loose = int.tryParse(looseUnitsController.text) ?? 0;
                        double uRate = double.tryParse(unitRateController.text) ?? 0.0;

                        if (itemToEdit == null) {
                          globalStock.add(
                            StockItem(
                              name: nameController.text,
                              size: sizeController.text.isEmpty ? "Standard" : sizeController.text,
                              cartons: ctn,
                              packetsPerCarton: pcsPerCtn,
                              looseUnits: loose,
                              unitRate: uRate,
                            ),
                          );
                        } else {
                          itemToEdit.name = nameController.text;
                          itemToEdit.size = sizeController.text;
                          itemToEdit.cartons = ctn;
                          itemToEdit.packetsPerCarton = pcsPerCtn;
                          itemToEdit.looseUnits = loose;
                          itemToEdit.unitRate = uRate;
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(itemToEdit == null ? "Add Item" : "Save Changes"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort Alphabetically
    List<StockItem> sortedStock = List.from(globalStock);
    sortedStock.sort((a, b) {
      int nameComp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (nameComp != 0) return nameComp;
      return a.size.toLowerCase().compareTo(b.size.toLowerCase());
    });

    // Search Filter
    List<StockItem> filteredStock = sortedStock.where((item) {
      String fullQuery = "${item.name} ${item.size}".toLowerCase();
      return fullQuery.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search stock items...",
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),
          // Stock List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filteredStock.length,
              itemBuilder: (context, index) {
                final stock = filteredStock[index];
                final bool isZeroStock = stock.cartons == 0 && stock.looseUnits == 0;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory_2,
                                  color: isZeroStock ? Colors.red : Colors.blueAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${stock.name} - ${stock.size}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isZeroStock ? Colors.red : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // Three-Dot Menu
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _addOrEditStockDialog(stock);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                                      SizedBox(width: 8),
                                      Text("Edit"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cartons Stock: ${stock.cartons} / ${stock.packetsPerCarton}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isZeroStock ? Colors.red : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Loose Units: ${stock.looseUnits} Pcs",
                                  style: TextStyle(
                                    color: isZeroStock ? Colors.red : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Carton Rate: Rs. ${stock.cartonRate.toStringAsFixed(0)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Packet Rate: Rs. ${stock.unitRate.toStringAsFixed(0)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                              ],
                            ),
                          ],
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
        onPressed: () => _addOrEditStockDialog(),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add New Item", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// 3. SALES ORDER SCREEN
class SalesOrderScreen extends StatelessWidget {
  const SalesOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.add_shopping_cart, color: Colors.white, size: 30),
                    SizedBox(width: 12),
                    Text(
                      "Create Sales Order",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: globalStock.length,
                itemBuilder: (context, index) {
                  final item = globalStock[index];
                  return Card(
                    child: ListTile(
                      title: Text("${item.name} (${item.size})"),
                      subtitle: Text("Carton Rate: Rs. ${item.cartonRate.toStringAsFixed(0)}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${item.name} ${item.size} added to order cart")),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. INVOICE HISTORY LIST SCREEN
class InvoiceHistoryListScreen extends StatelessWidget {
  const InvoiceHistoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: globalOutlets.length,
      itemBuilder: (context, index) {
        final outlet = globalOutlets[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.blueAccent),
            title: Text(outlet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Total Bill: Rs. ${outlet.totalBill.toStringAsFixed(0)} | Paid: Rs. ${outlet.paidAmount.toStringAsFixed(0)}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceHistoryDetailScreen(outlet: outlet),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// INVOICE HISTORY DETAIL & WHATSAPP SHARE SCREEN
class InvoiceHistoryDetailScreen extends StatelessWidget {
  final Outlet outlet;

  const InvoiceHistoryDetailScreen({super.key, required this.outlet});

  void _shareOnWhatsApp(BuildContext context) async {
    StringBuffer message = StringBuffer();
    message.writeln("*--- INVOICE DETAILS ---*");
    message.writeln("*Customer:* ${outlet.name}");
    message.writeln("--------------------------");
    message.writeln("*Items Purchased:*");
    
    for (var item in outlet.items) {
      message.writeln("• ${item.name} (${item.size}) x${item.qty} @ Rs.${item.price.toStringAsFixed(0)} = Rs.${item.total.toStringAsFixed(0)}");
    }
    
    message.writeln("--------------------------");
    message.writeln("*Total Bill:* Rs. ${outlet.totalBill.toStringAsFixed(0)}");
    message.writeln("*Paid Amount:* Rs. ${outlet.paidAmount.toStringAsFixed(0)}");
    message.writeln("*Outstanding Balance:* Rs. ${outlet.balance.toStringAsFixed(0)}");
    
    final Uri url = Uri.parse("https://wa.me/${outlet.phone}?text=${Uri.encodeComponent(message.toString())}");
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch WhatsApp")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${outlet.name} - History"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Bill:", style: TextStyle(fontSize: 16)),
                        Text("Rs. ${outlet.totalBill.toStringAsFixed(0)}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Paid Amount:", style: TextStyle(fontSize: 16, color: Colors.green)),
                        Text("Rs. ${outlet.paidAmount.toStringAsFixed(0)}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Outstanding Balance:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                        Text("Rs. ${outlet.balance.toStringAsFixed(0)}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Purchased Items:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: outlet.items.length,
                itemBuilder: (context, index) {
                  final item = outlet.items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text("${item.name} (${item.size})", style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text("Qty: ${item.qty} × Rs. ${item.price.toStringAsFixed(0)}"),
                      trailing: Text(
                        "Rs. ${item.total.toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _shareOnWhatsApp(context),
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text(
                "Share Invoice on WhatsApp",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
