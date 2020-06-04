<?php

include "../db/db.php";

if($_SERVER['REQUEST_METHOD']=='POST'){

    $response = array();
    $unikID = $_POST['unikID'];
    $idProduct = $_POST['idProduct'];
    $tipe = $_POST['tipe'];
    
    $cek = mysqli_query($con, "SELECT * FROM tmpCart WHERE unikID='$unikID' and idProduct='$idProduct'");
    $result = mysqli_fetch_array($cek);
    $qty = $result['qty'];

    if (isset ($result)){
        if($tipe == "tambah"){
            $insert = "UPDATE tmpCart SET qty = qty + 1 WHERE unikID='$unikID' and idProduct='$idProduct' ";
            if(mysqli_query($con, $insert)){
                $response['value'] = 1;
                $response['message']= "";
                echo json_encode($response);
            }else{
                $response['value'] =2;
                $response['message']= "Please Contact our customer services";
                echo json_encode($response);
            }

        }else{
            if($qty == "1"){
                $insert = "DELETE FROM tmpCart WHERE unikID='$unikID' and idProduct='$idProduct' ";
                if(mysqli_query($con, $insert)){
                    $response['value'] = 1;
                    $response['message']= "";
                    echo json_encode($response);
                }else{
                    $response['value'] =2;
                    $response['message']= "Please Contact our customer services";
                    echo json_encode($response);
                }

            }else{
                $insert = "UPDATE tmpCart SET qty =qty - 1 WHERE unikID='$unikID' and idProduct='$idProduct' ";
                if(mysqli_query($con, $insert)){
                    $response['value'] = 1;
                    $response['message']= "";
                    echo json_encode($response);
                }else{
                    $response['value'] =2;
                    $response['message']= "Please Contact our customer services";
                    echo json_encode($response);
                }

            }
        
        }
        
    }else{
        $response['value'] =2;
        $response['message']= "Please Contact our customer services";
        echo json_encode($response);
    }
}

?>