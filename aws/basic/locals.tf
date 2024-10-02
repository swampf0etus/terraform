locals {
  common_tags = {
    company       = var.company
    project       = "${var.company}-${var.project}"
    billiing_code = var.billiing_code
  }

  web_app_user_data = [
    <<END_DATA
#!/bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/index.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/girl_chase_pickle.webp /home/ec2-user/girl_chase_pickle.webp
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/girl_chase_pickle.webp /usr/share/nginx/html/
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/
END_DATA
    /*
    <<EOF
#!/bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo "<head><body><title>Pickles 1</title><h1>Have a pickle!</h1></body></head>" > /usr/share/nginx/html/index.html
EOF
*/
    ,
    <<END_DATA
#!/bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/index.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/website/girl_chase_pickle.webp /home/ec2-user/girl_chase_pickle.webp
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/girl_chase_pickle.webp /usr/share/nginx/html/
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/
END_DATA
    /*
    <<EOF
#!/bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo "<head><body><title>Pickles 2</title><h1>Have two pickles!</h1></body></head>" > /usr/share/nginx/html/index.html
EOF
*/
  ]

  s3_bucket_name = "bgra-web-app-${random_integer.s3.result}"
}



resource "random_integer" "s3" {
  min = 10000
  max = 99999
}

