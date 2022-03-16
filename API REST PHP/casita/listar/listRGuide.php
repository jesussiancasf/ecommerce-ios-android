<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$sql="SELECT GUIA_REMISION.NUM_GUIA,GUIA_REMISION.FECHA,PROVEEDOR.EMPRESA FROM `GUIA_REMISION` INNER JOIN COMPRA ON GUIA_REMISION.ID_COMPRA=COMPRA.ID_COMPRA INNER JOIN PROVEEDOR ON COMPRA.ID_PROVEEDOR=PROVEEDOR.ID_PROVEEDOR";
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
