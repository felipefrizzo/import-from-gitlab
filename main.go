package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func main() {
	curl()

	config := aws.NewConfig().WithRegion("us-east-1").WithEndpoint("http://localstack:4566").WithS3ForcePathStyle(true)
	session, err := session.NewSession(config)
	if err != nil {
		panic(err)
	}

	client := s3.New(session)

	buckets, err := client.ListBuckets(&s3.ListBucketsInput{})
	if err != nil {
		panic(err)
	}
	fmt.Println(buckets)
}

func curl() {
	url := "https://localstack:4566"
	method := "GET"

	client := &http.Client{}
	req, err := http.NewRequest(method, url, nil)

	if err != nil {
		fmt.Println(err)
		return
	}
	res, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer res.Body.Close()

	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(string(body))
}
