import 'package:casita_del_bazar_panel_admin/clases/ubicacion/distrito.dart';
import 'package:casita_del_bazar_panel_admin/clases/ubicacion/provincia.dart';
import 'package:rxdart/rxdart.dart';

class LocationStream {
  //String idDep;
  //Provincia provincia = new Provincia();
  final _listProviceControll = BehaviorSubject<List<Provincia>>();
  final _listDistritosControll = BehaviorSubject<List<Distritos>>();

  List<Provincia> _provinceRequest = [];
  List<Distritos> _distritosRequest = [];

  Stream<List<Provincia>> get listProvicia => _listProviceControll.stream;

  Stream<List<Distritos>> get listDistritos => _listDistritosControll.stream;

  Function(List<Provincia>) get changeValueList =>
      _listProviceControll.sink.add;

  Function(List<Distritos>) get changeDistritos =>
      _listDistritosControll.sink.add;

  Future<List<Provincia>> getProvicias(String idDep) async {
    List<Provincia> listProvinciaNew = [];
    final response = await fetchPostp(idDep);
    listProvinciaNew = response;
    _provinceRequest.clear();
    _provinceRequest.addAll(listProvinciaNew);
    changeValueList(_provinceRequest);

    return listProvinciaNew;
  }

  Future<List<Distritos>> getDistritos(String idProvince) async {
    List<Distritos> listdistritosNew = [];
    final response = await fetchPostdis(idProvince);
    listdistritosNew = response;
    _distritosRequest.clear();
    _distritosRequest.addAll(listdistritosNew);
    changeDistritos(_distritosRequest);

    return listdistritosNew;
  }

  void dispose() {
    this._listProviceControll?.close();
    this._listDistritosControll?.close();
  }
}
