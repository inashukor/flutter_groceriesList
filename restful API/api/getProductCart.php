<?php

include "../db/db.php";

$response = array();
$unikID = $_GET['unikID'];

$sql = mysqli_query($con, "SELECT b.*, a.qty FROM tmpCart a 
left join product b on a.idProduct = b.id 
where a.unikID = '$unikID'");
while ($a = mysqli_fetch_array($sql)){

    $key['id'] = $a['id'];
    $key['productName'] = $a['productName'];
    $key['productPrice'] = (int)$a['productPrice'];
    $key['createdDate'] = $a['createdDate'];
    $key['pic'] = $a['pic'];
    $key['status'] = $a['status'];
    $key['description'] = $a['description'];
    $key['qty'] = $a['qty'];

    array_push($response, $key);
}

echo json_encode($response);

