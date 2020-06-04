<?php

include "../db/db.php";

$response = array();

$simpan = mysqli_query($con, "SELECT * FROM product order by id desc");
while ($a = mysqli_fetch_array($simpan)){

    $key['id'] = $a['id'];
    $key['productName'] = $a['productName'];
    $key['createdDate'] = $a['createdDate'];
    $key['pic'] = $a['pic'];
    $key['status'] = $a['status'];
    $key['description'] = $a['description'];

    array_push($response, $key);
}

echo json_encode($response);

