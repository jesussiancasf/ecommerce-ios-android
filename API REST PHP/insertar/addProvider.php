<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$nombre = $_POST['nombre'];
$apellido = $_POST['apellido'];
$telefono = $_POST['telefono'];
$email = $_POST['email'];
$direccion = $_POST['direccion'];
$id_distrito = $_POST['id_distrito'];
$empresa = $_POST['empresa'];


$imagen= $_FILES['image']['name'];


$imagePath='images/company/'.$imagen;
$tmp_name=$_FILES['image']['tmp_name'];
move_uploaded_file($tmp_name,$imagePath);

$imagenPathFile='http://18.228.156.121/casita/insertar/images/company/'.$imagen;


$sql="INSERT INTO `PROVEEDOR` (`NOMBRE_PROVEEDOR`, `APELLIDO_PROVEEDOR`, `TELEFONO_PROVEEDOR`, `EMAIL_PROVEEDOR`, `DIRECCION`, `ID_DISTRITO`, `IMAGEN`, `EMPRESA`,`ESTADO`) VALUES ('".$nombre."','".$apellido."','".$telefono."','".$email."','".$direccion."','".$id_distrito."','".$imagenPathFile."','".$empresa."',1)";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
