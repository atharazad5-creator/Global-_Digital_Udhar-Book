import 'package:flutter/material.dart';

void main() {
  runApp(const GlobalDigitalKhataApp());
}

class GlobalDigitalKhataApp extends StatelessWidget {
  const GlobalDigitalKhataApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Digital Khata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF1E3A8A), // Deep Corporate Blue
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          elevation: 2,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

// ============================================================================
// MAIN HOME SCREEN WITH SIDE DRAWER
// ============================================================================
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedDrawerIndex = 0;

  final List<String> _titles = [
    'Global Digital Khata',
    'Outlets / Shops',
    'Stock / Products',
    'Recoveries',
    'Sale History',
    'Payment Methods',
    'Switch User',
  ];

  Widget _getDrawerItemScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardHomeView();
      case 1:
        return const OutletsScreen();
      case 2:
        return const ProductsScreen();
      case 3:
        return const RecoveriesScreen();
      case 4:
        return const SaleHistoryScreen();
      case 5:
        return const PaymentMethodsScreen();
      case 6:
        return const SwitchUserScreen();
      default:
        return const DashboardHomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedDrawerIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Syncing with Server...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppSideDrawer(
        selectedIndex: _selectedDrawerIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedDrawerIndex = index;
          });
          Navigator.pop(context); // Close drawer
        },
      ),
      body: _getDrawerItemScreen(_selectedDrawerIndex),
      floatingActionButton: _selectedDrawerIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1E3A8A),
              onPressed: () {},
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            )
          : null,
    );
  }
}

// ============================================================================
// SIDE DRAWER MENU
// ============================================================================
class AppSideDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppSideDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.business_center, color: Color(0xFF1E3A8A), size: 36),
            ),
            accountName: const Text(
              'Global Digital Khata',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: const Text('Sales Representative: Athar Ali'),
          ),
          _drawerTile(0, Icons.home, 'Home'),
          _drawerTile(1, Icons.store, 'Outlets / Shops'),
          _drawerTile(2, Icons.inventory_2, 'Stock / Products'),
          _drawerTile(3, Icons.account_balance_wallet, 'Recoveries'),
          _drawerTile(4, Icons.history, 'Sale History'),
          _drawerTile(5, Icons.payment, 'Payment Methods'),
          const Divider(),
          _drawerTile(6, Icons.switch_account, 'Switch User'),
        ],
      ),
    );
  }

  Widget _drawerTile(int index, IconData icon, String title) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF1E3A8A) : Colors.black87,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () => onItemSelected(index),
    );
  }
}

// ============================================================================
// 1. DASHBOARD HOME VIEW
// ============================================================================
class DashboardHomeView extends StatelessWidget {
  const DashboardHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String todayDate = "03 Oct, 2026";
    final String todayDay = "Saturday";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auto Filled Header Card
          Card(
            color: const Color(0xFF1E3A8A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Duty Date', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text(todayDate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                  Container(height: 30, width: 1, color: Colors.white30),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Activity Day', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text(todayDay, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text('Today Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
          ),

          // Dashboard Metric Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.45,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: const [
              MetricCard(
                title: 'Visits Outlets',
                value: '25',
                icon: Icons.storefront,
                color: Colors.blue,
              ),
              MetricCard(
                title: 'Sale Orders',
                value: '10',
                icon: Icons.shopping_cart,
                color: Colors.orange,
              ),
              MetricCard(
                title: 'Sale Value',
                value: 'Rs 24,232',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
              MetricCard(
                title: 'Today Recovery',
                value: 'Rs 12,500',
                icon: Icons.account_balance_wallet,
                color: Colors.purple,
              ),
              MetricCard(
                title: 'Today Cash Bill',
                value: 'Rs 15,000',
                icon: Icons.payments,
                color: Colors.teal,
              ),
              MetricCard(
                title: 'Today Credit',
                value: 'Rs 9,232',
                icon: Icons.redAccent,
                color: Colors.redAccent,
              ),
              MetricCard(
                title: 'Available Stock',
                value: '1,450 CTN',
                icon: Icons.inventory_2,
                color: Colors.indigo,
              ),
              MetricCard(
                title: 'Balance Stock',
                value: '1,200 CTN',
                icon: Icons.widgets,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. MY OUTLETS / SHOPS SCREEN
// ============================================================================
class OutletsScreen extends StatefulWidget {
  const OutletsScreen({Key? key}) : super(key: key);

  @override
  State<OutletsScreen> createState() => _OutletsScreenState();
}

class _OutletsScreenState extends State<OutletsScreen> {
  final List<Map<String, String>> _outlets = [
    {"name": "Hamran Kiryana G/ Phatak", "area": "GHAGHAR PHATAK, KARACHI", "type": "NON-FILER", "order": "No Order", "amount": "0.0"},
    {"name": "Waseem Kiryana Bihar Colony", "area": "DHABEJI, KARACHI", "type": "NON-FILER", "order": "Rs 735.15", "amount": "735.15"},
    {"name": "Shahnawaz Kiryana Bihar Colony", "area": "DHABEJI, KARACHI", "type": "NON-FILER", "order": "No Order", "amount": "0.0"},
    {"name": "Asim Confectionary", "area": "DHABEJI, KARACHI", "type": "NON-FILER", "order": "Rs 1,680.00", "amount": "1680.0"},
    {"name": "Baloch Kiryana", "area": "GULSHAN E HADEED, KARACHI", "type": "NON-FILER", "order": "No Order", "amount": "0.0"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _outlets.length,
        itemBuilder: (context, index) {
          final outlet = _outlets[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(Icons.store, color: Colors.white, size: 20),
              ),
              title: Text(outlet["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(outlet["area"]!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(outlet["type"]!, style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(outlet["order"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Icon(Icons.location_on, color: Colors.blue, size: 18),
                ],
              ),
              onTap: () {
                _showQuickActionDialog(context, outlet["name"]!);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCustomerScreen()));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Outlet', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showQuickActionDialog(BuildContext context, String shopName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shopName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.blue),
              title: const Text('Create Order'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateSaleOrderScreen(customerName: shopName)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments, color: Colors.green),
              title: const Text('Add Recovery'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem, color: Colors.orange),
              title: const Text('No Activity Reason'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 3. NEW CUSTOMER / OUTLET CREATION SCREEN
// ============================================================================
class NewCustomerScreen extends StatelessWidget {
  const NewCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Customer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Shop Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Contact Person', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Mobile #', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
                const SizedBox(width: 8),
                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Whatsapp #', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
              ],
            ),
            const SizedBox(height: 12),
            TextField(decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(labelText: 'City Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
                const SizedBox(width: 8),
                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Area Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 40, color: Colors.red),
                  SizedBox(height: 4),
                  Text('GPS Pinpoint Captured', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Lat: 24.8671985, Long: 67.3535298', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('SAVE CUSTOMER', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. CREATE SALE ORDER SCREEN
// ============================================================================
class CreateSaleOrderScreen extends StatelessWidget {
  final String customerName;
  const CreateSaleOrderScreen({Key? key, required this.customerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sale Order: $customerName')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.withOpacity(0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Customer: $customerName', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('Inv. Date: 04/10/2026', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: const [
                Card(
                  child: ListTile(
                    title: Text('Vista Detergent Powder 18 Gm*240', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('CTN: 0, PCS: 24  |  Unit Price: 8.73'),
                    trailing: Text('Rs 209.44', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Vista Detergent Powder 85 Gm*66', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('CTN: 0, PCS: 12  |  Unit Price: 43.81'),
                    trailing: Text('Rs 525.71', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Items: 2', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Bill Total: Rs 735.15', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3A8A))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {},
                        icon: const Icon(Icons.add, color: Colors.white, size: 18),
                        label: const Text('ITEM', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check, color: Colors.white, size: 18),
                        label: const Text('SAVE', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {},
                        icon: const Icon(Icons.payments, color: Colors.white, size: 18),
                        label: const Text('PAYMENT', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 5. PRODUCTS / STOCK SCREEN
// ============================================================================
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        ProductCard(name: "MAMA's Soya Sauce Can 4 Ltr", ctnRate: "2900.0", unitRate: "725.0", ctnStock: "2.0", pcsStock: "0.0", retail: "0.0"),
        ProductCard(name: "Bonjour 345 Ml Sip Rite (1x12)", ctnRate: "594.96", unitRate: "49.58", ctnStock: "16.0", pcsStock: "0.0", retail: "65.0"),
        ProductCard(name: "Bonjour 1500 Ml Siprite (1x6)", ctnRate: "790.02", unitRate: "131.67", ctnStock: "7.0", pcsStock: "0.0", retail: "150.0"),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name, ctnRate, unitRate, ctnStock, pcsStock, retail;
  const ProductCard({Key? key, required this.name, required this.ctnRate, required this.unitRate, required this.ctnStock, required this.pcsStock, required this.retail}) : super(key: key);

  @style
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cotton Rate: $ctnRate', style: const TextStyle(fontSize: 12)),
                Text('Unit Rate: $unitRate', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cotton Stock: $ctnStock', style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                Text('Pcs Stock: $pcsStock', style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecoveriesScreen extends StatelessWidget {
  const RecoveriesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Recoveries Management View'));
  }
}

class SaleHistoryScreen extends StatelessWidget {
  const SaleHistoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Sale Orders History View'));
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Payment Methods Configuration'));
  }
}

class SwitchUserScreen extends StatelessWidget {
  const SwitchUserScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Switch User / Salesman Screen'));
  }
}
