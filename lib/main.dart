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
      home: const HomeScreen(),
    );
  }
}

// Model Class for Item
class InvoiceItem {
  final String name;
  final int qty;
  final double price;

  InvoiceItem({required this.name, required this.qty, required this.price});

  double get total => qty * price;
}

// Model Class for Outlet / Customer
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // محفوظ شدہ سابقہ ہسٹری (Preserved History & Outlets Data)
  final List<Outlet> outlets = [
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
      paidAmount: 8000.0, // سارا بل ادا شدہ (Zero Balance)
      items: [
        InvoiceItem(name: "Rice Specail 10kg", qty: 4, price: 2000.0),
      ],
    ),
    Outlet(
      name: "Madina Super Store",
      phone: "+923123456789",
      totalBill: 15500.0,
      paidAmount: 10000.0,
      items: [
        InvoiceItem(name: "Washing Powder", qty: 10, price: 800.0),
        InvoiceItem(name: "Soap Carton", qty: 3, price: 2500.0),
      ],
    ),
  ];

  // نمبروں کو الفاظ میں تبدیل کرنے کا فنکشن (Rupees)
  String convertToWords(double amount) {
    int val = amount.toInt();
    if (val == 0) return "Zero Rupees Only";
    return "$val Rupees Only";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Digital Khata'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: outlets.length,
        itemBuilder: (context, index) {
          final outlet = outlets[index];
          final double balance = outlet.balance;
          
          // قانون: بقایا ہو تو لال (Red)، سارا بل ادا ہو چکا ہو (0) تو نیلا (Blue)
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
                    builder: (context) => InvoiceHistoryScreen(outlet: outlet),
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

class InvoiceHistoryScreen extends StatelessWidget {
  final Outlet outlet;

  const InvoiceHistoryScreen({super.key, required this.outlet});

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
