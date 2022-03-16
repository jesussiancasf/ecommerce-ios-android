import 'package:flutter/material.dart';

class OrdenProductos {
  final int idProducto;
  final String nombre;
  final double costo;
  final int cantidad;
  final String image;

  OrdenProductos(
      {this.idProducto, this.nombre, this.costo, this.cantidad, this.image});
}

class UsersProviders with ChangeNotifier {
  double _subtotal = 0;
  double _envio = 0;
  double _cupon = 0;
  double _total = 0;

  double get subtotal => _subtotal;
  double get envio => _envio;
  double get cupon => _cupon;
  double get total => _total = _subtotal + _envio + _cupon;

  set subtotal(double value) {
    this._subtotal = value;
    this.notifyListeners();
  }

  set envio(double value) {
    this._envio = value;
    this.notifyListeners();
  }

  set cupon(double value) {
    this._cupon = value;
    this.notifyListeners();
  }

  set total(double value) {
    this._total = value;
    this.notifyListeners();
  }

  List<OrdenProductos> _datos = [];

  List<OrdenProductos> get datos => _datos;

  set elemnt(OrdenProductos value) {
    this.datos.add(value);
    this.notifyListeners();
  }

  List<OrdenProductos> get datos2 => _datos;
  set delete(int index) {
    this.datos2.removeAt(index);
    this.notifyListeners();
  }

  List<OrdenProductos> get datos3 => _datos;
  set deleteAll(bool borrar) {
    if (borrar == true) {
      this.datos3.clear();
    } else {}
    this.notifyListeners();
  }
}
