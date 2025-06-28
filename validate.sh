#!/bin/bash

# CloudFormation テンプレート検証スクリプト
# 使用方法: ./validate.sh

TEMPLATE_FILE="cloudformation/dev-vpc-ec2.yaml"

echo "CloudFormation テンプレートを検証します: $TEMPLATE_FILE"

# テンプレートの検証
aws cloudformation validate-template --template-body file://$TEMPLATE_FILE

if [ $? -eq 0 ]; then
  echo "テンプレートは有効です。"
else
  echo "テンプレートに問題があります。エラーを修正してください。"
  exit 1
fi