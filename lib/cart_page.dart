import 'dart:convert';
import 'package:blackcanyon/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'order_page.dart';

class CartPage extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String opt;

  CartPage({
    required this.phoneNumber,
    required this.name,
    required this.opt,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class CartItem {
  final String id;
  final String name;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      quantity: int.parse(json['qty']),
      price: double.parse(json['price']),
    );
  }

  void updatePrice(double newPrice) {
    price = newPrice;
  }
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];
  Map<String, bool> isEditingQuantityMap = {};
  Map<String, int> editedQuantityMap = {};

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final url = 'http://10.0.2.2/blackcApi/cart.php';
    final response =
        await http.get(Uri.parse('$url?phnum=${widget.phoneNumber}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        _cartItems = data.map((item) => CartItem.fromJson(item)).toList();
        for (var cartItem in _cartItems) {
          isEditingQuantityMap[cartItem.id] = false;
          editedQuantityMap[cartItem.id] = cartItem.quantity;
        }
      });
    } else {
      print('Failed to fetch cart items');
    }
  }

  Future<void> updateCartItemQuantity(String idMenu, int newQuantity) async {
    final url = 'http://10.0.2.2/blackcApi/update_cart.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'phnum': widget.phoneNumber,
        'id_menu': idMenu,
        'quantity': newQuantity.toString(),
        'price': (newQuantity *
                _cartItems.firstWhere((item) => item.id == idMenu).price)
            .toString(),
      },
    );

    if (response.statusCode == 200) {
      final String responseBody = response.body;
      if (responseBody == 'Cart item quantity and price updated successfully') {
        print('Cart item quantity and price updated successfully');

        setState(() {
          final cartItem = _cartItems.firstWhere((item) => item.id == idMenu);
          cartItem.quantity = newQuantity;
          cartItem.price = newQuantity * cartItem.price;
          isEditingQuantityMap[idMenu] = false;
          editedQuantityMap[idMenu] = newQuantity;
        });
      } else {
        print('Failed to update cart item quantity and price');
      }
    } else {
      print(
          'Failed to update cart item quantity and price: ${response.statusCode}');
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var cartItem in _cartItems) {
      totalPrice += cartItem.price;
    }
    return totalPrice;
  }

  Future<void> navigateToOrderPage() async {
    await fetchCartItems(); // Fetch the latest cart items before navigating

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuPage(
          phoneNumber: widget.phoneNumber,
          name: widget.name,
          opt: widget.opt,
        ),
      ),
    );
  }

  Future<void> addOrder() async {
    final url = 'http://10.0.2.2/blackcApi/add_order.php';

    // Generate the current date
    final now = DateTime.now();
    final currentDate =
        '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'phnum': widget.phoneNumber,
        'total_price': getTotalPrice().toString(),
        'date': currentDate,
      },
    );

    if (response.statusCode == 200) {
      final String responseBody = response.body;
      if (responseBody == 'Order added successfully') {
        print('Order added successfully');
      } else {
        print('Failed to add order');
      }
    } else {
      print('Failed to add order: ${response.statusCode}');
    }
  }

  Future<void> deleteCartItem(String idMenu) async {
    final url = 'http://10.0.2.2/blackcApi/delete_cart.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id_menu': idMenu,
      },
    );

    if (response.statusCode == 200) {
      final String responseBody = response.body;
      if (responseBody == 'Cart item deleted successfully') {
        print('Cart item deleted successfully');

        setState(() {
          _cartItems.removeWhere((item) => item.id == idMenu);
        });
      } else {
        print('Failed to delete cart item');
      }
    } else {
      print('Failed to delete cart item: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Color.fromRGBO(180, 45, 46, 1),
      ),
      body: Column(
        children: [
          if (_cartItems.isEmpty)
            const Text('No items in the cart.')
          else
            Expanded(
              child: ListView.separated(
                itemCount: _cartItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final cartItem = _cartItems[index];
                  final isEditingQuantity =
                      isEditingQuantityMap[cartItem.id] ?? false;
                  final editedQuantity =
                      editedQuantityMap[cartItem.id] ?? cartItem.quantity;

                  return ListTile(
                    title: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteCartItem(cartItem.id);
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Price: \RM ${cartItem.price.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                        if (isEditingQuantity)
                          Container(
                            width: 21,
                            child: TextFormField(
                              initialValue: editedQuantity.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  editedQuantityMap[cartItem.id] =
                                      int.tryParse(value) ?? 1;
                                });
                              },
                            ),
                          )
                        else
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        Container(
                          width: 50,
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              IconButton(
                                icon: isEditingQuantity
                                    ? const Icon(Icons.save)
                                    : const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    isEditingQuantityMap[cartItem.id] =
                                        !isEditingQuantity;
                                    if (!isEditingQuantity) {
                                      editedQuantityMap[cartItem.id] =
                                          cartItem.quantity;
                                    } else {
                                      updateCartItemQuantity(
                                          cartItem.id, editedQuantity);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Total Price: \RM ${getTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addOrder();
              navigateToOrderPage();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(180, 45, 46, 1),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10), // Adjust the padding size as needed
              child: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
