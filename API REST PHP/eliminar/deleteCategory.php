<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$idCategoria = $_POST['idCategoria'];


$sql="UPDATE `CATEGORIA` SET `ESTADO`=0 WHERE ID_CATEGORIA='".$idCategoria."'";


if(mysqli_query($conn,$sql)){

  $sql2="UPDATE `PRODUCTO` SET `ID_CATEGORIA`='otros' WHERE ID_CATEGORIA='".$idCategoria."'";

  if(mysqli_query($conn,$sql2)){
    echo json_encode('Ingresado');
  }else{
    echo json_encode('Error');
  }

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
