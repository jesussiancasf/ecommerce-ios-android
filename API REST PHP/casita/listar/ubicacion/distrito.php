<?php

$host="localhost:3306";
$user="root";
$pass="KQJYOXRC1";
$bd="casita_del_bazar";
$conn=mysqli_connect($host,$user,$pass,$bd);

if(!$conn){
die("Could no connect: ".mysqli_error());
}

$provincia = $_POST['id_provincia'];

$sql="SELECT DISTRITO.ID_DISTRITO,DISTRITO.DISTRITO_NOMBRE FROM `DISTRITO` WHERE ID_PROVINCIA='".$provincia."'";
mysqli_set_charset($conn, "utf8");
$json_array=array();

$retval=mysqli_query($conn,$sql);

if(mysqli_num_rows($retval)>0){

while($row=mysqli_fetch_assoc($retval)){

    $json_array[]=$row;

}
}else{
//echo "0 resultados";
}
echo json_encode($json_array,JSON_UNESCAPED_UNICODE);
mysqli_close($conn);

?>
