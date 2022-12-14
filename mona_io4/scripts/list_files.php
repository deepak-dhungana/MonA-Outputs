<?php

    try{

        // MonA App key
        $mona_key = "853a94f5-4aae-41ca-8f1f-7b7b3d7465ab"; 

        // retrieves all the request headers
        $headers = getallheaders();

        // MonA App identity key
        $app_key = $headers["Mona-Key"];


        // check if the request is coming from known source
        if($app_key and $app_key === $mona_key){

            // connects to the FTP
            $u_name = "imckrems";
            $u_pass = "!krems123!";

            $host = "ftp.21717280951.thesite.link";

            $connection_id = ftp_connect($host);

            $login_result = ftp_login($connection_id, $u_name, $u_pass);


            // retrieve the list of EN files
            $contents_en = ftp_nlist($connection_id, './pdf_files/en'); 

            // retrieve the list of DE files
            $contents_de = ftp_nlist($connection_id, './pdf_files/de'); 

            // retrieve the list of EL files
            $contents_el = ftp_nlist($connection_id, './pdf_files/el'); 

            // retrieve the list of IT files
            $contents_it = ftp_nlist($connection_id, './pdf_files/it'); 

            // retrieve the list of NL files
            $contents_nl = ftp_nlist($connection_id, './pdf_files/nl'); 


            // retrieved the list files
            $contents = array(
                "en" => $contents_en,
                "de" => $contents_de,
                "el" => $contents_el,
                "it" => $contents_it,
                "nl" => $contents_nl
            );
            
            ftp_close($connection_id);

            if($contents){

                // return list of files
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