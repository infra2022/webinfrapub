#!/bin/bash
yum update -y
yum install -y httpd
cd /var/www/html
echo "<!DOCTYPE html>
<html>
<body>

<h1>Terraform Assignment</h1>
<p>Hello World....</p>

</body>
</html>" > ./index.html
systemctl start httpd
systemctl enable httpd
exit 0