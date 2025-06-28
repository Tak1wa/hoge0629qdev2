#!/bin/bash

# CloudFormation デプロイスクリプト
# 使用方法: ./deploy.sh <stack-name> <key-pair-name>

# デフォルト値
STACK_NAME=${1:-"example-dev-vpc-ec2"}
KEY_PAIR_NAME=${2:-""}
SYSTEM_NAME="example"
ENV_NAME="dev"
TEMPLATE_FILE="cloudformation/dev-vpc-ec2.yaml"

echo "CloudFormation スタックをデプロイします: $STACK_NAME"
echo "テンプレートファイル: $TEMPLATE_FILE"

# キーペア名が指定されているかチェック
if [ -z "$KEY_PAIR_NAME" ]; then
  echo "警告: キーペア名が指定されていません。EC2インスタンスにSSHアクセスできません。"
  echo "キーペア名を指定するには: ./deploy.sh $STACK_NAME <key-pair-name>"
  
  # キーペア名なしでデプロイ
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters \
      ParameterKey=SystemName,ParameterValue=$SYSTEM_NAME \
      ParameterKey=EnvName,ParameterValue=$ENV_NAME
else
  # キーペア名ありでデプロイ
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters \
      ParameterKey=SystemName,ParameterValue=$SYSTEM_NAME \
      ParameterKey=EnvName,ParameterValue=$ENV_NAME \
      ParameterKey=KeyPairName,ParameterValue=$KEY_PAIR_NAME
fi

echo "デプロイを開始しました。スタックの状態を確認するには以下のコマンドを実行してください:"
echo "aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].StackStatus'"