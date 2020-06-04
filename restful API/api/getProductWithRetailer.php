<?php

include "../db/db.php";

$response = array();

$sql = mysqli_query($con, "SELECT * FROM retailer order by id asc");
while ($a = mysqli_fetch_array($sql)){

    $idRetailer = $a['id'];
    $key['id'] = $idRetailer;
    $key['retailerName'] = $a['retailerName'];
    $key['status'] = $a['status'];
    $key['createdDate'] = $a['createdDate'];

    $key['product_retailer'] = array();

    $query = mysqli_query($con, "SELECT * FROM product_retailer where idRetailer='$idRetailer'");
    while ($b = mysqli_fetch_array($query)){

        $key['product_retailer'][]=array(
            'id'=>$b['id'],
            'idProduct'=>$b['idProduct'],
            'idRetailer'=>$b['idRetailer'],
            'productPrice'=>(int)$b['productPrice'],
          
        );
    }

    array_push($response, $key);
}

echo json_encode($response);

