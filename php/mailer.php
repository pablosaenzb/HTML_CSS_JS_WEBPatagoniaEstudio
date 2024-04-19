<?php

// *** PERSONAL SETTINGS

// The email address for receiving messages sent via the contact form
$recipient_email = "you@yourdomain.com";

// The name of your website
$website_name = "Phlex";

// The subject of the messages received
$subject = "[" . $website_name . "] Message sent via the contact form";

// SMTP server address
$mail_server = "mail.yourdomain.com";

// SMTP account username
$mail_user = "noreply@yourdomain.com";

// SMTP account password
$mail_password = "password";

// *** 



$timezone_offset = $_POST["timezone_offset"];
$local_unixtime=mktime(date("H"), date("i")-$timezone_offset, date("s")-date("Z"), date("m") , date("d"), date("Y"));
$date = date("m/d/Y H:i:s", $local_unixtime);

if ($_POST["name"]) $sender_name = $_POST["name"];
if ($_POST["email"]) $sender_email = $_POST["email"];
if ($_POST["phone"]) $sender_phone = $_POST["phone"];
if ($_POST["message"]) $sender_message = $_POST["message"];

$content = $date . "\n\n";
if ($sender_name) $content .= "Name: " . $sender_name . "\n";
if ($sender_email) $content .= "Email: " . $sender_email . "\n";
if ($sender_phone) $content .= "Phone: " . $sender_phone . "\n";
if ($sender_message) $content .= "\n" . $sender_message;


// *** PHP Mailer

require_once('PHPMailer/class.phpmailer.php');

$mail = new PHPMailer();
$mail->IsSMTP(); // telling the class to use SMTP
$mail->Host = $mail_server; // SMTP server
$mail->SMTPAuth = true; // enable SMTP authentication

// For Gmail SMTP server
//$mail->SMTPSecure = "ssl"; // secure transfer enabled - required for Gmail
//$mail->Host = $mail_server; // set Gmail as the SMTP server
//$mail->Port = 465; // set the SMTP port for the Gmail server

$mail->Username = $mail_user; // SMTP account username
$mail->Password = $mail_password; // SMTP account password

$mail->SetFrom($sender_email); // the address that the e-mail should appear to come from
$mail->AddReplyTo($sender_email);
$mail->Subject = $subject;
$mail->Body = $content;
$mail->CharSet = "UTF-8";
$mail->AddAddress($recipient_email);

if (!$mail->Send()) {
	echo 'status=0';
} else {
	echo 'status=1';
}

?>

