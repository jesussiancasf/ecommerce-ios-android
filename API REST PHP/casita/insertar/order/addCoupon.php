<?php

function nuevoStockCupon( $idCupon,$conex){

    $sql2="SELECT STOCK FROM `CUPON` WHERE CUPON.CODIGO_CUPON='".$idCupon."'";
    $retval2=mysqli_query($conex,$sql2);

    if(mysqli_num_rows($retval2)>0){

        while($row2=mysqli_fetch_assoc($retval2)){
        
            $stockP= $row2[STOCK];
        
        }
        $nuevoStock=$stockP-1;
        $sql3="UPDATE `CUPON` SET `STOCK`=".$nuevoStock." WHERE CUPON.CODIGO_CUPON='".$idCupon."'";

  if(mysqli_query($conex,$sql3)){}else{}

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


$usuario = $_POST['usuario'];
$idCupon = $_POST['idCupon'];


$sql="SELECT PEDIDO.ID_PEDIDO FROM `PEDIDO` WHERE PEDIDO.ID_USUARIO='".$usuario."' ORDER BY ID_PEDIDO DESC LIMIT 1";


mysqli_set_charset($conn, "utf8");
$json_array=array();

$retval=mysqli_query($conn,$sql);

if(mysqli_num_rows($retval)>0){

while($row=mysqli_fetch_assoc($retval)){

    $idPedido= $row[ID_PEDIDO];

}
$sql2="INSERT INTO `CUPON_PEDIDO`(`CODIGO_CUPON`, `ID_PEDIDO`) VALUES ('".$idCupon."',".$idPedido.")";


if(mysqli_query($conn,$sql2)){

    //echo json_encode('Ingresado');
    nuevoStockCupon($idCupon,$conn);
echo json_encode('Ingresado');

}else{
    echo json_encode('Error');

}

}else{
}
mysqli_close($conn);


?>
