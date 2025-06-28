# 開発環境用 AWS CloudFormation テンプレート

このリポジトリには、開発環境用のAWS CloudFormationテンプレートが含まれています。テンプレートはVPCとEC2インスタンスを作成します。

## テンプレートの概要

`cloudformation/dev-vpc-ec2.yaml` テンプレートは以下のリソースを作成します：

### ネットワークリソース
- VPC (`example-dev-vpc`)
- パブリックサブネット (`example-dev-subnet-public-az1`)
- プライベートサブネット (`example-dev-subnet-private-az1`)
- インターネットゲートウェイ (`example-dev-igw`)
- ルートテーブル
  - パブリックルートテーブル (`example-dev-rtb-public`)
  - プライベートルートテーブル (`example-dev-rtb-private`)

### コンピューティングリソース
- EC2インスタンス (`example-dev-ec2-web`)
- EC2セキュリティグループ (`example-dev-sg-web-ec2`)

## パラメータ

テンプレートには以下のパラメータがあります：

| パラメータ名 | デフォルト値 | 説明 |
|------------|------------|------|
| SystemName | example | リソース命名用のシステム名 |
| EnvName | dev | リソース命名用の環境名 (dev, stg, prod) |
| VpcCidr | 10.0.0.0/16 | VPCのCIDRブロック |
| PublicSubnetCidr | 10.0.0.0/24 | パブリックサブネットのCIDRブロック |
| PrivateSubnetCidr | 10.0.1.0/24 | プライベートサブネットのCIDRブロック |
| InstanceType | t3.micro | EC2インスタンスタイプ |
| KeyPairName | (空) | SSHアクセス用のEC2キーペア名 |
| SubSystem | example | リソースタグ付け用のサブシステム名 |
| Project | project | リソースタグ付け用のプロジェクト名 |

## デプロイ方法

### AWS Management Consoleを使用する場合

1. AWS Management Consoleにログインします
2. CloudFormationサービスに移動します
3. 「スタックの作成」をクリックします
4. 「テンプレートの準備完了」を選択します
5. 「テンプレートファイルのアップロード」を選択し、`dev-vpc-ec2.yaml`ファイルをアップロードします
6. 「次へ」をクリックします
7. スタック名とパラメータを入力します
8. 「次へ」をクリックします
9. スタックオプションを設定します（オプション）
10. 「次へ」をクリックします
11. 設定を確認し、「スタックの作成」をクリックします

### AWS CLIを使用する場合

```bash
aws cloudformation create-stack \
  --stack-name example-dev-vpc-ec2 \
  --template-body file://cloudformation/dev-vpc-ec2.yaml \
  --parameters \
    ParameterKey=SystemName,ParameterValue=example \
    ParameterKey=EnvName,ParameterValue=dev \
    ParameterKey=KeyPairName,ParameterValue=your-key-pair-name
```

## 出力

テンプレートは以下の出力を提供します：

| 出力名 | 説明 |
|--------|------|
| VpcId | VPC ID |
| PublicSubnetId | パブリックサブネット ID |
| PrivateSubnetId | プライベートサブネット ID |
| EC2SecurityGroupId | EC2セキュリティグループ ID |
| EC2InstanceId | EC2インスタンス ID |
| EC2PublicIP | EC2インスタンスのパブリックIPアドレス |

## リソース命名規則

このテンプレートでは、以下の命名規則に従ってリソースを作成します：

- 基本フォーマット: `{System}-{Env}-{ResourceType}-{Summary}`
- 例: `example-dev-vpc`, `example-dev-ec2-web`

## タグ付け

すべてのリソースには以下のタグが付与されます：

- Name: リソース名（命名規則に従う）
- Env: 環境名（dev, stg, prod など）
- System: システム名
- SubSystem: サブシステム名
- Project: プロジェクト名
- CmBillingGroup: プロジェクト名（EC2インスタンスのみ）