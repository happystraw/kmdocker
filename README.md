# Dockerfile for KM developer

### USAGE

>**Notice: This Dockerfile does not contain nginx.**

```shell
# build
docker build -t kmhtgl:v1.0.0 . -f ./php/5.4/Dockerfile

# run
docker run -d -p 9000:9000 --name kmhtgl kmhtgl:v1.0.0
```