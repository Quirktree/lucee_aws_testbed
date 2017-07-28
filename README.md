docker build -t lucee-aws .

Example run ... using AWS credentials for the PSS profile in this case
docker run -p 8080:80 -v $(pwd)/www:/var/www -v $HOME/.aws:/root/.aws -e AWS_PROFILE=pss lucee-aws
