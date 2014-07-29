<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
$a = range(1,20);
//vcho($a);

class classA{
    public $pro;
}
$a = new classA();
$a->pro = 111;
vcho($a);

function vcho($msg) {

    require 'class/WebsocketClient.php';
    require 'class/SocketClient.php';
    if (is_array($msg) || is_object($msg)) {
        $msg = var_export($msg, true);
    }

    $backInfo = debug_backtrace();
    $location = current($backInfo);
    $client = new SocketClient;
    $client->connect('localhost', 9000, "/");
    
    $payload = json_encode(array(
        'name' => $location['file'],
        //'name' => "aaa",
        'time' => "[" . date("Y-m-d H:i:s") . "]",
        'line' => $location['line'],
        'message' => $msg,
        'color' => 'FF7000',
        'type' => 'msg'
    ));
    
    $client->sendData($payload);
}

