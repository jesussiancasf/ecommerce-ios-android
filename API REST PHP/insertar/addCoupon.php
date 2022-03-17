<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$codigo = $_POST['codigo'];
$importe = $_POST['importe'];
$stock = $_POST['stock'];
$fecha = $_POST['fecha'];

$sql="INSERT INTO `CUPON`(`CODIGO_CUPON`, `IMPORTE`, `STOCK`, `FECHA_EXPIRACION`,`ESTADO`) VALUES ('".$codigo."',".$importe.",".$stock.",'".$fecha."',1)";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
