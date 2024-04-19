<?php

// *** PERSONAL SETTINGS

// The email address for receiving messages sent via the contact form
$recipient_email = "info@patagoniaestudio.com.ar";

// The name of your website
$website_name = "Patagonia Estudio";

// The subject of the messages received
$subject = "[" . $website_name . "] Mensaje enviado a traves del formulario de contacto";

// *** 



$timezone_offset = $_POST["timezone_offset"];
$local_unixtime=mktime(date("H"), date("i")-$timezone_offset, date("s")-date("Z"), date("m") , date("d"), date("Y"));
$date = date("m/d/Y H:i:s", $local_unixtime);

if ($_POST["name"]) $sender_name = $_POST["name"];
if ($_POST["email"]) $sender_email = $_POST["email"];
if ($_POST["phone"]) $sender_phone = $_POST["phone"];
if ($_POST["message"]) $sender_message = $_POST["message"];

$content = $date . "\n\n";
if ($sender_name) $content .= "Nombre: " . $sender_name . "\n";
if ($sender_email) $content .= "Email: " . $sender_email . "\n";
if ($sender_phone) $content .= "Telefono: " . $sender_phone . "\n";
if ($sender_message) $content .= "\n" . $sender_message;

$headers = "MIME-Version: 1.0\r\n";
$headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
$headers .= "From: " . $sender_email . "\r\n";
$headers .= "Reply-To: " . $sender_email . "\r\n";
$headers .= "X-Mailer: PHP/" . phpversion();

if (mail($recipient_email, $subject, $content, $headers)){
	echo 'status=1';
}else{
	echo 'status=0';
}

?>

