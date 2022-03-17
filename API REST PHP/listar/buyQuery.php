<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$sql="SELECT PROVEEDOR.NOMBRE_PROVEEDOR, PROVEEDOR.APELLIDO_PROVEEDOR,PROVEEDOR.TELEFONO_PROVEEDOR,PROVEEDOR.EMAIL_PROVEEDOR,PROVEEDOR.EMPRESA,COMPRA.ID_COMPRA,COMPRA.FECHA_COMPRA,COMPRA.MONTO,COMPRA.NUMERO_COMPROBANTE,TIPO_COMPROBANTE.DETALLE_COMPROBANTE,COMPRA.IMAGEN_COMPROBANTE FROM PROVEEDOR INNER JOIN COMPRA ON PROVEEDOR.ID_PROVEEDOR=COMPRA.ID_PROVEEDOR INNER JOIN TIPO_COMPROBANTE ON COMPRA.ID_TIPO_COMPROBANTE=TIPO_COMPROBANTE.ID_TIPO_COMPROBANTE";
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
