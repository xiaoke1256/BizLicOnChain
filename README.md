BizLicOnChain
===
## 概述
&ensp;&ensp;&ensp;&ensp;
本应用的主要功能是把营业执照放在区块链（以太坊）上。在区块链上发放营业执照的作用是，不依赖于发证机关（工商局或市场监督局）就可以证明营业执照的合法性。我们做了如下设计：1.只有指定账户（address）才可以提交营业执照；2.营业执照上有发证机关的数字签名。

## 存储设计
&ensp;&ensp;&ensp;&ensp;
存储在区块链中的营业执照，结构如下：
 |属性名|解释|
 |-----|----|
 |organCode|发证机关代码|
 |licContent|证照内容(把企业名称，法定代表人等数据项拼成json串。)|
 |sign|电子签章|
 
 &ensp;&ensp;&ensp;&ensp;
 其中证照内容的结构如下：
 |字段名|解释|
 |----|----|
 |uniScId|统一社会信用码,作为企业的唯一标识|
 |corpName|企业名称|
 |leadName|法定代表人|
 |indsyCode|行业分类代码(GB/T 4754—2017)|
 |bizScope|经营范围(文字描述)|
 |regCpt|注册资金(元)|
 |provDate|核准时间(yyyy-MM-dd)|
 |limitTo|有效期至(yyyy-MM-dd)|
 |issueOrgan|发证机关(中文全称)|
