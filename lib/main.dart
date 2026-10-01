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
  // Sample Data for Ledger
  final List<Map<String, dynamic>> _customers = [
    {'name': 'Ali Raza', 'phone': '0300-1234567', 'balance': 15000, 'isYouWillGet': true},
    {'name': 'Ahmed Khan', 'phone': '0312-9876543', 'balance': 4500, 'isYouWillGet': false},
    {'name': 'Zubair Traders', 'phone': '0333-5551212', 'balance': 8200, 'isYouWillGet': true},
  ];

  @override
  Widget build(BuildContext context) {
    double totalToGet = _customers
        .where((c) => c['isYouWillGet'] == true)
        .fold(0, (sum, c) => sum + c['balance']);

    double totalToGive = _customers
        .where((c) => c['isYouWillGet'] == false)
        .fold(0, (sum, c) => sum + c['balance']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Digital Khata', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dashboard Summary Card
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
                          const Text('You Will Get', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 6),
                          Text('Rs. ${totalToGet.toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.grey.shade300),
                      Column(
                        children: [
                          const Text('You Will Give', style: TextStyle(color: Colors.grey, fontSize: 14)),
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

            const SizedBox(height: 10),

            // Customers Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Customer Ledger', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('View All', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // Customer List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                final bool isGet = customer['isYouWillGet'];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                            fontSize: 16,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Add Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
