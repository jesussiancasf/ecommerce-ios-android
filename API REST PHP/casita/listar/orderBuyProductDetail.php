<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$idCompra = $_POST['idCompra'];

$sql="SELECT PRODUCTO.NOMBRE_PRODUCTO,PRODUCTO.IMAGEN_PRODUCTO,DETALLE_COMPRA.CANTIDAD,DETALLE_COMPRA.PRECIO_COMPRA FROM DETALLE_COMPRA INNER JOIN PRODUCTO ON DETALLE_COMPRA.ID_PRODUCTO=PRODUCTO.ID_PRODUCTO WHERE DETALLE_COMPRA.ID_COMPRA=".$idCompra."";
mysqli_set_charset($conn, "utf8");
$json_array=array();

$retval=mysqli_query($conn,$sql);

if(mysqli_num_rows($retval)>0){

while($row=mysqli_fetch_assoc($retval)){

    $json_array[]=$row;

}
}else{
}
echo json_encode($json_array,JSON_UNESCAPED_UNICODE);
mysqli_close($conn);

?>
