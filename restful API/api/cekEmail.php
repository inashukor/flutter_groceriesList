<?php

include "../db/db.php";

if ($_SERVER["REQUEST_METHOD"]=="POST"){

    $response = array();
    $email = $_POST['email'];
    $token = $_POST['token'];

    $cekEmail = mysqli_query($con, "SELECT * FROM users WHERE email='$email'");
    $cek = mysqli_fetch_array($cekEmail);

    if (isset($cek)){
        $update = mysqli_query($con, "UPDATE users SET token='$token' WHERE email='$email'");

        $response['id'] = $cek['id'];
        $response['name'] = $cek['name'];
        $response['email'] = $cek['email'];
        $response['phone'] = $cek['phone'];
        $response['createdDate'] = $cek['createdDate'];
        $response['level'] = $cek['level'];

        $response['value'] = 1;
        $response['message'] = "Success";
        echo json_encode($response);
    } else{
        $response['value'] = 0;
        $response['message'] = "Your email not found";
        echo json_encode($response);
    }
}

?>