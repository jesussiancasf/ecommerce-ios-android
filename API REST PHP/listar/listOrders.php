<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$sql="SELECT PEDIDO.ID_PEDIDO, USUARIO.NOMBRE,USUARIO.APELLIDO,ESTADO_PEDIDO.DESCRIPCION_ESTADO,PEDIDO.FECHA_PEDIDO,PEDIDO.TOTAL FROM USUARIO INNER JOIN PEDIDO ON USUARIO.ID_USUARIO=PEDIDO.ID_USUARIO INNER JOIN ESTADO_PEDIDO ON PEDIDO.ID_ESTADO_PEDIDO=ESTADO_PEDIDO.ESTADO";
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
