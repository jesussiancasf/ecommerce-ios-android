import 'package:casita_del_bazar_panel_admin/clases/usuarioLoged.dart';
import 'package:casita_del_bazar_panel_admin/utils/drawer_menu.dart';
import 'package:flutter/material.dart';

class Reportes extends StatefulWidget {
  @override
  _ReportesState createState() => _ReportesState();
}

class _ReportesState extends State<Reportes> {
  String _fecha = '';
  TextEditingController _inputFieldDateController = new TextEditingController();
  final TextStyle _estiloTabla = TextStyle(fontSize: 15, color: Colors.green);

  @override
  Widget build(BuildContext context) {
    final UsuarioLogeado _args = ModalRoute.of(context).settings.arguments;
    String _usuario = _args.usuario;

    String _rol = _args.rol;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Reportes',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white),
      drawer: Drawer(
        child: getListHeaderItems(context, false, _usuario, _rol),
      ),
      body: ListView(
        children: <Widget>[
          ////////////////////////////////////////////////////////

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Hoy'),
                ),
                Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Una semana'),
                ),
                Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Un mes'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Column(
              children: <Widget>[
                _crearFecha(context, 'Fecha inicio'),
                _crearFecha(context, 'Fecha fin'),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Filtrar resultados'),
                    ))
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 50),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                        label: Text(
                      'ID',
                      style: _estiloTabla,
                    )),
                    DataColumn(label: Text('Nombre', style: _estiloTabla)),
                    DataColumn(label: Text('Fecha', style: _estiloTabla)),
                    DataColumn(label: Text('Estado', style: _estiloTabla)),
                    DataColumn(label: Text('Total', style: _estiloTabla)),
                  ],
                  columnSpacing: 20,
                  rows: [
                    _agregarData(
                      'iddsd',
                      'iddsd',
                      'iddsd',
                      'iddsd',
                      'iddsd',
                    ),
                    _agregarData(
                      'iddsd',
                      'iddsd',
                      'iddsd',
                      'iddsd',
                      'iddsd',
                    ),
                    _agregarData(
                      'iddsd',
                      'iddsd',
                      'iddsd',
                      'iddsd',
                      'iddsd',
                    ),
                  ]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('652', style: TextStyle(fontSize: 30)),
                      Text('Pedidos')
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('S./6985', style: TextStyle(fontSize: 30)),
                      Text('Monto de ventas')
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Exportar reporte'),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////
  ///
  DataRow _agregarData(
      String id, String nombre, String fecha, String estado, String total) {
    return DataRow(
      cells: [
        DataCell(Text('user2')),
        DataCell(Text('name-b')),
        DataCell(Text('name-a')),
        DataCell(Text('name-a')),
        DataCell(Text('name-a')),
      ],
      onSelectChanged: (newValue) {
        print('row 2 pressed');
      },
    );
  }

  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////
  Widget _crearFecha(BuildContext context, String fecha) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: TextField(
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: fecha,
          labelText: fecha,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
      ),
    );
  }

  //////////////////////////////////////////////////////////////////

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),

      //   locale: Locale('es', 'ES')
    );

    if (picked != null) {
      setState(() {
        _fecha = picked.toString();
        _inputFieldDateController.text = _fecha;
      });
    }
  }
}
