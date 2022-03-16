import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:flutter/material.dart';

Widget getListHeaderItems(
    BuildContext context, bool esPrinicipal, _usuario, _rol) {
  return ListView(
    children: <Widget>[
      DrawerHeader(
          decoration: BoxDecoration(color: Colors.red[200]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Menú",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      _rol + " " + _usuario,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )),
      _getMenuItems(context, esPrinicipal, _usuario, _rol),
    ],
  );
}

Widget _getMenuItems(BuildContext context, bool esPrinicipal, _usuario, _rol) {
  final TextStyle estilo = TextStyle(fontSize: 16);
  return _rol == "Administrador"
      ? Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                if (!esPrinicipal) {
                  Navigator.pushReplacementNamed(context, '/',
                      arguments: UsuarioLogeado(_usuario, _rol));
                } else {}
              },
              title: Text('Inicio', style: estilo),
              leading: Icon(
                Icons.home,
                color: Colors.red[400],
              ),
            ),
            /////////////////////////////////////////////////////////////////
            ExpansionTile(
              trailing: Icon(
                Icons.arrow_drop_down,
                color: Colors.red[400],
              ),
              title: Text(
                'Gestionar Pedidos',
                style: estilo,
              ),
              leading: Icon(
                Icons.attach_money,
                color: Colors.red[400],
              ),
              children: <Widget>[
                _crearSubItems(
                    'Pedidos', estilo, context, 'pedidos', _usuario, _rol),
                _crearSubItems(
                    'Reportes', estilo, context, 'reportes', _usuario, _rol),
                _crearSubItems(
                    'Cupones', estilo, context, 'cupones', _usuario, _rol),
                _crearSubItems('Metodos de envio', estilo, context, 'envio',
                    _usuario, _rol),
              ],
            ),

            /////////////////////////////////////////////////////////////////
            ExpansionTile(
              trailing: Icon(
                Icons.arrow_drop_down,
                color: Colors.red[400],
              ),
              title: Text(
                'Datos',
                style: estilo,
              ),
              leading: Icon(
                Icons.data_usage,
                color: Colors.red[400],
              ),
              children: <Widget>[
                _crearSubItems(
                    'Productos', estilo, context, 'producto', _usuario, _rol),
                _crearSubItems('Categorías', estilo, context, 'categorias',
                    _usuario, _rol),
                _crearSubItems(
                    'Usuarios', estilo, context, 'usuarios', _usuario, _rol),
                _crearSubItems('Proveedores', estilo, context, 'proveedor',
                    _usuario, _rol),
              ],
            ),

            /////////////////////////////////////////////////////////////////
            ExpansionTile(
              trailing: Icon(
                Icons.arrow_drop_down,
                color: Colors.red[400],
              ),
              title: Text(
                'Consultas',
                style: estilo,
              ),
              leading: Icon(
                Icons.search,
                color: Colors.red[400],
              ),
              children: <Widget>[
                _crearSubItems('Consulta de pedidos', estilo, context,
                    'consultapedidos', _usuario, _rol),
                _crearSubItems('Consulta de productos', estilo, context,
                    'consultaproductos', _usuario, _rol),
                _crearSubItems('Consulta de usuarios', estilo, context,
                    'consultausuario', _usuario, _rol),
                _crearSubItems('Consulta de proveedores', estilo, context,
                    'consultaproveedor', _usuario, _rol),
                _crearSubItems('Consulta de compras', estilo, context,
                    'consultacompras', _usuario, _rol),
              ],
            ),
            /////////////////////////////////////////////////////////////////
            ExpansionTile(
              trailing: Icon(
                Icons.arrow_drop_down,
                color: Colors.red[400],
              ),
              title: Text(
                'Gestionar Compras',
                style: estilo,
              ),
              leading: Icon(
                Icons.shopping_basket,
                color: Colors.red[400],
              ),
              children: <Widget>[
                _crearSubItems(
                    'Compras', estilo, context, 'compras', _usuario, _rol),
                _crearSubItems('Guias de remisión', estilo, context,
                    'guiaremision', _usuario, _rol),
              ],
            ),

            /////////////////////////////////////////////////////////////////
            ListTile(
              title: Text(
                'Cerrar Sesión',
                style: estilo,
              ),
              leading: Icon(
                Icons.face,
                color: Colors.red[400],
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            )
          ],
        )
      : Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                if (!esPrinicipal) {
                  Navigator.pushReplacementNamed(context, '/',
                      arguments: UsuarioLogeado(_usuario, _rol));
                } else {}
              },
              title: Text('Inicio', style: estilo),
              leading: Icon(
                Icons.home,
                color: Colors.red[400],
              ),
            ),
            /////////////////////////////////////////////////////////////////
            ExpansionTile(
              trailing: Icon(
                Icons.arrow_drop_down,
                color: Colors.red[400],
              ),
              title: Text(
                'Gestionar Pedidos',
                style: estilo,
              ),
              leading: Icon(
                Icons.attach_money,
                color: Colors.red[400],
              ),
              children: <Widget>[
                _crearSubItems(
                    'Pedidos', estilo, context, 'pedidos', _usuario, _rol),
              ],
            ),

            /////////////////////////////////////////////////////////////////
            ExpansionTile(
              trailing: Icon(
                Icons.arrow_drop_down,
                color: Colors.red[400],
              ),
              title: Text(
                'Consultas',
                style: estilo,
              ),
              leading: Icon(
                Icons.search,
                color: Colors.red[400],
              ),
              children: <Widget>[
                _crearSubItems('Consulta de pedidos', estilo, context,
                    'consultapedidos', _usuario, _rol),
                _crearSubItems('Consulta de usuarios', estilo, context,
                    'consultausuario', _usuario, _rol),
              ],
            ),

            /////////////////////////////////////////////////////////////////
            ListTile(
              title: Text(
                'Cerrar Sesión',
                style: estilo,
              ),
              leading: Icon(
                Icons.face,
                color: Colors.red[400],
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            )
          ],
        );
}

Widget _crearSubItems(String nombre, TextStyle estilo, BuildContext context,
    String ruta, String _usuario, String _rol) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
    child: ListTile(
      title: Text('$nombre', style: estilo),
      onTap: () {
        Navigator.pushReplacementNamed(context, ruta,
            arguments: UsuarioLogeado(_usuario, _rol));
      },
    ),
  );
}

////////////////////////////////////////////////////////////////////
