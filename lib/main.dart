import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  int packetsUnits;
  double unitRate;
  double discountPercent;
  String? imagePath;

  StockItem({
    required this.name,
    required this.size,
    required this.cartons,
    required this.packetsPerCarton,
    required this.packetsUnits,
    required this.unitRate,
    this.discountPercent = 0.0,
    this.imagePath,
  });

  double get baseCartonRate => unitRate * packetsPerCarton;
  double get discountedUnitRate => unitRate * (1 - (discountPercent / 100));
  double get discountedCartonRate => baseCartonRate * (1 - (discountPercent / 100));
  int get totalUnits => (cartons * packetsPerCarton) + packetsUnits;

  void deductStock({int soldCartons = 0, int soldUnits = 0}) {
    int totalAvailable = totalUnits;
    int totalSold = (soldCartons * packetsPerCarton) + soldUnits;
    int remainingTotal = totalAvailable - totalSold;

    if (remainingTotal < 0) remainingTotal = 0;

    cartons = remainingTotal ~/ packetsPerCarton;
    packetsUnits = remainingTotal % packetsPerCarton;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'size': size,
        'cartons': cartons,
        'packetsPerCarton': packetsPerCarton,
        'packetsUnits': packetsUnits,
        'unitRate': unitRate,
        'discountPercent': discountPercent,
        'imagePath': imagePath,
      };

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        name: json['name'] ?? '',
        size: json['size'] ?? '',
        cartons: json['cartons'] ?? 0,
        packetsPerCarton: json['packetsPerCarton'] ?? 8,
        packetsUnits: json['packetsUnits'] ?? 0,
        unitRate: (json['unitRate'] as num?)?.toDouble() ?? 0.0,
        discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
        imagePath: json['imagePath'],
      );
}

class InvoiceItem {
  final String name;
  final String size;
  final int qtyCartons;
  final int qtyUnits;
  final double unitPrice;

  InvoiceItem({
    required this.name,
    required this.size,
    required this.qtyCartons,
    required this.qtyUnits,
    required this.unitPrice,
  });

  double get total => (qtyCartons * (unitPrice * 8)) + (qtyUnits * unitPrice);
}

class Outlet {
  final String name;
  final String phone;
  double totalBill;
  double paidAmount;
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

// Global Data
List<StockItem> globalStock = [];

List<StockItem> defaultStock = [
  StockItem(
    name: "Rocket Pamper",
    size: "Newborn (NB)",
    cartons: 25,
    packetsPerCarton: 8,
    packetsUnits: 10,
    unitRate: 600.0,
    discountPercent: 2.0,
  ),
  StockItem(
    name: "Rocket Pamper",
    size: "Small (S)",
    cartons: 0,
    packetsPerCarton: 8,
    packetsUnits: 0,
    unitRate: 650.0,
    discountPercent: 0.0,
  ),
  StockItem(
    name: "Rocket Pamper",
    size: "Medium (M)",
    cartons: 25,
    packetsPerCarton: 8,
    packetsUnits: 5,
    unitRate: 700.0,
    discountPercent: 5.0,
  ),
  StockItem(
    name: "Rocket Pamper",
    size: "Large (L)",
    cartons: 25,
    packetsPerCarton: 8,
    packetsUnits: 0,
    unitRate: 750.0,
    discountPercent: 0.0,
  ),
];

// Permanent Local Storage
Future<void> saveStockToStorage() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = globalStock.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('saved_stock_items_v2', jsonList);
  } catch (e) {
    debugPrint("Save Error: $e");
  }
}

Future<void> loadStockFromStorage() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('saved_stock_items_v2');
    if (jsonList != null && jsonList.isNotEmpty) {
      globalStock = jsonList.map((itemStr) => StockItem.fromJson(jsonDecode(itemStr))).toList();
    } else {
      globalStock = List.from(defaultStock);
      await saveStockToStorage();
    }
  } catch (e) {
    globalStock = List.from(defaultStock);
  }
}

List<Outlet> globalOutlets = [
  Outlet(
    name: "Ghousia Atta Chakki",
    phone: "+923001234567",
    totalBill: 12100.0,
    paidAmount: 5000.0,
    items: [
      InvoiceItem(name: "Rocket Pamper", size: "Newborn (NB)", qtyCartons: 1, qtyUnits: 2, unitPrice: 588.0),
      InvoiceItem(name: "Rocket Pamper", size: "Medium (M)", qtyCartons: 1, qtyUnits: 0, unitPrice: 665.0),
    ],
  ),
  Outlet(
    name: "ABC Traders",
    phone: "+923009876543",
    totalBill: 10400.0,
    paidAmount: 10400.0,
    items: [
      InvoiceItem(name: "Rocket Pamper", size: "Small (S)", qtyCartons: 2, qtyUnits: 0, unitPrice: 650.0),
    ],
  ),
];

String convertToWords(double amount) {
  int val = amount.toInt();
  if (val == 0) return "Zero Rupees Only";
  return "$val Rupees Only";
}

// Navigation Dashboard
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    await loadStockFromStorage();
    setState(() {
      _isLoading = false;
    });
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens[_selectedIndex],
    );
  }
}

// 1. OUTLETS SCREEN
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

// 2. STOCK MANAGEMENT SCREEN
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  final ImagePicker _picker = ImagePicker();

  void _showZoomImageDialog(StockItem stock) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text("${stock.name} - ${stock.size}"),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: stock.imagePath != null && File(stock.imagePath!).existsSync()
                      ? Image.file(File(stock.imagePath!))
                      : Container(
                          height: 200,
                          width: 200,
                          color: Colors.blue.shade50,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.child_friendly, size: 80, color: Colors.blueAccent),
                              SizedBox(height: 8),
                              Text("No Custom Image Available", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteStockItem(StockItem stock) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Stock Item"),
          content: Text("Are you sure you want to delete '${stock.name} (${stock.size})'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                setState(() {
                  globalStock.remove(stock);
                });
                await saveStockToStorage();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${stock.name} deleted successfully")),
                  );
                }
              },
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _addOrEditStockDialog([StockItem? itemToEdit]) {
    final nameController = TextEditingController(text: itemToEdit?.name ?? "");
    final sizeController = TextEditingController(text: itemToEdit?.size ?? "");
    final cartonsController = TextEditingController(text: itemToEdit != null ? itemToEdit.cartons.toString() : "0");
    final pcsPerCartonController = TextEditingController(text: itemToEdit != null ? itemToEdit.packetsPerCarton.toString() : "8");
    final packetsUnitsController = TextEditingController(text: itemToEdit != null ? itemToEdit.packetsUnits.toString() : "0");
    final unitRateController = TextEditingController(text: itemToEdit != null ? itemToEdit.unitRate.toString() : "0");
    final discountController = TextEditingController(text: itemToEdit != null ? itemToEdit.discountPercent.toString() : "0");
    
    String? selectedImagePath = itemToEdit?.imagePath;

    double calculatedCartonRate = itemToEdit != null ? itemToEdit.baseCartonRate : 0.0;
    double calculatedDiscountedCarton = itemToEdit != null ? itemToEdit.discountedCartonRate : 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void updateCalculations() {
              int pcsPerCarton = int.tryParse(pcsPerCartonController.text) ?? 0;
              double unitRate = double.tryParse(unitRateController.text) ?? 0.0;
              double discount = double.tryParse(discountController.text) ?? 0.0;

              double baseCarton = pcsPerCarton * unitRate;
              double discCarton = baseCarton * (1 - (discount / 100));

              setDialogState(() {
                calculatedCartonRate = baseCarton;
                calculatedDiscountedCarton = discCarton;
              });
            }

            Future<void> pickImage() async {
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setDialogState(() {
                  selectedImagePath = image.path;
                });
              }
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
                            decoration: const InputDecoration(labelText: "Cartons Stock"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: pcsPerCartonController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Pcs/Packets in Ctn"),
                            onChanged: (_) => updateCalculations(),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: packetsUnitsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Packets / Units"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: unitRateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Packet/Unit Rate"),
                            onChanged: (_) => updateCalculations(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Discount (%)"),
                            onChanged: (_) => updateCalculations(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.image_search, color: Colors.blueAccent),
                      label: Text(selectedImagePath == null ? "Upload Image from Gallery" : "Change Selected Image"),
                    ),
                    if (selectedImagePath != null && File(selectedImagePath!).existsSync())
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.file(
                          File(selectedImagePath!),
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Original Carton Rate:", style: TextStyle(fontWeight: FontWeight.w600)),
                              Text("Rs. ${calculatedCartonRate.toStringAsFixed(0)}"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("After Discount Rate:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              Text(
                                "Rs. ${calculatedDiscountedCarton.toStringAsFixed(0)}",
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                              ),
                            ],
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
                  onPressed: () async {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        int ctn = int.tryParse(cartonsController.text) ?? 0;
                        int pcsPerCtn = int.tryParse(pcsPerCartonController.text) ?? 8;
                        int pktsUnits = int.tryParse(packetsUnitsController.text) ?? 0;
                        double uRate = double.tryParse(unitRateController.text) ?? 0.0;
                        double disc = double.tryParse(discountController.text) ?? 0.0;

                        if (itemToEdit == null) {
                          globalStock.add(
                            StockItem(
                              name: nameController.text,
                              size: sizeController.text.isEmpty ? "Standard" : sizeController.text,
                              cartons: ctn,
                              packetsPerCarton: pcsPerCtn,
                              packetsUnits: pktsUnits,
                              unitRate: uRate,
                              discountPercent: disc,
                              imagePath: selectedImagePath,
                            ),
                          );
                        } else {
                          itemToEdit.name = nameController.text;
                          itemToEdit.size = sizeController.text;
                          itemToEdit.cartons = ctn;
                          itemToEdit.packetsPerCarton = pcsPerCtn;
                          itemToEdit.packetsUnits = pktsUnits;
                          itemToEdit.unitRate = uRate;
                          itemToEdit.discountPercent = disc;
                          itemToEdit.imagePath = selectedImagePath;
                        }
                      });
                      await saveStockToStorage();
                      if (mounted) {
                        Navigator.pop(context);
                      }
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
    List<StockItem> sortedStock = List.from(globalStock);
    sortedStock.sort((a, b) {
      int nameComp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (nameComp != 0) return nameComp;
      return a.size.toLowerCase().compareTo(b.size.toLowerCase());
    });

    List<StockItem> filteredStock = sortedStock.where((item) {
      String fullQuery = "${item.name} ${item.size}".toLowerCase();
      return fullQuery.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filteredStock.length,
              itemBuilder: (context, index) {
                final stock = filteredStock[index];
                final bool isZeroStock = stock.cartons == 0 && stock.packetsUnits == 0;
                final bool hasValidImage = stock.imagePath != null && File(stock.imagePath!).existsSync();

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
                            GestureDetector(
                              onTap: () => _showZoomImageDialog(stock),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isZeroStock ? Colors.red.shade100 : Colors.blue.shade100,
                                    child: hasValidImage
                                        ? ClipOval(
                                            child: Image.file(
                                              File(stock.imagePath!),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.child_friendly,
                                            color: isZeroStock ? Colors.red : Colors.blueAccent,
                                          ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${stock.name} - ${stock.size}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isZeroStock ? Colors.red : Colors.black,
                                        ),
                                      ),
                                      if (stock.discountPercent > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            "${stock.discountPercent.toStringAsFixed(0)}% Off",
                                            style: const TextStyle(fontSize: 11, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _addOrEditStockDialog(stock);
                                } else if (value == 'delete') {
                                  _deleteStockItem(stock);
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
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red, size: 20),
                                      SizedBox(width: 8),
                                      Text("Delete", style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 12),
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
                                    fontSize: 14,
                                    color: isZeroStock ? Colors.red : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Packets / Units: ${stock.packetsUnits} Pcs",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isZeroStock ? Colors.red : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Carton Rate: Rs. ${stock.discountedCartonRate.toStringAsFixed(0)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Packet Rate: Rs. ${stock.discountedUnitRate.toStringAsFixed(0)}",
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
class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  void _processOrder(StockItem item, int ctnQty, int unitQty) async {
    if (ctnQty == 0 && unitQty == 0) return;

    setState(() {
      item.deductStock(soldCartons: ctnQty, soldUnits: unitQty);
    });

    await saveStockToStorage();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sold: $ctnQty Ctns & $unitQty Units of ${item.name} (${item.size}). Stock saved.")),
      );
    }
  }

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
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: globalStock.length,
                itemBuilder: (context, index) {
                  final item = globalStock[index];
                  final ctnController = TextEditingController(text: "0");
                  final unitController = TextEditingController(text: "0");

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item.name} (${item.size})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Available: ${item.cartons} Ctns | ${item.packetsUnits} Packets/Units", style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: ctnController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: "Sale Ctns", border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: unitController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: "Sale Packets/Units", border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  int ctn = int.tryParse(ctnController.text) ?? 0;
                                  int unit = int.tryParse(unitController.text) ?? 0;
                                  _processOrder(item, ctn, unit);
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                                child: const Text("Deduct", style: TextStyle(color: Colors.white)),
                              )
                            ],
                          )
                        ],
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
      message.writeln("• ${item.name} (${item.size}) - ${item.qtyCartons} Ctn / ${item.qtyUnits} Pcs = Rs.${item.total.toStringAsFixed(0)}");
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
                      subtitle: Text("${item.qtyCartons} Cartons & ${item.qtyUnits} Packets/Units"),
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
