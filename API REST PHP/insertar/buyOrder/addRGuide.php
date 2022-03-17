<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$numGuia = $_POST['numGuia'];
$idCompra = $_POST['idCompra'];
$descripcion = $_POST['descripcion'];
$fecha = $_POST['fecha'];
$imagen= $_FILES['image']['name'];

$imagePath='images/guias/'.$imagen;
$tmp_name=$_FILES['image']['tmp_name'];
move_uploaded_file($tmp_name,$imagePath);

$imagenPathFile='http://18.228.156.121/casita/insertar/buyOrder/images/guias/'.$imagen;


$sql="INSERT INTO `GUIA_REMISION`(`NUM_GUIA`, `ID_COMPRA`, `DESCRIPCION`, `FECHA`, `IMAGEN`)  VALUES ('".$numGuia."',".$idCompra.",'".$descripcion."','".$fecha."','".$imagenPathFile."')";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
