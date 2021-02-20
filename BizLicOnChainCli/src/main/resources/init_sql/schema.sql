create table if not exists ETH_TRAS_LOG(
	LOG_ID BIGINT NOT NULL PRIMARY KEY auto_increment COMMENT '主键',
	NONCE BIGINT COMMENT 'NONCE',
	CONTRACT_ADDRESS VARCHAR(64) COMMENT '合约地址',
	METHOD VARCHAR(64) COMMENT '合约方法',
	BIZ_KEY VARCHAR(512) COMMENT '相对应的业务主键，比如申请案号、统一社会信用码',
	TRAS_HASH VARCHAR(64) COMMENT 'HASH',
	TRAS_STATUS VARCHAR(2) COMMENT 'STATUS',
	STATUS VARCHAR(2) COMMENT '本系统自定义的STATUS(S:成功;C:已提交;E:错误)',
	GAS_PRICE DECIMAL(32) COMMENT 'GAS_PRICE(单位是微)',
	GAS_USED DECIMAL(32) COMMENT 'GAS_USED',
	ERR_MSG VARCHAR(1024) COMMENT '错误原因'
);

