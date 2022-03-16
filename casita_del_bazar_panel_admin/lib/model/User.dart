class User {
  String usuario;
  String contrasena;
  User({this.usuario, this.contrasena});

  Map<String, dynamic> toJson() =>
      {"usuario": usuario, "contrasena": contrasena};
}
