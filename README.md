# roundcube-docker

Usage:
```
sudo docker build .
sudo docker run --env "PADMIN=postfixadminuser" --env "PADMP=postfixadminpassword" -d -p 25:25 -p 80:80 -p 110:110 -p 143:143 -p 465:465 -p 993:993 -p 995:995  DOCKER-IMAGE-ID
```


