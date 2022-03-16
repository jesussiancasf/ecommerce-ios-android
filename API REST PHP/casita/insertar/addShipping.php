<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$metodo = $_POST['metodo'];
$descripcion = $_POST['descripcion'];
$precio = $_POST['precio'];

$sql="INSERT INTO `METODO_ENVIO`(`METODO`, `COSTO`, `DESCRIPCION`,`ESTADO`) VALUES ('".$metodo."',".$precio.",'".$descripcion."',1)";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
