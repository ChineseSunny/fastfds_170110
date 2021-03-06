#停止tracker
sudo fdfs_trackerd /etc/fdfs/tracker.conf stop

#停止storage
sudo fdfs_storaged /etc/fdfs/storage.conf stop

#启动tracker
sudo fdfs_trackerd /etc/fdfs/tracker.conf
#启动storage
sudo fdfs_storaged /etc/fdfs/storage.conf


#启动redis
redis-server  ./redis.conf

#关闭nginx服务器
sudo /usr/local/nginx/sbin/nginx -s stop

#启动nginx服务器
sudo /usr/local/nginx/sbin/nginx

#杀死已经启动的后台CGI程序
kill -9 `ps aux | grep "fcgi" | grep -v "grep" | awk '{print $2}'`
kill -9 `ps aux | grep "echo_cgi" | grep -v "grep" | awk '{print $2}'`
kill -9 `ps aux | grep "upload_cgi" | grep -v "grep" | awk '{print $2}'`
kill -9 `ps aux | grep "data_cgi" | grep -v "grep" | awk '{print $2}'`
kill -9 `ps aux | grep "reg_cgi" | grep -v "grep" | awk '{print $2}'`

#启动demo_cgi
spawn-fcgi -a 127.0.0.1 -p 8081 -f ./fcgi
spawn-fcgi -a 127.0.0.1 -p 8082 -f ./echo_cgi
spawn-fcgi -a 127.0.0.1 -p 8083 -f ./upload_cgi
spawn-fcgi -a 127.0.0.1 -p 8084 -f ./data_cgi
spawn-fcgi -a 127.0.0.1 -p 8085 -f ./reg_cgi
