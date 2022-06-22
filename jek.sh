# !/bin/bash

#Delete metadata from images

##Check for exiftool command


  if [ -x "$(command -v exiftool)" ]; then cd /Users/victor/Desktop/img/; exiftool -all= *.jpg *.png *.JPG *.PNG *.gif *.GIF *.webp *.WEBP 
  else
    if [ -x "$(command -v pacman)" ]; then sudo pacman -S exiftool
    elif [ -x "$(command -v apt)" ]; then sudo apt install exiftool -y

      
  fi
  fi 




#Build and deploy website

bundle exec jekyll build --source /home/cool-guy/gomidee/ --destination /var/www/gomidee
