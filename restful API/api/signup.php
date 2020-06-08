<?php

include "../db/db.php";

if ($_SERVER["REQUEST_METHOD"]=="POST"){

    $response = array();
    $email = $_POST['email'];
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $token = $_POST['token'];

    $cekEmail = mysqli_query($con, "SELECT * FROM users WHERE phone='$phone'");
    $cek = mysqli_fetch_array($cekEmail);

    if (isset($cek)){
        $response['value'] = 0;
        $response['message'] = "Phone number already registered";
        echo json_encode($response);
    } else{
        $insert = "INSERT INTO users VALUE(NULL,'$email','$phone','$name',NOW(),'1','1','$token')";
        if(mysqli_query($con,$insert)){
            $response['value'] = 1;
            $response['message'] = "Success";
            echo json_encode($response);
        }else{
            $response['value'] = 0;
            $response['message'] = "Failed";
            echo json_encode($response);
        }
    }
}

?>