<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$idPedido = $_POST['idPedido'];

$sql="SELECT CUPON_PEDIDO.CODIGO_CUPON,CUPON.IMPORTE FROM `CUPON_PEDIDO`INNER JOIN CUPON ON CUPON_PEDIDO.CODIGO_CUPON=CUPON.CODIGO_CUPON WHERE CUPON_PEDIDO.ID_PEDIDO=".$idPedido."";
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
