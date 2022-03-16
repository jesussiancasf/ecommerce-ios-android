<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$sql="SELECT COMPRA.ID_COMPRA,COMPRA.MONTO,COMPRA.FECHA_COMPRA,PROVEEDOR.EMPRESA FROM `COMPRA`INNER JOIN PROVEEDOR ON COMPRA.ID_PROVEEDOR=PROVEEDOR.ID_PROVEEDOR ORDER BY COMPRA.FECHA_COMPRA DESC";
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
