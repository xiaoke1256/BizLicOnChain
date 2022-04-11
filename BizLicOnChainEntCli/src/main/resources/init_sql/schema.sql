-- 股东表
create table if not exists STOCK_HOLDER(
	STOCK_HOLDER_ID BIGINT NOT NULL auto_increment COMMENT '主键',
	INVESTOR_NAME VARCHAR(64) COMMENT '股东姓名',
	ETH_ACCOUNT VARCHAR(64) COMMENT '股东以太坊账号（公钥）',
	ETH_PRIVATE_ACCOUNT VARCHAR(64) COMMENT '股东以太坊账号（私钥）（正式做系统时不建议）',
	INVESTOR_CETF_TYPE VARCHAR(16) COMMENT '股东身份证件类型,有效身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）',
	INVESTOR_CETF_NO VARCHAR(32) COMMENT '股东身份证件号',
	INVESTOR_CETF_HASH VARCHAR(128) COMMENT '股东身份证件,有效身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）;和证件号码组成，由冒号(:)分隔。本字段需要加密',
	CPT_AMT DECIMAL(10) COMMENT '出资额度，',
	INSERT_TIME TIMESTAMP COMMENT '插入时间',
	UPDATE_TIME TIMESTAMP COMMENT '修改时间',
	primary key(STOCK_HOLDER_ID)
);

-- 股权
create table if not exists STOCK_RIGHT_APPLY(
    APPLY_ID BIGINT NOT NULL auto_increment COMMENT '主键',
    NEW_INVESTOR_NAME VARCHAR(64) COMMENT '新股东姓名' ,
    PRICE DECIMAL(30) COMMENT '价格（以太币,wei）' ,
    CPT_AMT DECIMAL(25) COMMENT '转让额度(元)',
    NEW_INVESTOR_ACCOUNT VARCHAR(64) COMMENT '新股东账号',
    NEW_INVESTOR_CETF_TYPE VARCHAR(16) COMMENT '新股东身份证件类型,有效身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）',
    NEW_INVESTOR_CETF_NO VARCHAR(32) COMMENT '新股东身份证件号',
    NEW_INVESTOR_CETF_HASH VARCHAR(128) COMMENT '新股东身份证件,有效身份证件类型（身份证、居留证、军官证、中国护照、外国或地区护照）;和证件号码组成，由冒号(:)分隔。本字段需要加密',
    IS_ARCHIVED CHAR(1) COMMENT '是否归档',
    primary key(APPLY_ID)
);
