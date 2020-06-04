<?php

include "../db/db.php";

if($_SERVER['REQUEST_METHOD']=='POST'){

    $response = array();
    $deviceInfo = $_POST['deviceInfo'];
    $idProduct = $_POST['idProduct'];
    
    $cek = mysqli_query($con, "SELECT * FROM favoriteWithoutLogin WHERE deviceID='$deviceInfo' and idProduct='$idProduct'");
    $result = mysqli_fetch_array($cek);

    if (isset ($result)){
        $insert = "DELETE FROM favoriteWithoutLogin WHERE deviceID='$deviceInfo' and idProduct='$idProduct'";
        if(mysqli_query($con, $insert)){
            $response['value'] = 1;
            $response['message']= "Delete from Favourite";
            echo json_encode($response);
        }else{
            $response['value'] =2;
            $response['message']= "Please Contact our customer services";
            echo json_encode($response);
        }
    }else{
        $insert = "INSERT INTO favoritewithoutlogin VALUE(NULL,'$deviceInfo','$idProduct',NOW())";
        if(mysqli_query($con, $insert)){
            $response['value'] = 1;
            $response['message']= "Add to Favourite";
            echo json_encode($response);
        }else{
            $response['value'] =2;
            $response['message']= "Please Contact our customer services";
            echo json_encode($response);
        }

    }
}

?>