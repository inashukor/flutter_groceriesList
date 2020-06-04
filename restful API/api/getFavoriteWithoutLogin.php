<?php

include "../db/db.php";

$response = array();

$deviceInfo = $_GET['deviceInfo'];

$sql = mysqli_query($con, "SELECT b.* FROM favoriteWithoutLogin a
left join product b on a.idProduct = b.id WHERE a.deviceID='$deviceInfo'");
while ($a = mysqli_fetch_array($sql)){

    $key['id'] = $a['id'];
    $key['productName'] = $a['productName'];
    $key['productPrice'] = (int)$a['productPrice'];
    $key['createdDate'] = $a['createdDate'];
    $key['pic'] = $a['pic'];
    $key['status'] = $a['status'];
    $key['description'] = $a['description'];

    array_push($response, $key);
}

echo json_encode($response);

