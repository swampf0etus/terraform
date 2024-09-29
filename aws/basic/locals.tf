locals {
  common_tags = {
    company       = var.company
    project       = "${var.company}-${var.project}"
    billiing_code = var.billiing_code
  }

  web_app_user_data = [
    <<EOF
#!/bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo "<head><body><title>Pickles 1</title><h1>Have a pickle!</h1></body></head>" > /usr/share/nginx/html/index.html
EOF
    ,
    <<EOF
#!/bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo "<head><body><title>Pickles 2</title><h1>Have two pickles!</h1></body></head>" > /usr/share/nginx/html/index.html
EOF
  ]
}
