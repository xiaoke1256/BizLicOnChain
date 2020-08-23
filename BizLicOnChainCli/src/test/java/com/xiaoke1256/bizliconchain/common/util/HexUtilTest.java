package com.xiaoke1256.bizliconchain.common.util;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class HexUtilTest {

	@Test
	public void testParse() {
		assertEquals(0, HexUtil.parse("0x00000000000"));
		
		assertEquals(1, HexUtil.parse("0x00000000001"));
	}
}
