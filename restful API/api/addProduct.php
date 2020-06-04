<?php

include "../db/db.php";

if($_SERVER['REQUEST_METHOD']=='POST'){

    $response = array();
    $productName = $_POST['productName'];
    $productPrice = $_POST['productPrice'];
    $description = $_POST['description'];
    $idCategory = $_POST['idCategory'];
    $idRetailer = $_POST['idRetailer'];

    $image = date('dmYHis').str_replace(" ","",basename($_FILES['image']['name']));
    $path = "../product/".$image;

    move_uploaded_file($_FILES['image']['tmp_name'], $path);
    
    $insert = "INSERT INTO product VALUE(NULL,'$idCategory','$idRetailer','$productName', '$productPrice',NOW(),'$image','1','$description')";
    if(mysqli_query($con, $insert)){
        $response['value'] = 1;
        $response['message']= "Success Add Product";
        echo json_encode($response);
    }else{
        $response['value'] =2;
        $response['message']= "Please Contact our customer services";
        echo json_encode($response);
    }

}

?>