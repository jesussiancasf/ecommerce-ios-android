<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$mPago = $_POST['pago'];
$mEnvio = $_POST['envio'];
$user = $_POST['usuario'];
$total = $_POST['total'];
$direccion = $_POST['direccion'];
$idDisrtito = $_POST['distrito'];

$sql="INSERT INTO `PEDIDO`(`FECHA_PEDIDO`, `ID_METODO_PAGO`,`ID_METODO_ENVIO`, `ID_ESTADO_PEDIDO`, `ID_USUARIO`, `TOTAL`, `DIRECCION`, `ID_DISTRITO`) VALUES 
(CONVERT_TZ(NOW(),'+00:00','-5:00'),".$mPago.",".$mEnvio.",1,'".$user."',".$total.",'".$direccion."','".$idDisrtito."')";

if(mysqli_query($conn,$sql)){

    echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

mysqli_close($conn);

?>
