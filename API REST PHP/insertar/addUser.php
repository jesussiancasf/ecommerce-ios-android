<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$usuario = $_POST['usuario'];
$nombre = $_POST['nombre'];
$apellido = $_POST['apellido'];
$telefono = $_POST['telefono'];
$email = $_POST['email'];
$direccion = $_POST['direccion'];
$contrasena = $_POST['contrasena'];
$id_distrito = $_POST['id_distrito'];
$id_rol = $_POST['id_rol'];

$imagen= $_FILES['image']['name'];


$imagePath='images/profile/'.$imagen;
$tmp_name=$_FILES['image']['tmp_name'];
move_uploaded_file($tmp_name,$imagePath);

$imagenPathFile='http://18.228.156.121/casita/insertar/images/profile/'.$imagen;


$sql="INSERT INTO `USUARIO` (`ID_USUARIO`,`NOMBRE`,`APELLIDO`, `TELEFONO`,`EMAIL`,`DIRECCION`,`CONTRASENA`, `ID_DISTRITO`,`ID_ROL`,`IMAGEN`,`ESTADO`) VALUES ('".$usuario."','".$nombre."','".$apellido."','".$telefono."','".$email."','".$direccion."','".$contrasena."','".$id_distrito."','".$id_rol."','".$imagenPathFile."',1)";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>

