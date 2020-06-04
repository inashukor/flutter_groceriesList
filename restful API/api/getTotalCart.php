<?php

include "../db/db.php";

$response = array();
$unikID = $_GET['unikID'];

$sql = mysqli_query($con, "SELECT count(*) total FROM `tmpCart` WHERE unikID = '$unikID'");
while ($a = mysqli_fetch_array($sql)){

    $key['total'] = $a['total'] ?? "0";
  
    array_push($response, $key);
}

echo json_encode($response);

