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
$descripcion = $_POST['descripcion'];
$peso = $_POST['peso'];
$precio = $_POST['precio'];
$precioReducido = $_POST['precioReducido'];
$id_categoria = $_POST['id_categoria'];
$stock = $_POST['stock'];


$imagen= $_FILES['image']['name'];


$imagePath='images/products/'.$imagen;
$tmp_name=$_FILES['image']['tmp_name'];
move_uploaded_file($tmp_name,$imagePath);

$imagenPathFile='http://18.228.156.121/casita/insertar/images/products/'.$imagen;


$sql="INSERT INTO `PRODUCTO`(`NOMBRE_PRODUCTO`, `DESCRIPCION`, `PESO`, `IMAGEN_PRODUCTO`,`PRECIO`, `PRECIO_REDUCIDO`, `ID_CATEGORIA`, `STOCK`,`ESTADO`) VALUES ('".$nombre."','".$descripcion."',".$peso.",'".$imagenPathFile."',".$precio.",".$precioReducido.",'".$id_categoria."',".$stock.",1)";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
