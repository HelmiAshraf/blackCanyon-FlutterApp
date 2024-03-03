import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_page.dart';
import 'login.dart';
import 'order_page.dart';

class MenuPage extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String opt;

  MenuPage({required this.phoneNumber, required this.name, required this.opt});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<MenuItem> _menus = [];
  List<String> _cartItems = [];
  List<MenuItem> _filteredMenus = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    final url = 'http://10.0.2.2/blackcApi/menu.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        _menus = data.map((item) => MenuItem.fromJson(item)).toList();
        _filteredMenus = _menus;
      });
    } else {
      print('Failed to fetch menus');
    }
  }

  Future<void> addToCart(MenuItem menuItem) async {
    final url = 'http://10.0.2.2/blackcApi/add_cart.php';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'phnum': widget.phoneNumber,
        'id_menu': menuItem.id,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _cartItems.add(menuItem.id);
      });
    } else {
      print('Failed to add to cart');
    }
  }

  void signOut() async {
    final url = 'http://10.0.2.2/blackcApi/signOut.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      print('Failed to sign out');
    }
  }

  bool isItemInCart(MenuItem menuItem) {
    return _cartItems.contains(menuItem.id);
  }

  void filterMenus(String query) {
    setState(() {
      _filteredMenus = _menus
          .where((menuItem) =>
              menuItem.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Color.fromRGBO(180, 45, 46, 1),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    phoneNumber: widget.phoneNumber,
                    name: widget.name,
                    opt: widget.opt,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.receipt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderPage(
                    phoneNumber: widget.phoneNumber,
                    name: widget.name,
                    opt: widget.opt,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: filterMenus,
                decoration: InputDecoration(
                  hintText: 'Search Menu',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      filterMenus('');
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredMenus.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final menuItem = _filteredMenus[index];
                return ListTile(
                  title: Text(menuItem.name),
                  subtitle: Text(
                    'Price: RM ${menuItem.price.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isItemInCart(menuItem)
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      color: isItemInCart(menuItem)
                          ? Color.fromRGBO(180, 45, 46, 1)
                          : null,
                    ),
                    onPressed: isItemInCart(menuItem)
                        ? null
                        : () {
                            addToCart(menuItem);
                          },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final double price;

  MenuItem({required this.id, required this.name, required this.price});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
    );
  }
}
