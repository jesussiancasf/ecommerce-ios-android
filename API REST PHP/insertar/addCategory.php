<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}


$id = $_POST['id'];
$nombre = $_POST['nombre'];
$descripcion = $_POST['descripcion'];

$imagen= $_FILES['image']['name'];


$imagePath='images/category/'.$imagen;
$tmp_name=$_FILES['image']['tmp_name'];
move_uploaded_file($tmp_name,$imagePath);

if(is_null($imagen)){
echo 'es nulo';
}else{
echo 'no es nulo';
}

$imagenPathFile='http://18.228.156.121/casita/insertar/images/category/'.$imagen;


$sql="INSERT INTO `CATEGORIA`(`ID_CATEGORIA`, `NOMBRE_CATEGORIA`, `DESCRIPCION`, `IMAGEN_CATEGORIA`,`ESTADO`) VALUES ('".$id."','".$nombre."','".$descripcion."','".$imagenPathFile."',1)";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
