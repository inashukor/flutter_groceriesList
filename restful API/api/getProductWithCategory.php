<?php

include "../db/db.php";

$response = array();

$sql = mysqli_query($con, "SELECT * FROM categoryProduct order by id asc");
while ($a = mysqli_fetch_array($sql)){

    $idCategory = $a['id'];
    $key['id'] = $idCategory;
    $key['categoryName'] = $a['categoryName'];
    $key['status'] = $a['status'];
    $key['createdDate'] = $a['createdDate'];

    $key['product'] = array();

    $query = mysqli_query($con, "SELECT * FROM product where idCategory='$idCategory'");
    while ($b = mysqli_fetch_array($query)){

        $key['product'][]=array(
            'id'=>$b['id'],
            'idCategory'=>$b['idCategory'],
            'productName'=>$b['productName'],
            'createdDate'=>$b['createdDate'],
            'pic'=>$b['pic'],
            'status'=>$b['status'],
            'description'=>$b['description'],
        );
    }

    array_push($response, $key);
}

echo json_encode($response);

