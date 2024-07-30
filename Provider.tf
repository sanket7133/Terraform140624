terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~>5.46"
    }
  }
}
  provider "aws"{
    region= "ap-south-1"
    profile= "sanket"
  } 
