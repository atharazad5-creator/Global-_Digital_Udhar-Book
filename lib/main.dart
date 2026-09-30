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
  int cartons;
  int packetsPerCarton;
  int loosePackets;
  double pricePerCarton;

  StockItem({
    required this.name,
    required this.cartons,
    required this.packetsPerCarton,
    required this.loosePackets,
    required this.pricePerCarton,
  });

  int get totalPackets => (cartons * packetsPerCarton) + loosePackets;
}

class InvoiceItem {
  final String name;
  final int qty;
  final double price;

  InvoiceItem({required this.name, required this.qty, required this.price});

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
List<Outlet> globalOutlets = [
  Outlet(
    name: "Shah General Store",
    phone: "+923001234567",
    totalBill: 12100.0,
    paidAmount: 5000.0,
    items: [
      InvoiceItem(name: "Cooking Oil 5L", qty: 2, price: 3000.0),
      InvoiceItem(name: "Sugar 5kg", qty: 5, price: 1000.0),
      InvoiceItem(name: "Tea Pack 950g", qty: 1, price: 1100.0),
    ],
  ),
  Outlet(
    name: "Kashif Traders",
    phone: "+923009876543",
    totalBill: 8000.0,
    paidAmount: 8000.0, // Fully Paid - Blue Color
    items: [
      InvoiceItem(name: "Rice Special 10kg", qty: 4, price: 2000.0),
    ],
  ),
];

List<StockItem> globalStock = [
  StockItem(name: "Cooking Oil 5L", cartons: 10, packetsPerCarton: 4, loosePackets: 2, pricePerCarton: 12000.0),
  StockItem(name: "Sugar 5kg", cartons: 20, packetsPerCarton: 10, loosePackets: 0, pricePerCarton: 10000.0),
  StockItem(name: "Tea Pack 950g", cartons: 5, packetsPerCarton: 12, loosePackets: 5, pricePerCarton: 13200.0),
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
  int _selectedIndex = 0;

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
    Navigator.of(context).pop(); // Close Drawer
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
              accountEmail: Text("Manage Outlets, Stock & Invoices"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.store, size: 40, color: Colors.blueAccent),
              ),
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.blueAccent),
              title: const Text('My Outlets (دکانیں)'),
              selected: _selectedIndex == 0,
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.blueAccent),
              title: const Text('Stock Management (اسٹاک)'),
              selected: _selectedIndex == 1,
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.blueAccent),
              title: const Text('Sales Order (فروخت)'),
              selected: _selectedIndex == 2,
              onTap: () => _onSelectItem(2),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blueAccent),
              title: const Text('Invoice History (انوائس ہسٹری)'),
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
          // Rule: Red if balance > 0, Blue if balance == 0
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

// 2. STOCK MANAGEMENT SCREEN
class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: globalStock.length,
        itemBuilder: (context, index) {
          final stock = globalStock[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(stock.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(
                "Cartons: ${stock.cartons} | Loose: ${stock.loosePackets}\nTotal Packets: ${stock.totalPackets}",
              ),
              trailing: Text(
                "Rs. ${stock.pricePerCarton.toStringAsFixed(0)}/Ctn",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          );
        },
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
                      "Create New Sales Order",
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
                      title: Text(item.name),
                      subtitle: Text("Price: Rs. ${item.pricePerCarton.toStringAsFixed(0)}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${item.name} Order cart me add ho gaya")),
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
      message.writeln("• ${item.name} x${item.qty} @ Rs.${item.price.toStringAsFixed(0)} = Rs.${item.total.toStringAsFixed(0)}");
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
          const SnackBar(content: Text("WhatsApp open karne me masla hua")),
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
              "Purchased Items (تفصیلات):",
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
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
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
