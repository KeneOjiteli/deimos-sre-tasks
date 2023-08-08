<?php  
$host = getenv('DB_HOST'); #mysql service
$db_name = getenv('MYSQL_DATABASE');
$username = getenv('MYSQL_USER');
$password = getenv('MYSQL_PASSWORD');

try{
$connection = new PDO("mysql:host=" . $host . ";dbname=" . $db_name, $username, $password);
$connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); #enabled error reporting via PDOexceptions
$connection->exec("set names utf8");
}catch(Exception $exception){
echo "Connection error: " . $exception->getMessage();
}

function saveData($name, $email, $message){
global $connection;
$query = "INSERT INTO martians(name, email, message) VALUES( :name, :email, :message)";

$callToDb = $connection->prepare( $query );
$name=htmlspecialchars(strip_tags($name));
$email=htmlspecialchars(strip_tags($email));
$message=htmlspecialchars(strip_tags($message));
$callToDb->bindParam(":name",$name);
$callToDb->bindParam(":email",$email);
$callToDb->bindParam(":message",$message);

if($callToDb->execute()){
return '<body style="background-color:#212529;">
<h2 style="text-align:center; color:white; margin-top:20px;">Form Submitted, We will get back to you very shortly!</h2>
</body>
';
}
}

if( isset($_POST['submit'])){
$name = htmlentities($_POST['name']);
$email = htmlentities($_POST['email']);
$message = htmlentities($_POST['message']);

// then you can use them in a PHP function. 
$result = saveData($name, $email, $message);
echo $result;
}
else{
    echo '<body style="background-color:#212529;">
    <h2 style="text-align:center; color:white; margin-top:20px;">Something went wrong!</h2>
    </body>
    ';
}
?>