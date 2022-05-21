package com.xiaoke1256.bizliconchain.common.web3j.cli;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.xiaoke1256.bizliconchain.SpringbootApplication;

@RunWith(SpringRunner.class)
@SpringBootTest(classes=SpringbootApplication.class)
public class DoTestClient {
	@Autowired
	private TestClient testClient;
	
	@Test
	public void testDoSomething() {
		testClient.doSomething("aaa");
	}
}
