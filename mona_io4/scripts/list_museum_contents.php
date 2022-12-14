<?php

    try{
        
        // MonA App key
        $mona_key = "853a94f5-4aae-41ca-8f1f-7b7b3d7465ab"; 

        // retrieves all the request headers
        $headers = getallheaders();

        // if the key "Folder-Name" exists then the value is takes, else false
        $folder_name = $headers["Folder-Name"];

        // MonA App identity key
        $app_key = $headers["Mona-Key"];
        
        // go forward if the header "Folder-Name" exists
        if($app_key and $folder_name and $app_key === $mona_key){

            // connects to the FTP
            $u_name = "imckrems";
            $u_pass = "!krems123!";

            $host = "ftp.21717280951.thesite.link";

            $connection_id = ftp_connect($host);

            $login_result = ftp_login($connection_id, $u_name, $u_pass);
            
            // retrieve the list of files
            $contents = ftp_nlist($connection_id, $folder_name);

            ftp_close($connection_id);

            // go forward if such folder exists 
            if($contents){

                // return list of files
                echo json_encode(array("success" => true, "result" => $contents));

            }
            // else throw exception
            else{
                throw new Exception("Folder does not exist");
            }
        }else{
            throw new Exception("Header does not exist in the request");
        }
    }catch(Exception $e){

        // return unsuccessful result
        echo json_encode(array("success" => false, "result" => NULL));
    }

?>