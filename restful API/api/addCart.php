<?php

include "../db/db.php";

if($_SERVER['REQUEST_METHOD']=='POST'){

    $response = array();
    $unikID = $_POST['unikID'];
    $idProduct = $_POST['idProduct'];
    
    $cek = mysqli_query($con, "SELECT * FROM tmpCart WHERE unikID='$unikID' and idProduct='$idProduct'");
    $result = mysqli_fetch_array($cek);

    if (isset ($result)){
        $response['value'] =2;
        $response['message']= "You already have this product on cart";
        echo json_encode($response);
        
    }else{
        $cekProduct = mysqli_query($con, "SELECT * FROM product WHERE id='$idProduct'");
        $ab = mysqli_fetch_array($cekProduct);
        $price = $ab['productPrice'];

        $insert = "INSERT INTO tmpCart VALUE(NULL,'$unikID','$idProduct','1','$price',NOW())";
        if(mysqli_query($con, $insert)){
            $response['value'] = 1;
            $response['message']= "Add to Cart";
            echo json_encode($response);
        }else{
            $response['value'] =2;
            $response['message']= "Please Contact our customer services";
            echo json_encode($response);
        }

    }
}

?>