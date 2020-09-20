package com.xiaoke1256.bizliconchain.controller;

import java.math.BigDecimal;
import java.util.Date;

import org.apache.commons.lang.time.DateUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.xiaoke1256.bizliconchain.SpringbootApplication;
import com.xiaoke1256.bizliconchain.bo.Bizlic;
import com.xiaoke1256.bizliconchain.common.mvc.RespMsg;

@RunWith(SpringRunner.class)
@SpringBootTest(classes=SpringbootApplication.class)
public class BizLicControllerTest {
	@Autowired
	private BizLicController bizLicController;
	
	@Test
	public void testPutBizlic() {
		Bizlic bizlic = new Bizlic();
		bizlic.setUniScId("1231000083237TEST537");
		bizlic.setCorpName("测试KKK股份有限公司");
		bizlic.setLeadName("李四 ");
		bizlic.setIndsyCode("6432");
		bizlic.setIssueOrgan("上海市市场监督局");
		bizlic.setRegCpt(BigDecimal.valueOf(1250000.00));
		bizlic.setProvDate(new Date());
		bizlic.setLimitTo(DateUtils.addYears(new Date(), 3));
		bizLicController.putBizlic(bizlic);
		
	}
	
	@Test
	public void testGetBizlic() {
		RespMsg msg = bizLicController.getBizlic("1231000083237TEST537");
		System.out.println(msg.getData().toString());
		Bizlic bizLic = (Bizlic)msg.getData();
		System.out.println("corpName:"+bizLic.getCorpName());
		System.out.println("leadName:"+bizLic.getLeadName());
		System.out.println("provDate:"+bizLic.getProvDate());
		System.out.println("issueOrgan:"+bizLic.getIssueOrgan());
	}
}
