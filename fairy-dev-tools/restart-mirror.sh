set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发" </dev/null
(DSH_HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/home" nohup dsh --profile web --no-open --port 5599 > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot2.log" 2>&1 &)
sleep 22
grep -o "dsh web: http://127.0.0.1:[0-9]*/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot2.log" || tail -12 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot2.log"