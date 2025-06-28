# AWSリソース命名規則

## 1. 目的

命名規則を定める目的は以下のとおり。

| 目的 | 説明 |
|------|------|
| リソース構成の可視化 | 以下を容易にする<br>- リソースの役割や用途の判別<br>- システム全体の構成把握<br>- リソースの識別性向上による誤操作防止 |
| 運用効率の向上 | 以下の運用作業を効率的に実施する<br>- リソースの検索とフィルタリング<br>- 複数リソースの一括操作<br>- 運用自動化<br>- リソース名の決定 |
| セキュリティ管理の強化 | きめ細かな権限制御 |

> **💡 ポイント**  
> 目的や利用イメージを最初に決めておくと、命名規則の合意形成をスムーズに行えます。

命名規則によって以下の識別を明確にする。

- 対象システム
- 環境 (本番、ステージング、開発など)
- AWS リソース
- 役割
- 用途

## 2. AWSリソースの命名規則

### 2.1. 命名規則の基本ルール

命名規則の基本ルールは以下のとおり。

- 単語間はハイフン (`-`) で結ぶ
- ハイフンが使用できない場合はアンダースコア (`_`)を使用する
- 英小文字と数字のみを使用
- 原則、マルチバイト文字、英大文字、アンダースコア (`_`)、その他の記号は使用しない
- 原則、`{System}-{Env}-{ResourceType}-{Summary}`というフォーマットに沿った名前を付与する

#### 命名規則の各要素

| 要素 | 詳細 |
|------|------|
| **System** | このリソースによって構成されるシステム名<br>本プロジェクトでは`example`を使用する |
| **Env** | リソースの環境名<br>- 本番環境 : `prod`<br>- 本番DR環境 : `proddr`<br>- ステージング環境 : `stg`<br>- ステージングDR環境：`stgdr`<br>- 開発環境 : `dev`<br><br>複数環境で共通的に使用するリソースは重要度の最も高いリソースの環境名を使用する<br>例：本番環境と本番DR環境、ステージング環境で共通的に使用するリソース → `prod` |
| **ResourceType** | リソースの種類を表す略語<br>リソースIDの先頭に付けられているもの、もしくはARNのresource-type、serviceに該当する<br><br>例：<br>- `sg-1234567890ab` → `sg`<br>- `arn:${Partition}:iam::${Account}:role/${RoleNameWithPath}` → `role`<br>- `arn:${Partition}:ec2:${Region}:${Account}:instance/${InstanceId}` → `ec2`<br><br>場合によっては複数単語で構成される<br>例：`tgw-attach-1234567890ab` → `tgw-attach`<br><br>長いものや分かりにくいものは分かりやすい名前を付与する<br>例：<br>- `elasticloadbalancing` → `alb`<br>- `autoScalingGroup` → `asg` |
| **Summary** | リソースの役割、要旨を表す短い文言を任意で記述する<br>SubnetTypeやRole、Usageなど細かく分類される |

#### Summaryの詳細分類

| 分類 | 説明 | 例 |
|------|------|-----|
| **SubnetType** | サブネットの種類<br>- インターネットとインバウンド/アウトバウンドでルーティング可能 → `public`<br>- インターネットへアウトバンドでルーティング可能 → `private`<br>- インターネットとのルーティング不可 → `isolated` | |
| **Role** | リソースの機能的な役割<br>例：Webサーバ → `web`、DBサーバ → `db`<br><br>複数単語の場合はハイフン(-)で結ぶ<br>例：Web管理サーバ → `web-admin` | |
| **Usage** | リソースの用途<br>例：<br>- 各種エンドポイント配置用 → `endpoint`<br>- オンプレミスとVPC間通信管理用 → `ns` (North-South)<br>- VPC間通信管理用 → `ew` (East-West)<br>- SMBクライアント用 → `smb-client` | |
| **AzId** | AZ IDの末尾<br>例：`apne1-az1` → `az1`<br><br>複数リージョンにデプロイさせActive/Activeで動作させるリソースの場合はAZ IDをそのまま使用することを検討する | |
| **Site** | 接続拠点名<br>例：東京拠点 → `tokyo` | |

#### 表記する情報の順番について

表記する情報の順番としては以下のパターンがある：

1. `{System}-{Env}-{Summary}-{ResourceType}`
2. `{System}-{Env}-{ResourceType}-{Summary}`
3. `{Env}-{System}-{ResourceType}-{Summary}`

**推奨：`{System}-{Env}-{ResourceType}-{Summary}`**

理由：
- 新しい属性を追加する場合の拡張性が良い
- 情報は途中に挿入するより、後ろから追加する方が管理しやすい
- 複数のリソースタイプについて言及する際の認識齟齬を防げる

#### 省略を検討する場面

| 要素 | 省略を検討する場面 |
|------|-------------------|
| **System** | - AWS アカウントがシステム単位で分離されており、リソース情報をマルチアカウントで集約した際に、リソース名に含まれるシステム名をキーとして処理を行わない場合<br>- 一時的な検証用のAWSアカウントであり、短期間でAWSアカウントをクローズする場合<br>- 個人検証用のAWSアカウントであり、他メンバーと共有する必要がない場合 |
| **Env** | - AWS アカウントが環境単位で分離されており、リソース情報をマルチアカウントで集約した際に、リソース名に含まれる環境名をキーとして処理を行わない場合<br>- 一時的な検証用のAWSアカウントであり、短期間でAWSアカウントをクローズする場合<br>- 個人検証用のAWSアカウントであり、他メンバーと共有する必要がない場合 |
| **ResourceType** | - 省略としたとしても、チーム内でのコミュニケーションやドキュメント上で、リソースの種類が文脈から明確に理解できる場合<br>- リソース名の文字数を極力少なくしたい場合<br>- 一時的な検証用のAWSアカウントであり、短期間でAWSアカウントをクローズする場合<br>- 個人検証用のAWSアカウントであり、他メンバーと共有する必要がない場合 |

> **⚠️ 注意**  
> 命名規則を守るために実装コストや管理運用コストが高くなると本末転倒です。物理名を指定した方がトータルで見た時にメリットが大きい場合は物理名を指定しましょう。

### 2.2. 命名規則の適用例外

上述の命名規則の基本ルールの適用範囲外は以下のとおり：

| 適用範囲外のリソースの条件 | 例 |
|---------------------------|-----|
| AWSのリソース以外 | - Amazon FSx for NetApp ONTAPのSnapshot Policy |
| 階層構造で名前付けを行うことが一般的なリソース | - CloudWatch Logsロググループ<br>- SSM Parameter Store<br>- Secrets Manager |
| 命名規則に制約がある場合 | - AWS WAFのログの出力先とするS3バケット名 |
| 自動で作成されるリソース | - Service-Linked Role<br>- EC2インスタンスやRDS DBインスタンスのENI<br>- EC2インスタンスのEBSボリューム |
| 以下条件に当てはまる、あるリソースに従属しているリソース<br>- 単独では存在できない<br>- 親リソースの削除と共に自動的に削除される<br>- 親リソースの一部として管理される<br>- 親リソースは一つのみであり、複数の親リソースから参照されない | - IAMロールのインラインポリシー<br>- S3のライフサイクルルール |
| デフォルトで作成されるリソース | - Security Group<br>- NACL<br>- DHCP Options Set |
| バックアップ | - EBSスナップショット<br>- RDS DBスナップショット<br>- AMI |
| 名前の設定を行うのに設定コストがかかるリソース | - AWS CDK L2 ConstructでDefault Construct以外に自動作成されるリソース |
| そのリソース名をベースに検索、管理しないと思われるリソース | - VPC Flow Logs |

### 2.3. リソースごとの設定例

| AWSリソース | 命名規則 | 例 | 文字数上限 | 作成後の名前の変更 | 備考 |
|-------------|----------|-----|-----------|-------------------|------|
| **VPC** | `{System}-{Env}-vpc` | `example-prod-vpc` | 255文字 (タグの上限) | 可 | |
| **Subnet** | `{System}-{Env}-subnet-{SubnetType}-{Usage}-{AzId}` | `example-prod-subnet-private-endpoint-az1` | 255文字 (タグの上限) | 可 | |
| **Route Table** | `{System}-{Env}-rtb-{SubnetType}-{Usage}-{AzId}` | `example-prod-rtb-private-endpoint-az1` | 255文字 (タグの上限) | 可 | 各AZのサブネットごとにルートテーブルを分割しないのであれば、`{AzId}`は不要 |
| **Security Group** | `{System}-{Env}-sg-{SubSystem}-{Role}-{ResourceType}` | `example-prod-sg-nextcloud-web-ec2` | 255文字 | 不可 | |
| **Network ACL** | `{System}-{Env}-acl` | `example-prod-acl` | 255文字 (タグの上限) | 可 | |
| **DHCP option sets** | `{System}-{Env}-dopt` | `example-prod-dopt` | 255文字 (タグの上限) | 可 | |
| **Internet Gateway** | `{System}-{Env}-igw` | `example-prod-igw` | 255文字 (タグの上限) | 可 | |
| **NAT Gateway** | `{System}-{Env}-natgw-{AzId}` | `example-prod-natgw-az1` | 255文字 (タグの上限) | 可 | |
| **Elastic IP** | `{System}-{Env}-eip-(natgw-{AzId}\|nlb)` | `example-prod-eip-natgw-az1` | 255文字 (タグの上限) | 可 | |
| **VPC Endpoint** | `{System}-{Env}-vpce-{Service}-(interface\|gateway\|resource\|sn)` | `example-prod-vpce-logs` | 255文字 (タグの上限) | 可 | `(interface\|gateway\|resource\|sn)`はお好みで |
| **Managerd Prefix List** | `{System}-{Env}-pl-{Usage}` | `example-prod-pl-smb-client` | 255文字 | 可 | |
| **Transit Gateway** | `{System}-{Env}-tgw` | `example-prod-tgw` | 255文字 (タグの上限) | 可 | |
| **Transit Gateway attachment** | `{System}-{Env}-tgw-attach-(vpc\|vpn-{Site}\|dxgw-{Site})` | `example-prod-tgw-attach-vpn-tokyo` | 255文字 (タグの上限) | 可 | `{System}-{Env}`はTransit Gateway attachmentの接続先リソースのものを使用 |
| **Transit Gateway route table** | `{System}-{Env}-tgw-rtb-{Usage}` | `example-prod-tgw-rtb-ns-ew` | 255文字 (タグの上限) | 可 | `{Usage}`は通信の関係性を指す |
| **Customer Gateway** | `{System}-{Env}-cgw-{Site}` | `example-prod-cgw-tokyo` | 255文字 (タグの上限) | 可 | |
| **Site-to-Site VPN** | `{System}-{Env}-vpn-{Site}` | `example-prod-vpn-tokyo` | 255文字 (タグの上限) | 可 | |
| **Direct Connect Gateway** | `{System}-{Env}-dxgw-{Site}` | `example-prod-dxgw-tokyo` | 100文字 | 可 | |
| **RAM** | `{System}-{Env}-ram` | `example-prod-ram` | 255文字 (タグの上限) | 可 | |
| **EC2 Instance** | `{System}-{Env}-ec2-{SubSystem}-{Role}` | `example-prod-ec2-nextcloud-web` | 255文字 (タグの上限) | 可 | Auto Scailingを使わないクラスター構成の場合EC2インスタンス毎に末尾に連番を付与する (`-001`や`-002`など) |
| **Auto Scaling Group** | `{System}-{Env}-asg-{SubSystem}-{Role}` | `example-prod-asg-nextcloud-web` | 255文字 | 不可 | |
| **起動テンプレート** | `{System}-{Env}-lt-{SubSystem}-{Role}` | `example-prod-lt-nextcloud-web` | 128文字 | 不可 | |
| **Key Pair** | `{System}-{Env}-keypair-{SubSystem}-{Role}` | `example-prod-kerypair-newxcloud-web` | 255文字 | 不可 | |
| **ELB** | `{System}-{Env}-(alb\|nlb\|gwlb)-{SubSystem}-{Role}` | `example-prod-alb-newxcloud-web` | 32文字 | 不可 | 複数のサブシステムでALBを共有する場合は`{SubSystem}-{Role}`は不要 |
| **ELB Target Group** | `{System}-{Env}-elb-tg-{SubSystem}-{Role}` | `example-prod-elb-tg-newxcloud-web` | 32文字 | 不可 | |
| **ACM** | `{System}-{Env}-acm-{SubSystem}` | `example-prod-acm-nextcloud-web` | 255文字 (タグの上限) | 可 | |
| **S3 Bucket** | `{System}-{Env}-bucket-{Usage}-{AccountId}` | `example-prod-bucket-vpc-flowlogs-123456780012` | 63文字 | 不可 | 公開するS3バケットには`{AccountId}`を付与しない |
| **IAM Role** | `{System}-{Env}-role-{SubSystem}-{Role}` | `example-prod-role-nextcloud-web` | 64文字 | 不可 | |
| **RDS DB Instance / Aurora DB Insance** | `{System}-{Env}-rds-{SubSystem}` | `example-prod-rds-nextcloud` | 63文字 | 可 | 変更する際はRDS DBインスタンスの再起動が必要 |
| **RDS DB Cluster / Aurora DB Clusetr** | `{System}-{Env}-rds-cluster-{SubSystem}` | `example-prod-rds-cluster-nextcloud` | 63文字 | 可 | 変更する際はRDS DBインスタンスの再起動が必要 |
| **RDS Subnet Group** | `{System}-{Env}-rds-subgrp` | `example-prod-rds-subgrp` | 255文字 | 不可 | |
| **RDS Parameter Group** | `{System}-{Env}-rds-pg-{SubSystem}` | `example-prod-rds-pg-nextcloud` | 255文字 | 不可 | |
| **RDS Cluster Parameter Group** | `{System}-{Env}-rds-cluster-pg-{SubSystem}` | `example-prod-rds-cluster-pg-nextcloud` | 255文字 | 不可 | |
| **RDS Option Group** | `{System}-{Env}-rds-og-{SubSystem}` | `example-prod-rds-og-nextcloud` | 255文字 | 不可 | |
| **FSxN File system** | `{System}-{Env}-fsxn` | `example-prod-fsxn` | 255文字 (タグの上限) | 可 | |
| **FSxN SVM** | `{System}-{Env}-svm-{SubSystem}` | `example-prod-svm-general` | 47文字 | 不可 | |
| **FSxN Volume** | `{System}{Env}_fsvol_{SubSystem}{JunctionPath}` | `example_prod_fsvol_general_poc` | 203文字 | 可 | `{JunctionPath}`はボリュームのジャンクションパス<br>ジャンクションパスに含まれる`/`は`_`に置換 |
| **EFS File system** | `{System}-{Env}-efs-{SubSystem}-{Role}-{Usage}` | `example-prod-efs-nextcloud-web-contents` | 255文字 (タグの上限) | 可 | |
| **KMS** | `{System}-{Env}-key-{SubSystem}` | `example-prod-key-nextcloud` | 256文字 (タグおよびエイリアスの上限) | エイリアスは不可 | |
| **AWS WAF** | `{System}-{Env}-webacl-{SubSystem}` | `example-prod-webacl-nextcloud` | 128文字 | 不可 | サブシステムでまとめて使用する場合は`{SubSystem}`を省略 |
| **AWS Backup Vault** | `{System}-{Env}-backup-vault-{SubSystem}` | `example-prod-backup-vault-nextcloud` | 50文字 | 不可 | サブシステムでまとめて使用する場合は`{SubSystem}`を省略<br>同一サブシステム内であっても役割によってWORM機能を使用したい場合は末尾に`{Role}`を付与する |
| **AWS Backup Plan** | `{System}-{Env}-backup-plan-{SubSystem}` | `example-prod-backup-plan-nextcloud` | 50文字 | 不可 | サブシステムでまとめて使用する場合は`{SubSystem}`を省略<br>同一サブシステム内であっても役割によって取得開始時刻や保持期間、コピー有無によって異なる場合は末尾に`{Role}`を付与する |
| **AWS Backup Selection** | `{System}-{Env}-backup-selection-{SubSystem}` | `example-prod-backup-selection-nextcloud` | 50文字 | 不可 | サブシステムでまとめて使用する場合は`{SubSystem}`を省略<br>同一サブシステム内であっても役割によって取得開始時刻や保持期間、コピー有無によって異なる場合は末尾に`{Role}`を付与する |
| **CloudWatch Alarm** | `{System}-{Env}-alarm-{ResourceType}-{SubSystem}-{Role}-{MetricName}` | `example-prod-alarm-fsvol-general-poc-StorageCapacityUtilization` | 255文字 | 不可 | |
| **SNS Topic** | `{System}-{Env}-sns-{SubSystem}-{Usage}` | `example-prod-sns-nextcloud-warning-alarm` | 256文字 | 不可 | サブシステムでまとめて使用する場合は`{SubSystem}`を省略 |

> **💡 ポイント**  
> 作成するリソースの種類ごとに例を追加しておくと、ブレが少ないでしょう。リソースによっては32文字や50文字など名前が長すぎると付与できないことが起こりえます。リソース名に全ての情報を盛り込む必要はありません。過剰になるのではなく、必要十分となるように設定しましょう。

## 3. タグ

上記で定めた規則は各種タグの値として設定する。

運用性向上のため以下のタグを全リソースに共通で付与する。

| タグキー | タグ値 | 備考 |
|----------|--------|------|
| **Name** | `{System}-{Env}-{ResourceType}-{Summary}` | 命名規則で定めたリソース名称<br>※ 「2.2. 命名規則の適用例外」に当てはまるリソースには上述のタグを付与しない |
| **Env** | `(prod\|proddr\|stg\|stgdr)` | 環境名<br>- 本番環境 : `prod`<br>- ステージング環境 : `stg`<br>- 本番DR環境 : `proddr`<br>- ステージングDR環境 : `stgdr` |
| **System** | `example` | システムを識別可能な文字列 |
| **SubSystem** | `example` | サブシステムを識別可能な文字列 |
| **Project** | `project` | プロジェクトを識別可能な文字列 |
| **CmBillingGroup** | `project` | クラスメソッドポータルサイトでコスト分析に使用する |

> **⚠️ 注意**  
> ガチガチなルールを作ると、あとで設定や管理をするのが大変になったりするので、無理のない範囲で定義しましょう。

### 自動化用タグ

何らかの処理を自動化している場合はタグを活用し、対象システムやタスク実行時間を制御する。

| タグキー | タグ値 | 備考 |
|----------|--------|------|
| **BackupSelection** | `example-prod-backup-selection` | AWS Backupによるバックアップ取得管理用タグ<br>AWS BackupのBackup Selectionにて、本タグが付与されたリソースのバックアップを取得するよう設定する |
| **SsmPatchTarget** | `(true\|false)` | SSM Patch Manager適用制御用タグ<br>SSM Patch Managerにてこのタグが付与されてるリソースに対してパッチ適用をするように設定する |
| **SsmHostManagementTarget** | `(true\|false)` | SSM Host Management制御用タグ<br>SSM Quick Setupにてこのタグが付与されてるリソースに対してSSM Agentのアップデートやインベントリ収集をするように設定する |

## 参考情報

- [弊社で使っているAWSリソースの命名規則を紹介します | DevelopersIO](https://dev.classmethod.jp/articles/aws-resource-naming-rule-2024/)
- [AWS リソースのタグ管理 〜タグ付けと統制〜（前編） | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-resource-tagging-management-part1/)
- [AWS リソースのタグ管理 〜タグ付けと統制〜（後編） | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-resource-tagging-management-part2/)
- [AWSのABAC(タグに基づいたアクセス制御)の設計/運用のポイントを考える | DevelopersIO](https://dev.classmethod.jp/articles/aws-abac-design-operation-points/)
- [AWS タグの活用方法と命名ルールを考える | DevelopersIO](https://dev.classmethod.jp/articles/aws-tag-usage-naming-rule/)
- [ベストプラクティスと戦略 - AWS リソースのタグ付けとタグエディタ](https://docs.aws.amazon.com/ja_jp/ARG/latest/userguide/best-practices-and-strats.html)
- [カテゴリのタグ付け - AWS リソースのタグ付けとタグエディタ](https://docs.aws.amazon.com/ja_jp/ARG/latest/userguide/tag-categories.html)
