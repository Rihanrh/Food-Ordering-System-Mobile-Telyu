import 'package:gtc_mobile/Models/CartItemModel.dart';
import 'package:gtc_mobile/Services/DatabaseHelper.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final _cartItems = <CartItemModel>[];

  List<CartItemModel> get cartItems => _cartItems;

  void addToCart(CartItemModel cartItem) {
    final existingItem = _cartItems.firstWhereOrNull(
      (item) => item.idTenant == cartItem.idTenant && item.idMenu == cartItem.idMenu,
    );

    if (existingItem != null) {
      existingItem.quantity += cartItem.quantity;
      DatabaseHelper.instance.updateCartItem(existingItem);
    } else {
      _cartItems.add(cartItem);
      DatabaseHelper.instance.insertCartItem(cartItem);
    }
  }

  void removeFromCart(CartItemModel cartItem) {
    final existingItem = _cartItems.firstWhereOrNull(
      (item) => item.idTenant == cartItem.idTenant && item.idMenu == cartItem.idMenu,
    );

    if (existingItem != null) {
      if (existingItem.quantity > cartItem.quantity) {
        existingItem.quantity -= cartItem.quantity;
        DatabaseHelper.instance.updateCartItem(existingItem);
      } else {
        _cartItems.remove(existingItem);
        DatabaseHelper.instance.deleteCartItem(existingItem.idTenant, existingItem.idMenu);
      }
    }
  }
}

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }
}