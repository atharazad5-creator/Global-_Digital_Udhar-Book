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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 3 Key Ledger Summary Items
  double totalToGet = 27700.0;
  double totalToGive = 4500.0;

  final List<Map<String, dynamic>> _customers = [
    {'name': 'Ali Raza', 'phone': '0300-1234567', 'balance': 15000, 'isYouWillGet': true},
    {'name': 'Ahmed Khan', 'phone': '0312-9876543', 'balance': 4500, 'isYouWillGet': false},
    {'name': 'Zubair Traders', 'phone': '0333-5551212', 'balance': 12700, 'isYouWillGet': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Digital Khata', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // STEP 1: DASHBOARD SUMMARY CARD (Top Step)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('You Will Get', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Rs. ${totalToGet.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(height: 40, width: 1, color: Colors.grey.shade300),
                    Column(
                      children: [
                        const Text('You Will Give', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Rs. ${totalToGive.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // STEP 2: CUSTOMERS LEDGER LIST (Middle Step)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Customer Entries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Active Accounts', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                final bool isGet = customer['isYouWillGet'];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 1.5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Text(customer['name'][0], style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(customer['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(customer['phone']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${customer['balance']}',
                          style: TextStyle(
                            color: isGet ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          isGet ? 'You Will Get' : 'You Will Give',
                          style: TextStyle(color: isGet ? Colors.green : Colors.red, fontSize: 11),
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

      // STEP 3: QUICK ADD ENTRY BUTTON (Bottom Step)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Customer Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
