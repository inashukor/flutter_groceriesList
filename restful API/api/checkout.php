<?php

include "../db/db.php";

if($_SERVER['REQUEST_METHOD']=='POST'){

    $response = array();
    $idUsers = $_POST['idUsers'];
    $unikID = $_POST['unikID'];
    $noList = date('Ymdhis');

    $cekTmpCart = mysqli_query($con, "SELECT * FROM tmpcart WHERE unikID='$unikID'");
    $cek = mysqli_fetch_array($cekTmpCart);
    if(isset($cek)){

        $insertNoList = "INSERT INTO list VALUE(NULL,'$noList',NOW(),'$idUsers','0')";
        if(mysqli_query($con,$insertNoList)){

            $tmpCart = mysqli_query($con, "SELECT * FROM tmpcart WHERE unikID= '$unikID'");
            while($a = mysqli_fetch_array($tmpCart)){

                $idProduct = $a['idProduct'];
                $qty = $a['qty'];
                $price =$a['price'];

                $insertDetail= mysqli_query($con,"INSERT INTO listdetail VALUE(NULL,'$noList','$idProduct','$qty','$price','0')");
                
            }

            $delete = mysqli_query($con, "DELETE FROM tmpcart WHERE unikID= '$unikID'");
            $response['value']=1;
            $response['message'] = "Successfully add to your list";
            echo json_encode($response);

        }else{
            $response['value']=0;
            $response['message'] = "Please try again";
            echo json_encode($response);
        }

    }else{
        $response['value']=0;
        $response['message'] = "Please choose your product";
        echo json_encode($response);

    }
}


?>