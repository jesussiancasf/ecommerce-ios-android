<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}


$sql="SELECT PRODUCTO.ID_PRODUCTO,PRODUCTO.NOMBRE_PRODUCTO,PRODUCTO.PRECIO,PRODUCTO.PRECIO_REDUCIDO,PRODUCTO.STOCK,PRODUCTO.IMAGEN_PRODUCTO,CATEGORIA.NOMBRE_CATEGORIA FROM PRODUCTO INNER JOIN CATEGORIA ON PRODUCTO.ID_CATEGORIA=CATEGORIA.ID_CATEGORIA WHERE PRODUCTO.ESTADO=1";
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
