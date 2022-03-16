<?php

function nuevoStock($cantidadP, $idProductoP,$conex){

    $sql2="SELECT STOCK FROM `PRODUCTO` WHERE ID_PRODUCTO=".$idProductoP."";
    $retval2=mysqli_query($conex,$sql2);
    if(mysqli_num_rows($retval2)>0){
      
        while($row2=mysqli_fetch_assoc($retval2)){
            $stockP= $row2[STOCK];
        }
        $nuevoStock=$stockP-$cantidadP;


        $sql3="UPDATE `PRODUCTO` SET `STOCK`=".$nuevoStock." WHERE ID_PRODUCTO=".$idProductoP."";
       if (mysqli_query($conex,$sql3)){
}else{}

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


$user = $_POST['usuario'];
$idProducto = $_POST['idProducto'];
$cantidad = $_POST['cantidad'];


$sql="SELECT PEDIDO.ID_PEDIDO,PEDIDO.ID_USUARIO FROM `PEDIDO` WHERE PEDIDO.ID_USUARIO='".$user."' ORDER BY ID_PEDIDO DESC LIMIT 1";


mysqli_set_charset($conn, "utf8");
$json_array=array();

$retval=mysqli_query($conn,$sql);

if(mysqli_num_rows($retval)>0){

while($row=mysqli_fetch_assoc($retval)){

    $idPedido= $row[ID_PEDIDO];

}

$sql2="INSERT INTO `DETALLE_PEDIDO`(`ID_PRODUCTO`, `ID_PEDIDO`, `CANTIDAD`) VALUES 
(".$idProducto.",".$idPedido.",".$cantidad.")";

if(mysqli_query($conn,$sql2)){

    nuevoStock($cantidad, $idProducto,$conn);
  echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

}else{
}
mysqli_close($conn);


?>
