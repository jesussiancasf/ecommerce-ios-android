import 'package:casita_del_bazar_panel_admin/pages/categoria.dart';
import 'package:casita_del_bazar_panel_admin/pages/compras.dart';
import 'package:casita_del_bazar_panel_admin/pages/consulta_compras.dart';
import 'package:casita_del_bazar_panel_admin/pages/consulta_pedidos.dart';
import 'package:casita_del_bazar_panel_admin/pages/consulta_productos.dart';
import 'package:casita_del_bazar_panel_admin/pages/consulta_proveedores.dart';
import 'package:casita_del_bazar_panel_admin/pages/consulta_usuarios.dart';
import 'package:casita_del_bazar_panel_admin/pages/cupones.dart';
import 'package:casita_del_bazar_panel_admin/pages/guia_remision.dart';
import 'package:casita_del_bazar_panel_admin/pages/home_page.dart';
import 'package:casita_del_bazar_panel_admin/pages/login.dart';
import 'package:casita_del_bazar_panel_admin/pages/metodos_envio.dart';
import 'package:casita_del_bazar_panel_admin/pages/pedidos.dart';
import 'package:casita_del_bazar_panel_admin/pages/productos.dart';
import 'package:casita_del_bazar_panel_admin/pages/proveedores.dart';
import 'package:casita_del_bazar_panel_admin/pages/reportes.dart';
import 'package:casita_del_bazar_panel_admin/pages/usuarios.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationsRoutes() {
  return <String, WidgetBuilder>{
    'login': (BuildContext context) => Login(),
    '/': (BuildContext context) => HomePage(),
    'pedidos': (BuildContext context) => Pedidos(),
    'reportes': (BuildContext context) => Reportes(),
    'cupones': (BuildContext context) => Cupones(),
    'envio': (BuildContext context) => MetodosEnvio(),
    'producto': (BuildContext context) => Productos(),
    'categorias': (BuildContext context) => Categoria(),
    'usuarios': (BuildContext context) => Usuarios(),
    'proveedor': (BuildContext context) => Proveedor(),
    'consultapedidos': (BuildContext context) => ConsultaPedidos(),
    'consultaproductos': (BuildContext context) => ConsultarProductos(),
    'consultausuario': (BuildContext context) => ConsultaUsuario(),
    'consultaproveedor': (BuildContext context) => ConsultarProveedor(),
    'consultacompras': (BuildContext context) => ConsultarCompras(),
    'guiaremision': (BuildContext context) => GuiaRemision(),
    'compras': (BuildContext context) => Compras(),
  };
}
