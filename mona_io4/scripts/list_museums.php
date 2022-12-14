<?php

    try{

        // MonA App key
        $mona_key = "853a94f5-4aae-41ca-8f1f-7b7b3d7465ab"; 

        // retrieves all the request headers
        $headers = getallheaders();

        // MonA App identity key
        $app_key = $headers["Mona-Key"];

        if($app_key and $app_key === $mona_key){

            // connects to the FTP
            $u_name = "imckrems";
            $u_pass = "!krems123!";

            $host = "ftp.21717280951.thesite.link";

            $connection_id = ftp_connect($host);

            $login_result = ftp_login($connection_id, $u_name, $u_pass);

            // retrieve the list of folders
            $contents = ftp_nlist($connection_id, './museums');   

            ftp_close($connection_id);

            if($contents){

                // return list of folders/files
                echo json_encode(array("success" => true, "result" => $contents));

            }else{
                throw new Exception("Folder doesnot exist");
            }
        }else{
            throw new Exception("Request from unknown source");
        
        }
    }catch(Exception $e){

        // return unsuccessful result
        echo json_encode(array("success" => false, "result" => NULL));
    }
 
?>