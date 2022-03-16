<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$idEnvio = $_POST['idEnvio'];


$sql="UPDATE `METODO_ENVIO` SET `ESTADO`=0 WHERE `ID_METODO`=".$idEnvio."";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
