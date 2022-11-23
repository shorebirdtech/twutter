This directory shoud not exist. The user shouldn't even need to
know what Docker is.

## Building docker files locally

From the root:
```
docker build -f .\dockerfiles\frontend.dockerfile -t frontend . 
docker build -f .\dockerfiles\backend.dockerfile -t backend .
```

Try adding `--pull` to that line if it complains your dart version
is out of date.