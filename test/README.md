# Test

This folder contains a series of _test.go files written in Go using [Terratest](https://github.com/gruntwork-io/terratest) library that allow for automatic testing of the Terraform configurations in the [examples](../examples) folder.

## Pre-requisites

* [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
* Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.

## Quick start

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
$ export AWS_ACCESS_KEY_ID=(your access key id)
$ export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Change directory:

```
$ cd test
```

Run the Go dependency tool:

```
$ dep init
$ dep ensure
```

Run a particular test:

```
$ go test -v -timeout 30m TestAlbExample
```

Run all tests in the folder in parallel (by default the number of tests that run in parallel is equal to how many CPUs you have on your computer):

```
$ go test -v -timeout 30m
```

Force Go to run up to two tests in parallel:

```
$ go test -v -timeout 30m -parallel 2
```

## References

* [Terratest Website](https://terratest.gruntwork.io/)
* [Getting Started with Terratest](https://terratest.gruntwork.io/docs/getting-started/quick-start/)
* [Terratest Documentation](https://terratest.gruntwork.io/docs/)