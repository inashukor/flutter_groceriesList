<?php

include "../db/db.php";

$response = array();

$sql = mysqli_query($con, "SELECT * FROM product order by id desc");
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

