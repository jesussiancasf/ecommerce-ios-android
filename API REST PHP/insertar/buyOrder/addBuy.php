<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);
if(!$conn){
die("Could no connect: ".mysqli_error());
}

$monto = $_POST['monto'];
$fecha = $_POST['fecha'];
$comprobante = $_POST['comprobante'];
$tipoComprobante = $_POST['tipoComprobante'];
$idProveedor = $_POST['idProveedor'];
$imagen= $_FILES['image']['name'];

$imagePath='images/comprobantes/'.$imagen;
$tmp_name=$_FILES['image']['tmp_name'];
move_uploaded_file($tmp_name,$imagePath);

$imagenPathFile='http://18.228.156.121/casita/insertar/buyOrder/images/comprobantes/'.$imagen;


$sql="INSERT INTO `COMPRA`( `MONTO`, `FECHA_COMPRA`, `NUMERO_COMPROBANTE`,`ID_TIPO_COMPROBANTE`, `IMAGEN_COMPROBANTE`, `ID_PROVEEDOR`) VALUES (".$monto.",'".$fecha."','".$comprobante."','".$tipoComprobante."','".$imagenPathFile."',".$idProveedor.")";

if(mysqli_query($conn,$sql)){

    echo json_encode('ingresado');

}else{
   echo json_encode('Error');
   
}

mysqli_close($conn);

?>
