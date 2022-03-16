<?php

function nuevoStockProducto( $idProductos,$conex,$sumaStock){

    $sql2="SELECT PRODUCTO.STOCK FROM PRODUCTO WHERE PRODUCTO.ID_PRODUCTO=".$idProductos."";
    $retval2=mysqli_query($conex,$sql2);

    if(mysqli_num_rows($retval2)>0){
      
        while($row2=mysqli_fetch_assoc($retval2)){
        
            $stockP= $row2[STOCK];
       
        }
        $nuevoStock=$stockP+$sumaStock;
        $sql3="UPDATE `PRODUCTO` SET `STOCK` =".$nuevoStock." WHERE ID_PRODUCTO=".$idProductos."";

  if(mysqli_query($conex,$sql3)){



}else{

}

    }


}


$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$idProducto = $_POST['idProducto'];
$cantidad = $_POST['cantidad'];
$pCompra = $_POST['pCompra'];
$nComprobante = $_POST['nComprobante'];
$idProveedor= $_POST['idProveedor'];


$sql="SELECT COMPRA.ID_COMPRA FROM `COMPRA` WHERE COMPRA.ID_PROVEEDOR=".$idProveedor." AND COMPRA.NUMERO_COMPROBANTE='".$nComprobante."' ORDER BY COMPRA.ID_COMPRA DESC LIMIT 1";

mysqli_set_charset($conn, "utf8");

$retval=mysqli_query($conn,$sql);

if(mysqli_num_rows($retval)>0){

while($row=mysqli_fetch_assoc($retval)){

    $idCompra= $row[ID_COMPRA];

}

$sql2="INSERT INTO `DETALLE_COMPRA`(`ID_COMPRA`, `ID_PRODUCTO`, `CANTIDAD`, `PRECIO_COMPRA`) VALUES (".$idCompra.",".$idProducto.",".$cantidad.",".$pCompra.")";

if(mysqli_query($conn,$sql2)){

    echo json_encode('Ingresado');
    nuevoStockProducto( $idProducto,$conn,$cantidad);

}else{
    echo json_encode('Error');

}

}else{
    echo json_encode('Error');
}

mysqli_close($conn);


?>
